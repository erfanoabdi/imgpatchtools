//
//  BlockImageVerify.cpp
//  imgpatchtools
//
//  Created by Erfan Abdi on 7/19/17.
//  Copyright © 2017 Erfan Abdi. All rights reserved.
//

#include <iostream>
#include "blockimg/blockimg.h"
#include "edify/expr.h"

int main(int argc, char * argv[]) {
    if (argc < 5){
        printf("usage: %s <system.img> <system.transfer.list> <system.new.dat> <system.patch.dat>\nargs:\n\t- block device (or file) to modify in-place\n\t- transfer list (blob)\n\t- new data stream (filename within package.zip)\n\t- patch stream (filename within package.zip, must be uncompressed)\n",argv[0]);
        return 0;
    }

    State* state;
    int ret = BlockImageVerifyFn("BlockImageVerifyFn", state, argc, argv);
    if (!ret) {
        std::cout << "Done" << std::endl;
    } else {
        std::cout << "Done with error code: " << ret << std::endl;
    }

    return 0;
}
