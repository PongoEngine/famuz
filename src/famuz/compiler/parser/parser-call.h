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
#include "./precedence.h"

/**
 * Parsing call "arp(...)"
 */
Expr *parse_call(Expr *left, TokenScanner *scanner, Exprs *exprs)
{
    Token token = token_scanner_next(scanner);
    Expr *expr = get_expr(exprs, E_CALL, &token);

    expr->def.call.identifier = left->def.constant.value.identifier;
    Expr *param = parse_expression(PRECEDENCE_CALL, scanner, exprs);
    int params_length = 0;
    while (token_scanner_has_next(scanner) && token_scanner_peek(scanner).type != RIGHT_PARAM)
    {
        token_scanner_next(scanner);
    }
    expr->def.call.params_length = params_length;

    assert_that(token_scanner_has_next(scanner) && token_scanner_next(scanner).type == RIGHT_PARAM, "EXPECTED RIGHT PARAM");

    expr->ret_type = -1;

    return expr;
}