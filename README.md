# IMG Patch Tools
Patch image (.img) using sparse Android data image (.dat) in OTA zip with "BlockImageUpdate"
Patch other files (boot.img, firmwares) using patch file (.p) with "ApplyPatchfn"


## Downloads
[Github Release](https://github.com/erfanoabdi/imgpatchtools/releases)


## Requirements
For Building this tool you need :

* zlib
* libbz2
* openssl

It currently supports Linux x86/x64 & MacOS, Not tested on Windows.


## Usage
```
usage: ./BlockImageUpdate <system.img> <system.transfer.list> <system.new.dat> <system.patch.dat>
```
args:
- `<system.img>` = block device (or file) to modify in-place
- `<system.transfer.list>` = transfer list (blob) from OTA/rom zip
- `<system.new.dat>` = new data stream from OTA/rom zip
- `<system.patch.dat>` = patch stream from OTA/rom zip

```
./ApplyPatchfn <file> <target> <tgt_sha1> <size> <init_sha1(1)> <patch(1)> <init_sha1(2)> <patch(2)>...
```
- `<file>` = source file from rom zip
- `<target>` = target file (use "-" to patch source file)
- `<tgt_sha1>` = target SHA1 Sum after patching
- `<size>` = file size
- `<init_sha1>` = file SHA1 sum
- `<patch>` = patch file (.p) from OTA zip


## Example
for example from updater-script of OTA we have:
```
block_image_update("/dev/block/bootdevice/by-name/system", package_extract_file("system.transfer.list"), "system.new.dat", "system.patch.dat")

apply_patch("EMMC:/dev/block/bootdevice/by-name/boot:33554432:f32a854298814c18b12d56412f6e3a31afc95e42:33554432:0041a4df844d4b14c0085921d84572f48cc79ff4",
            "-", 0041a4df844d4b14c0085921d84572f48cc79ff4, 33554432,
            f32a854298814c18b12d56412f6e3a31afc95e42,
            package_extract_file("patch/boot.img.p"))
```
after getting system.img and boot.img from firmware
This is equals of previous functions on PC with this tools:
```
~$ ./BlockImageUpdate system.img system.transfer.list system.new.dat system.patch.dat
~$ ./ApplyPatchfn boot.img - 0041a4df844d4b14c0085921d84572f48cc79ff4 33554432 f32a854298814c18b12d56412f6e3a31afc95e42
```


### Youtube
Coming soon


## Info
For more information about this tools, visit https://forum.xda-developers.com/android/software-hacking/dev-img-patch-tools-sdat2img-ota-zips-t3640308.
