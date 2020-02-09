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
#include "../util/assert.h"

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

void expr_init_constant(Expr *expr, Type constant_type, Type return_type, Position *position) {
    expr->def_type = E_CONST;
    expr->def.constant.type = constant_type;
    expr->ret_type = return_type;
    expr->pos = position;
}

Expr *expr_binop(Expr *expr, Token *token) {
    expr->def_type = E_BINOP;
    expr->pos = &(token->pos);
    return expr;
}

Expr *expr_block(Expr *expr, Token *token) {
    expr->def_type = E_BLOCK;
    expr->pos = &(token->pos);
    return expr;
}

Expr *expr_call(Expr *expr, Token *token) {
    expr->def_type = E_CALL;
    expr->pos = &(token->pos);
    return expr;
}

Expr *expr_function(Expr *expr, Token *token) {
    expr->def_type = E_FUNC;
    expr->pos = &(token->pos);
    return expr;
}

Expr *expr_parentheses(Expr *expr, Token *token) {
    expr->def_type = E_PAREN;
    expr->pos = &(token->pos);
    return expr;
}

Expr *expr_var(Expr *expr, Position *position, Expr *e, char *identifier) {
    expr->def_type = E_VAR;
    if(expr->ret_type == TYPE_MONOMORPH || expr->ret_type == e->ret_type) {
        expr->ret_type = e->ret_type;
    }
    else {
        assert_that(false, "Invalid Type\n");
    }
    expr->pos = position;
    expr->def.var.e = e;
    strcpy(expr->def.var.identifier, identifier);
    return expr;
}

Expr *expr_constant_key(Expr *expr, Token *token) {
    expr->def_type = E_CONST;
    expr->pos = &(token->pos);
    return expr;
}

Expr *expr_constant_scale(Expr *expr, Token *token) {
    expr->def_type = E_CONST;
    expr->pos = &(token->pos);
    return expr;
}

Expr *expr_constant_number(Expr *expr, Token *token) {
    expr->def_type = E_CONST;
    expr->pos = &(token->pos);
    return expr;
}

Expr *expr_constant_identifier(Expr *expr, Position *position, char *identifier) {
    expr_init_constant(expr, TYPE_IDENTIFIER, TYPE_MONOMORPH, position);
    strcpy(expr->def.constant.value.identifier, identifier);
    return expr;
}

Expr *expr_constant_steps(Expr *expr, Token *token) {
    expr->def_type = E_CONST;
    expr->pos = &(token->pos);
    return expr;
}

Expr *expr_constant_rhythm(Expr *expr, Position *position) {
    expr_init_constant(expr, TYPE_RHYTHM, TYPE_RHYTHM, position);
    //rhythm value gets assigned in parser
    return expr;
}