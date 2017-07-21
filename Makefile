# Erfan Abdi <erfangplus@gmail.com>
CC = gcc
PP = g++
AR = ar rcv
ifeq ($(windir),)
EXE =
RM = rm -f
else
EXE = .exe
RM = del
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

all:sub BlockImageVerifyFn.o BlockImageUpdateFn.o BlockImageVerifyFn$(EXE) BlockImageUpdateFn$(EXE) imgdiff.o imgdiff$(EXE)

sub:
	for dir in $(SUBDIRS); do \
	cd $$dir && make && cd ../; \
	done


BlockImageVerifyFn.o:BlockImageVerifyFn.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

BlockImageVerifyFn$(EXE):BlockImageVerifyFn.o blockimg/blockimg.o edify/expr.o android-base/stringprintf.o android-base/strings.o minzip/Hash.o applypatch/bspatch.o applypatch/bsdiff.o applypatch/imgpatch.o applypatch/imgdiff.o applypatch/utils.o otafault/ota_io.o
	$(CROSS_COMPILE)$(PP) -o $@ $^ $(LDFLAGS) -s

BlockImageUpdateFn.o:BlockImageUpdateFn.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

BlockImageUpdateFn$(EXE):BlockImageUpdateFn.o blockimg/blockimg.o edify/expr.o android-base/stringprintf.o android-base/strings.o minzip/Hash.o applypatch/bspatch.o applypatch/bsdiff.o applypatch/imgpatch.o applypatch/imgdiff.o applypatch/utils.o otafault/ota_io.o
	$(CROSS_COMPILE)$(PP) -o $@ $^ $(LDFLAGS) -s

imgdiff.o:imgdiff.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

imgdiff$(EXE):imgdiff.o edify/expr.o android-base/stringprintf.o android-base/strings.o minzip/Hash.o applypatch/bspatch.o applypatch/bsdiff.o applypatch/imgpatch.o applypatch/imgdiff.o applypatch/utils.o otafault/ota_io.o
	$(CROSS_COMPILE)$(PP) -o $@ $^ $(LDFLAGS) -s

clean:
	find -name '*.o' -exec rm {} \;
	$(RM) BlockImageVerifyFn BlockImageUpdateFn imgdiff
