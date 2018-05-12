# Erfan Abdi <erfangplus@gmail.com>
CC = gcc
AR = ar rcv
ifeq ($(windir),)
EXE =
RM = rm -f
else
EXE = .exe
RM = del
endif

CFLAGS = -ffunction-sections -Wall -Wextra
LDFLAGS = -Wl

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    LDFLAGS += -dead_strip
else
    LDFLAGS += --gc-sections
endif

all:Hash.o

Hash.o:Hash.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -I. -Werror

clean:
	$(RM) Hash.o
