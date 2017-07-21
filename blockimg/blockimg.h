#ifndef _BLOCKIMG_H
#define _BLOCKIMG_H

#include "edify/expr.h"

int BlockImageVerifyFn(const char* name, State* state, int argc, char * argv[]);
int BlockImageUpdateFn(const char* name, State* state, int argc, char* argv[]);

#endif  // _BLOCKIMG_H
