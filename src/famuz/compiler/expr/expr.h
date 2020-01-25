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
#include "../position.h"
#include "../settings.h"
#include "../type.h"

typedef struct Expr Expr;

#include "./expr-constant.h"
#include "./expr-binop.h"
#include "./expr-var.h"
#include "./expr-call.h"

typedef enum
{
    E_CONST = 1,
    E_VAR,
    E_CALL,
    E_BINOP,
} ExprDefType;

typedef struct Expr
{
    union ExprDef {
        //A constant.
        Constant constant;
        //Variable declaration.
        Var var;
        //A call e(params).
        Call call;
        //Binary operator e1 op e2.
        Binop binop;

    } expr;
    Position *pos;
    ExprDefType def_type;
    ConstantType ret_type;

} Expr;

typedef struct
{
    Expr exprs[SETTINGS_EXPRS_LENGTH];
    int cur_index;
} Exprs;

//turn into a map?
Expr *expr_from_name(Exprs *exprs, char *name)
{
    for (size_t i = 0; i < exprs->cur_index; i++)
    {
        Expr *expr = &(exprs->exprs[i]);
        if (expr->def_type == E_VAR && strcmp(expr->expr.var.identifier->expr.constant.value.identifier, name) == 0)
        {
            printf("VAR: %s", name);
            return expr;
        }
        else if (expr->def_type == E_CALL && strcmp(expr->expr.call.e->expr.constant.value.identifier, name) == 0)
        {
            printf("CALL: %s", name);
            return expr;
        }
    }
    return NULL;
}