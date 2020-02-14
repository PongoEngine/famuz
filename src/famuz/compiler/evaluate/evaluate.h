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

void evaluate(Environments *environments, int env_id, ExprLocation *loc, Stack *stack);

#include "evaluate_binop.h"
#include "evaluate_call.h"

void evaluate_parentheses(Environments *environments, int env_id, ExprLocation *loc, Stack *stack) {
    Expr *expr = environments_get_expr(environments, loc);
    evaluate(environments, env_id, expr->def.parentheses.expr_loc, stack);
}

void evaluate_var(Environments *environments, int env_id, ExprLocation *loc, Stack *stack) {
    Expr *expr = environments_get_expr(environments, loc);
    evaluate(environments, env_id, expr->def.var.expr_loc, stack);
}

void evaluate_block(Environments *environments, int env_id, ExprLocation *loc, Stack *stack) {
}

void evaluate_function(Environments *environments, int env_id, ExprLocation *loc, Stack *stack) {
    Expr *expr = environments_get_expr(environments, loc);
    stack_push(stack, expr);
}

void evaluate_const(Environments *environments, int env_id, ExprLocation *loc, Stack *stack) {
    Expr *expr = environments_get_expr(environments, loc);
    switch (expr->def.constant.type) {
        case TYPE_IDENTIFIER: {
            char *name = expr->def.constant.value.identifier;
            Expr *ref = environment_find(environments, env_id, name);
            evaluate(environments, env_id, &ref->loc, stack);
            break;
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
            stack_push(stack, expr);
            break;
    }
}

void evaluate(Environments *environments, int env_id, ExprLocation *loc, Stack *stack) {
    Expr *expr = environments_get_expr(environments, loc);
    switch (expr->def_type) {
        case E_CONST:
            evaluate_const(environments, env_id, loc, stack);
            break;
        case E_VAR:
            evaluate_var(environments, env_id, loc, stack);
            break;
        case E_CALL:
            evaluate_call(environments, env_id, loc, stack);
            break;
        case E_BINOP:
            evaluate_binop(environments, env_id, loc, stack);
            break;
        case E_PAREN:
            evaluate_parentheses(environments, env_id, loc, stack);
            break;
        case E_BLOCK:
            evaluate_block(environments, env_id, loc, stack);
            break;
        case E_FUNC:
            evaluate_function(environments, env_id, loc, stack);
            break;
    }
}
