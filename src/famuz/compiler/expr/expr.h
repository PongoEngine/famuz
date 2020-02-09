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
#include "../type/type.h"

typedef struct Expr Expr;

#include "./expr-constant.h"
#include "./expr-binop.h"
#include "./expr-var.h"
#include "./expr-call.h"
#include "./expr-block.h"
#include "./expr-function.h"
#include "./expr-parentheses.h"

typedef enum {
    E_CONST = 1,
    E_VAR,
    E_CALL,
    E_BINOP,
    E_BLOCK,
    E_FUNC,
    E_PAREN,
} ExprDefType;

typedef struct Expr {
    union ExprDef {
        //A constant.
        EConstant constant;
        //Variable declaration.
        EVar var;
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

Expr *create_binop(Expr *expr, ExprDefType def_type, Token *token) {
    expr->def_type = def_type;
    expr->pos = &(token->pos);
    return expr;
}

Expr *create_block(Expr *expr, ExprDefType def_type, Token *token) {
    expr->def_type = def_type;
    expr->pos = &(token->pos);
    return expr;
}

Expr *create_call(Expr *expr, ExprDefType def_type, Token *token) {
    expr->def_type = def_type;
    expr->pos = &(token->pos);
    return expr;
}

Expr *create_constant(Expr *expr, ExprDefType def_type, Token *token) {
    expr->def_type = def_type;
    expr->pos = &(token->pos);
    return expr;
}

Expr *create_function(Expr *expr, ExprDefType def_type, Token *token) {
    expr->def_type = def_type;
    expr->pos = &(token->pos);
    return expr;
}

Expr *create_parentheses(Expr *expr, ExprDefType def_type, Token *token) {
    expr->def_type = def_type;
    expr->pos = &(token->pos);
    return expr;
}