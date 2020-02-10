#pragma once

/*
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

#include "../expr/expr.h"
#include "../type/type.h"
#include "../environment.h"
#include "../stack.h"

static Expr generate_temp_expr;

Expr *evaluate(Expr *expr, Environment *environment, Stack *stack);

#include "evaluate_binop.h"
#include "evaluate_call.h"

Expr *evaluate_parentheses(Expr *expr, Environment *environment, Stack *stack)
{
    return evaluate(expr->def.parentheses.e, environment, stack);
}

Expr *evaluate_var(Expr *expr, Environment *environment, Stack *stack)
{
    return evaluate(expr->def.var.e, environment, stack);
}

Expr *evaluate_block(Expr *expr)
{
    return expr;
}

Expr *evaluate_function(Expr *expr)
{
    return expr;
}

Expr *evaluate_const(Expr *expr, Environment *environment, Stack *stack)
{
    switch (expr->def.constant.type)
    {
    case TYPE_IDENTIFIER:
    {
        char *name = expr->def.constant.value.identifier;
        Expr *ref = environment_expr_from_name(environment, name);
        return evaluate(ref, environment, stack);
    }
    case TYPE_NUMBER:
    case TYPE_RHYTHM:
    case TYPE_MELODY:
    case TYPE_HARMONY:
    case TYPE_STEPS:
    case TYPE_SCALE:
    case TYPE_KEY:
    case TYPE_SCALED_KEY:
    case TYPE_MUSIC:
    case TYPE_MONOMORPH:
        return expr;
    }
}

Expr *evaluate(Expr *expr, Environment *environment, Stack *stack)
{
    switch (expr->def_type)
    {
    case E_CONST:
        return evaluate_const(expr, environment, stack);
    case E_VAR:
        return evaluate_var(expr, environment, stack);
    case E_CALL:
        return evaluate_call(expr);
    case E_BINOP:
        return evaluate_binop(expr, environment, stack);
    case E_PAREN:
        return evaluate_parentheses(expr, environment, stack);
    case E_BLOCK:
        return evaluate_block(expr);
    case E_FUNC:
        return evaluate_function(expr);
    }
}
