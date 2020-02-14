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
    int id;
    int parent;
    Expr *exprs;
} Environment;

typedef struct {
    int size;
    int capacity;
    Environment *environments;
} Environments;

void _environment_initialize(Environment *environment, int id, int parent) {
    environment->size = 0;
    environment->parent = parent;
    environment->id = id;
    environment->capacity = SETTINGS_ENVIRONMENT_INITIAL;
    environment->exprs = malloc(sizeof(Expr) * environment->capacity);
}

void _environment_resize(Environment *environment) {
    if (environment->size >= environment->capacity) {
        environment->capacity *= 2;
        environment->exprs = realloc(environment->exprs, environment->capacity * sizeof(Expr));
    }
}

Expr *environment_create_expr(Environments *environments, int env_id) {
    Environment *environment = &environments->environments[env_id];
    _environment_resize(environment);
    int expr_id = environment->size++;
    Expr expr;
    expr.loc.env_id = env_id;
    expr.loc.expr_id = expr_id;
    memcpy (&environment->exprs[expr_id], &expr, sizeof(Expr));
    return &environment->exprs[expr_id];
}

Expr *environment_find(Environments *environments, int env_id, char *name) {
    Environment *environment = &environments->environments[env_id];
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

void environments_initialize(Environments *environments) {
    environments->size = 0;
    environments->capacity = SETTINGS_ENVIRONMENT_INITIAL;
    environments->environments = malloc(sizeof(Environment) * environments->capacity);
}

void _environments_resize(Environments *environments) {
    if (environments->size >= environments->capacity) {
        environments->capacity *= 2;
        environments->environments = realloc(environments->environments, environments->capacity * sizeof(Environment));
    }
}

int environments_create_environment(Environments *environments, int parent) {
    _environments_resize(environments);
    Environment environment;
    int environment_id = environments->size;
    _environment_initialize(&environment, environment_id, parent);
    memcpy (&environments->environments[environments->size++], &environment, sizeof(Environment));
    return environments->size - 1;
}

Expr *environments_get_expr(Environments *environments, ExprLocation *loc) {
    return &environments->environments[loc->env_id].exprs[loc->expr_id];
}