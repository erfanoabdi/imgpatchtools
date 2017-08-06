#!/bin/sh
FILE=updater-script

if [ ! -z "$1" ]
then
    FILE=`echo $1`
else
    echo "usage: $0 <updater-script>"
    echo "\t<updater-script> = updater-script from OTA zip to patch recovery commands"
    exit
fi

#start making script
echo "#!/bin/sh"
echo "mkdir tmp"
cat "$FILE" | awk '{$1=$1};1' | tr '\n' ' ' | tr ';' '\n' | while read line
do

func=`echo "$line" | cut -d'(' -f 1`
if [ ! -z "$func" ]
then
    # Not Supported Commands
    if [[ ! $line =~ "apply_raw_image" ]] && [[ ! $line =~ "format" ]] && [[ ! $line =~ "show_progress" ]] && [[ ! $line =~ "apply_patch_check" ]] && [[ ! $line =~ "range_sha1" ]] && [[ ! $line =~ "block_image_recover" ]] && [[ ! $line =~ "print_superblock_info" ]] && [[ ! $line =~ "getprop" ]] && [[ ! $line =~ "apply_patch_space" ]]
    then
        #Supported commands
        if [[ $line =~ "mount" ]] || [[ $line =~ "ui_print" ]] || [[ $line =~ "block_image_update" ]] \
        || [[ $line =~ "apply_patch" ]] || [[ $line =~ "delete" ]] || [[ $line =~ "abort" ]] || [[ $line =~ "package_extract_dir" ]]
        then
            #remove EMMC: from apply_patch for image files
            if [[ $line =~ "apply_patch" ]] && [[ $line =~ "EMMC:" ]]
            then
                fullpath=`echo $line | cut -d '"' -f2`
                imgpath=`echo $fullpath | cut -d ':' -f2`
                line=${line/$fullpath/$imgpath}
            fi
            #remove assert and package_extract_file commands
            #remove /dev/block/bootdevice/by-name
            #and remove ( ) ,
            command=`echo "$line" | sed 's/assert/ /g' | sed 's/package_extract_file/ /g' | sed "s/\/dev\/block\/bootdevice\/by-name\/\([a-z]*\)/\1.img/" | tr '(' ' ' | tr ')' ' ' | tr ',' ' ' | awk '{$1=$1};1'`
            #replace edify commands
            bashC=`echo "$command" | sed 's/ui_print/echo/g' | sed 's/block_image_update/BlockImageUpdate/g' | sed 's/apply_patch/ApplyPatch/g' | sed 's/delete/rm -rf/g' | sed 's/abort/echo ERROR:/g' | sed 's/unmount/sudo umount/g' | sed 's/package_extract_dir/cp -RT/g' | sed "s/\"\//\"tmp\//g" | sed "s/ \// tmp\//g"`
            #fix mount command
            if [[ $bashC =~ "mount" ]] && [[ ! $bashC =~ "umount" ]]
            then
                bashC="sudo mount -t `echo $bashC | cut -d ' ' -f2` `echo $bashC | cut -d ' ' -f4` `echo $bashC | cut -d ' ' -f5`"
                echo mkdir `echo $bashC | cut -d ' ' -f5`
            fi
            echo $bashC
        fi
    fi
fi

done
