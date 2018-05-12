//
//  ApplyPatch.cpp
//  imgpatchtools
//
//  Created by Erfan Abdi on 7/19/17.
//  Copyright © 2017 Erfan Abdi. All rights reserved.
//

#include <iostream>
#include "applypatch/applypatch.h"
#include "edify/expr.h"

#include <memory>
#include <string>
#include <vector>
#include <string.h>

#include <android-base/parseint.h>
#include <android-base/strings.h>
#include <android-base/stringprintf.h>

// <file> <target> <tgt_sha1> <size> <init_sha1> <patch>
int ApplyPatchFn(const char* name, State* state, int argc, char * argv[]) {
    char* source_filename = argv[1];
    char* target_filename = argv[2];
    char* target_sha1 = argv[3];
    char* target_size_str = argv[4];
    char* bonus_filename = (argc % 2) == 0 ? argv[argc - 1] : NULL;
    Value bonus_data;
    
    size_t target_size;
    if (!android::base::ParseUint(target_size_str, &target_size)) {
        printf("%s(): can't parse \"%s\" as byte count\n",
                   name, target_size_str);
        return kArgsParsingFailure;
    }
    
    int patchcount = (argc-5) / 2;
    
    std::vector<char*> patch_sha_str;
    std::vector<Value*> patch_ptrs;
    
    for (int i = 0; i < patchcount * 2; i += 2) {
        Value patch_value;
        patch_value.type = VAL_BLOB;
        
        FILE *rm;
        int length;
        rm = fopen(argv[i+6], "r");
        fseek (rm, 0, SEEK_END);
        length = ftell (rm);
        fseek (rm, 0, SEEK_SET);
        patch_value.data = (char*)malloc ((length+1)*sizeof(char));
        
        if (patch_value.data)
        {
            fread (patch_value.data, sizeof(char), length, rm);
        }
        fclose (rm);
        
        patch_value.size = length;
        
        patch_sha_str.push_back(argv[i+5]);
        patch_ptrs.push_back(&patch_value);
    }
    
    if (bonus_filename != NULL) {
        bonus_data.type = VAL_BLOB;

        FILE *rm;
        int length;
        rm = fopen(bonus_filename, "r");
        fseek (rm, 0, SEEK_END);
        length = ftell (rm);
        fseek (rm, 0, SEEK_SET);
        bonus_data.data = (char*)malloc ((length+1)*sizeof(char));
        
        if (bonus_data.data)
        {
            fread (bonus_data.data, sizeof(char), length, rm);
        }
        fclose (rm);
        
        bonus_data.size = length;
    }
    
    std::string dirname = CACHE_TEMP_DIR;
    struct stat sb;
    int res = stat(dirname.c_str(), &sb);
    
    if (res == -1 && errno != ENOENT) {
        printf("cache dir \"%s\" failed: %s\n",
               dirname.c_str(), strerror(errno));
        return -1;
    } else if (res != 0) {
        printf("creating cache dir %s\n", dirname.c_str());
        res = mkdir(dirname.c_str(), CACHE_DIR_MODE);
        
        if (res != 0) {
            printf("mkdir \"%s\" failed: %s\n",
                   dirname.c_str(), strerror(errno));
            return -1;
        }
        
        // Created directory
    }
    
    printf("cache dir: %s\n", dirname.c_str());
    
    int result = applypatch(source_filename, target_filename,
                            target_sha1, target_size,
                            patchcount, patch_sha_str.data(), patch_ptrs.data(),
                            bonus_filename != NULL ? &bonus_data : NULL);
    
    if (rmdir(CACHE_TEMP_DIR) == -1) {
        printf("rmdir \"%s\" failed\n", CACHE_TEMP_DIR);
    }
    
    return result;
}

int main(int argc, char * argv[]) {
    if (argc < 7) {
        printf("usage: %s <file> <target> <tgt_sha1> <size> <init_sha1(1)> <patch(1)> [init_sha1(2)] [patch(2)] ... [bonus]\n\n",argv[0]);
        printf("\t<file> = source file from rom zip\n");
        printf("\t<target> = target file (use \"-\" to patch source file)\n");
        printf("\t<tgt_sha1> = target SHA1 Sum after patching\n");
        printf("\t<size> = file size\n");
        printf("\t<init_sha1> = file SHA1 sum\n");
        printf("\t<patch> = patch file (.p) from OTA zip\n");
        printf("\t<bonus> = bonus resource file\n");
        return 0;
    }
    
    State* state;

    int ret = ApplyPatchFn("ApplyPatchFn", state, argc, argv);
    if (!ret) {
        std::cout << "Done" << std::endl;
    } else {
        std::cout << "Done with error code: " << ret << std::endl;
    }

    return 0;
}
