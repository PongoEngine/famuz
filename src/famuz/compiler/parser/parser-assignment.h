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

/**
 * Parsing assigning "... = ..."
 */
Expr *parse_assignment_infix(Expr *left, TokenScanner *scanner, Exprs *exprs)
{
    Token token = token_scanner_next(scanner);
    Expr *expr = get_expr(exprs, E_VAR, &token);

    if (assert_that(left->def_type == E_CONST && left->def.constant.type == TYPE_IDENTIFIER, "NOT IDENTIFIER"))
    {
        expr->def.var.identifier = left->def.constant.value.identifier;
        expr->ret_type = left->ret_type;
    }

    if (assert_that(token_scanner_has_next(scanner), "Cannot parse assignment expression"))
    {
        Expr *e = parse_expression(PRECEDENCE_ASSIGNMENT, scanner, exprs);
        if ((int)left->ret_type != -1 && left->ret_type != e->ret_type)
        {
            printf("WHAT THE FUCK!");
        }
        expr->def.var.e = e;
        // expr->ret_type = expr->def.var.e != NULL ? expr->def.var.e->ret_type : -1;
    }
    else
    {
        expr->def.var.e = NULL;
        expr->ret_type = -1;
    }
    return expr;
}