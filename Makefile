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

all:sub BlockImageVerify.o BlockImageUpdate.o BlockImageVerify$(EXE) BlockImageUpdate$(EXE) imgdiff.o imgdiff$(EXE)

sub:
	for dir in $(SUBDIRS); do \
	cd $$dir && make && cd ../; \
	done


BlockImageVerify.o:BlockImageVerify.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

BlockImageVerify$(EXE):BlockImageVerify.o blockimg/blockimg.o edify/expr.o android-base/stringprintf.o android-base/strings.o minzip/Hash.o applypatch/bspatch.o applypatch/bsdiff.o applypatch/imgpatch.o applypatch/imgdiff.o applypatch/utils.o otafault/ota_io.o
	$(CROSS_COMPILE)$(PP) -o $@ $^ $(LDFLAGS) -s

BlockImageUpdate.o:BlockImageUpdate.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

BlockImageUpdate$(EXE):BlockImageUpdate.o blockimg/blockimg.o edify/expr.o android-base/stringprintf.o android-base/strings.o minzip/Hash.o applypatch/bspatch.o applypatch/bsdiff.o applypatch/imgpatch.o applypatch/imgdiff.o applypatch/utils.o otafault/ota_io.o
	$(CROSS_COMPILE)$(PP) -o $@ $^ $(LDFLAGS) -s

imgdiff.o:imgdiff.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

imgdiff$(EXE):imgdiff.o edify/expr.o android-base/stringprintf.o android-base/strings.o minzip/Hash.o applypatch/bspatch.o applypatch/bsdiff.o applypatch/imgpatch.o applypatch/imgdiff.o applypatch/utils.o otafault/ota_io.o
	$(CROSS_COMPILE)$(PP) -o $@ $^ $(LDFLAGS) -s

clean:
	find -name '*.o' -exec rm {} \;
	$(RM) BlockImageVerify BlockImageUpdate imgdiff
