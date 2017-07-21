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

CFLAGS = -ffunction-sections -O3 -std=c++11 -lssl -lcrypto -lz -lbz2
LDFLAGS = -lssl -lcrypto -lz -lbz2
INC = -I. -Iinclude/ -I../include/ -I/usr/local/include/ -I../

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    LDFLAGS += -dead_strip
else
    LDFLAGS += 
endif

all:bspatch.o bsdiff.o imgpatch.o imgdiff.o utils.o 
#imgdiff$(EXE)

bspatch.o:bspatch.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

bsdiff.o:bsdiff.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

imgpatch.o:imgpatch.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

imgdiff.o:imgdiff.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

utils.o:utils.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

freecache.o:freecache.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

#imgdiff$(EXE):imgdiff.o ../edify/expr.o ../android-base/stringprintf.o ../android-base/strings.o ../minzip/Hash.o bspatch.o bsdiff.o imgpatch.o imgdiff.o utils.o
	$(CROSS_COMPILE)$(PP) -o $@ $^ $(LDFLAGS) -s

clean:
	$(RM) bspatch.o bsdiff.o imgpatch.o imgdiff.o utils.o 
