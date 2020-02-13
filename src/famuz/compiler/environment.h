#pragma once

/*
 * MIT License
 *
 * Copyright (c) 2019 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include <stdlib.h>
#include <string.h>
#include "./settings.h"
#include "./expr/expr.h"

typedef struct {
    int size;
    int capacity;
    Expr *exprs;
} Environment;

void initialize(Environment *environment) {
    environment->size = 0;
    environment->capacity = SETTINGS_ENVIRONMENT_INITIAL;
    environment->exprs = malloc(sizeof(Expr) * environment->capacity);
}

void resize(Environment *environment) {
    if (environment->size >= environment->capacity) {
        environment->capacity *= 2;
        environment->exprs = realloc(environment->exprs, environment->capacity * sizeof(Expr));
    }
}

Expr *environment_create(Environment *environment) {
    resize(environment);
    Expr expr;
    memcpy (&environment->exprs[environment->size++], &expr, sizeof(Expr));
    return &environment->exprs[environment->size - 1];
}

Expr *environment_find(Environment *environment, char *name) {
    for (int i = 0; i < environment->size; i++) {
        if (strcmp(environment->exprs[i].def.var.identifier, name) == 0) {
            return &environment->exprs[i];
        }
        if (strcmp(environment->exprs[i].def.function.identifier, name) == 0) {
            return &environment->exprs[i];
        }
    }
    return NULL;
}