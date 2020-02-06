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
#include "../../util/expr-printer.h"
#include "./precedence.h"

/**
 * Parsing call "arp(...)"
 */
Expr *parse_left_paren_infix(Expr *left, TokenScanner *scanner, Exprs *exprs)
{
    Token token = token_scanner_next(scanner);
    Expr *expr = get_expr(exprs, E_CALL, &token);

    expr->def.call.identifier = left->def.constant.value.identifier;
    if (assert_that(token_scanner_has_next(scanner), "Cannot parse call expression"))
    {
        Expr *param = parse_expression(PRECEDENCE_CALL, scanner, exprs);
        expr->def.call.params = param;
        int params_length = 1;
        while (token_scanner_has_next(scanner) && token_scanner_peek(scanner).type != RIGHT_PARAM)
        {
            if (token_scanner_peek(scanner).type == COMMA)
            {
                token_scanner_next(scanner);
                param = parse_expression(0, scanner, exprs);
            }
            else if (token_scanner_peek(scanner).type == COLON)
            {
                param = parse_expression(0, scanner, exprs);
                expr_print(param, 0);
            }
            else
            {
                assert_that(false, "INVALID PARAMS PARSING IN CALL");
            }
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

    expr->ret_type = -1;

    return expr;
}

/**
 * Parsing parens "(...)"
 */
Expr *parse_left_paren_prefix(TokenScanner *scanner, Exprs *exprs)
{
    Token token = token_scanner_next(scanner);
    Expr *expr = get_expr(exprs, E_PAREN, &token);

    expr->def.parentheses.e = parse_expression(0, scanner, exprs);
    assert_that(token_scanner_has_next(scanner) && token_scanner_next(scanner).type == RIGHT_PARAM, "EXPECTED RIGHT PARAM");
    expr->ret_type = expr->def.parentheses.e->ret_type;
    return expr;
}