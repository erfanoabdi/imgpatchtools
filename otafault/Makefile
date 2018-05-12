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

CFLAGS = -ffunction-sections -Wall -Wextra -std=c++11
LDFLAGS = -Wl
INC = -I. -I../include/ -Iinclude/

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    LDFLAGS += -dead_strip
else
    LDFLAGS += --gc-sections
endif

all:ota_io.o

ota_io.o:ota_io.cpp
	$(CROSS_COMPILE)$(PP) -o $@ $(CFLAGS) -c $< $(INC)

clean:
	$(RM) ota_io.o
