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

#include <string.h>
#include "./settings.h"
#include "./expr/expr.h"

typedef struct
{
    Expr exprs[SETTINGS_EXPRS_LENGTH];
    int cur_index;
} Environment;

Expr *expr_from_name(Environment *exprs, char *name)
{
    for (size_t i = 0; i < exprs->cur_index; i++)
    {
        Expr *expr = &(exprs->exprs[i]);
        if (expr->def_type == E_VAR && strcmp(expr->def.var.identifier, name) == 0)
        {
            return expr;
        }
    }
    return NULL;
}

Type expr_type_from_name(Environment *exprs, char *name)
{
    Expr *expr = expr_from_name(exprs, name);
    return expr == NULL ? (Type)-1 : expr->ret_type;
}