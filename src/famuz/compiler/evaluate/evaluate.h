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

void evaluate(Expr *expr, Environments *environments, int env_id, int expr_id, Stack *stack);

#include "evaluate_binop.h"
#include "evaluate_call.h"

void evaluate_parentheses(Expr *expr, Environments *environments, int env_id, int expr_id, Stack *stack) {
    evaluate(expr->def.parentheses.e, environments, env_id, expr_id, stack);
}

void evaluate_var(Expr *expr, Environments *environments, int env_id, int expr_id, Stack *stack) {
    evaluate(expr->def.var.e, environments, env_id, expr_id, stack);
}

void evaluate_block(Expr *expr, Environments *environments, int env_id, int expr_id, Stack *stack) {
}

void evaluate_function(Expr *expr, Environments *environments, int env_id, int expr_id, Stack *stack) {
    stack_push(stack, expr);
}

void evaluate_const(Expr *expr, Environments *environments, int env_id, int expr_id, Stack *stack) {
    switch (expr->def.constant.type) {
        case TYPE_IDENTIFIER: {
            char *name = expr->def.constant.value.identifier;
            Expr *ref = environment_find(environments, env_id, name);
            evaluate(ref, environments, env_id, expr_id, stack);
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

void evaluate(Expr *expr, Environments *environments, int env_id, int expr_id, Stack *stack) {
    switch (expr->def_type) {
        case E_CONST:
            evaluate_const(expr, environments, env_id, expr_id, stack);
            break;
        case E_VAR:
            evaluate_var(expr, environments, env_id, expr_id, stack);
            break;
        case E_CALL:
            evaluate_call(expr, environments, env_id, stack);
            break;
        case E_BINOP:
            evaluate_binop(expr, environments, env_id, expr_id, stack);
            break;
        case E_PAREN:
            evaluate_parentheses(expr, environments, env_id, expr_id, stack);
            break;
        case E_BLOCK:
            evaluate_block(expr, environments, env_id, expr_id, stack);
            break;
        case E_FUNC:
            evaluate_function(expr, environments, env_id, expr_id, stack);
            break;
    }
}
