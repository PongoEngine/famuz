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
#include "./expr-block.h"
#include "./expr-function.h"
#include "./expr-parentheses.h"

typedef enum
{
    E_CONST = 1,
    E_VAR,
    E_CHECK_TYPE,
    E_CALL,
    E_BINOP,
    E_BLOCK,
    E_FUNC,
    E_PAREN,
} ExprDefType;

#include "./expr-check-type.h"

typedef struct Expr
{
    union ExprDef {
        //A constant.
        EConstant constant;
        //Variable declaration.
        EVar var;
        //A (e:t) expression.
        ECheckType type;
        //A call e(params).
        ECall call;
        //A block of expressions {exprs}.
        EBlock block;
        //Binary operator e1 op e2.
        EBinop binop;
        //Parentheses (e).
        EParentheses parentheses;
        //A function declaration.
        EFunction function;

    } def;
    Position *pos;
    ExprDefType def_type;
    Type ret_type;
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
        if (expr->def_type == E_VAR && strcmp(expr->def.var.identifier, name) == 0)
        {
            return expr;
        }
        else if (expr->def_type == E_CALL && strcmp(expr->def.call.identifier, name) == 0)
        {
            return expr;
        }
    }
    return NULL;
}

Type expr_type_from_name(Exprs *exprs, char *name)
{
    Expr *expr = expr_from_name(exprs, name);
    return expr == NULL ? -1 : expr->ret_type;
}