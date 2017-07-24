# Erfan Abdi <erfangplus@gmail.com>
CC = gcc
PP = g++
AR = ar rcv
ifeq ($(windir),)
EXE =
RM = rm -f
RMDIR = rm -rf
else
EXE = .exe
RM = del
RMDIR = rmdir /Q /S
endif

CFLAGS = -ffunction-sections -O3 -std=c++11
LDFLAGS = -lssl -lcrypto -lz -lbz2 -lpthread
INC = -I. -Iinclude/ -I../include/ -I/usr/local/include/ -I../

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    LDFLAGS += -dead_strip
else
    LDFLAGS +=
endif

SUBDIRS = applypatch android-base edify minzip otafault blockimg

all:sub bindir BlockImageVerify.o BlockImageUpdate.o imgdiff.o ApplyPatch.o bin/BlockImageVerify$(EXE) bin/BlockImageUpdate$(EXE) bin/imgdiff$(EXE) bin/ApplyPatch$(EXE)

sub:
	for dir in $(SUBDIRS); do \
	cd $$dir && make && cd ../; \
	done

bindir:
	mkdir -p bin

BlockImageVerify.o:BlockImageVerify.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

bin/BlockImageVerify$(EXE):BlockImageVerify.o blockimg/blockimg.o edify/expr.o android-base/stringprintf.o android-base/strings.o minzip/Hash.o applypatch/bspatch.o applypatch/bsdiff.o applypatch/imgpatch.o applypatch/imgdiff.o applypatch/utils.o otafault/ota_io.o
	$(CROSS_COMPILE)$(PP) -o $@ $^ $(LDFLAGS) -s

BlockImageUpdate.o:BlockImageUpdate.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

bin/BlockImageUpdate$(EXE):BlockImageUpdate.o blockimg/blockimg.o edify/expr.o android-base/stringprintf.o android-base/strings.o minzip/Hash.o applypatch/bspatch.o applypatch/bsdiff.o applypatch/imgpatch.o applypatch/imgdiff.o applypatch/utils.o otafault/ota_io.o
	$(CROSS_COMPILE)$(PP) -o $@ $^ $(LDFLAGS) -s

imgdiff.o:imgdiff.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

bin/imgdiff$(EXE):imgdiff.o edify/expr.o android-base/stringprintf.o android-base/strings.o minzip/Hash.o applypatch/bspatch.o applypatch/bsdiff.o applypatch/imgpatch.o applypatch/imgdiff.o applypatch/utils.o otafault/ota_io.o
	$(CROSS_COMPILE)$(PP) -o $@ $^ $(LDFLAGS) -s

ApplyPatch.o:ApplyPatch.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

bin/ApplyPatch$(EXE):ApplyPatch.o applypatch/applypatch.o edify/expr.o android-base/stringprintf.o android-base/strings.o minzip/Hash.o applypatch/bspatch.o applypatch/bsdiff.o applypatch/imgpatch.o applypatch/imgdiff.o applypatch/utils.o otafault/ota_io.o
	$(CROSS_COMPILE)$(PP) -o $@ $^ $(LDFLAGS) -s

clean:
	find -name '*.o' -exec rm {} \;
	$(RMDIR) bin
