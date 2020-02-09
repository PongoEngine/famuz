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

#include "./parser.h"
#include "../scanner.h"
#include "../../util/assert.h"
#include "./precedence.h"
#include "../environment.h"

/**
 * Parsing binary opertation "... + ..."
 */
Expr *parse_binop(Expr *left, TokenScanner *scanner, Environment *environment) {
    Token *token = token_scanner_next(scanner);
    Expr *expr = expr_binop(environment_next_expr((environment)), token);

    expr->def.binop.e1 = left;

    if (assert_that(token_scanner_has_next(scanner), "Cannot parse binary expression")) {
        Expr *right = parse_expression(PRECEDENCE_SUM, scanner, environment);
        expr->def.binop.e2 = right;
        expr->ret_type = right != NULL ? constant_type_add(left->ret_type, right->ret_type) : -1;
    } else {
        expr->def.binop.e2 = NULL;
        expr->ret_type = -1;
    }
    return expr;
}