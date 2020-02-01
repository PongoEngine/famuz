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

#include <string.h>
#include "./parser.h"
#include "../scanner.h"
#include "../../util/assert.h"

/**
 * Parsing call "arp(...)"
 */
Expr *parse_left_paren_infix(Expr *left, Expr *expr, TokenScanner *scanner, Exprs *exprs)
{
    expr->def.call.identifier = left->def.constant.value.identifier;
    if (assert_that(token_scanner_has_next(scanner), "Cannot parse call expression"))
    {
        expr->def.call.params = parse_expression(scanner, exprs);
        int params_length = 1;
        while (token_scanner_has_next(scanner) && token_scanner_peek(scanner).type != RIGHT_PARAM)
        {
            if (assert_that(token_scanner_peek(scanner).type == COMMA, "EXPECTED COMMA"))
            {
                token_scanner_next(scanner);
            }
            parse_expression(scanner, exprs);
            params_length++;
        }
        expr->def.call.params_length = params_length;

        assert_that(token_scanner_has_next(scanner) && token_scanner_next(scanner).type == RIGHT_PARAM, "EXPECTED RIGHT PARAM");
    }
    else
    {
        expr->def.call.params = NULL;
        expr->def.call.params_length = 0;
    }

    if (strcmp(left->def.constant.value.identifier, "arp") == 0)
    {
        expr->ret_type = C_MELODY;
    }
    else if (strcmp(left->def.constant.value.identifier, "chord") == 0)
    {
        expr->ret_type = C_HARMONY;
    }
    else if (strcmp(left->def.constant.value.identifier, "main") == 0)
    {
        expr->ret_type = C_MUSIC;
    }
    else
    {
        expr->ret_type = -1;
    }

    return expr;
}

/**
 * Parsing parens "(...)"
 */
Expr *parse_left_paren_prefix(Expr *expr, TokenScanner *scanner, Exprs *exprs)
{
    expr->def.parentheses.e = parse_expression(scanner, exprs);
    assert_that(token_scanner_has_next(scanner) && token_scanner_next(scanner).type == RIGHT_PARAM, "EXPECTED RIGHT PARAM");
    expr->ret_type = expr->def.parentheses.e->ret_type;
    return expr;
}