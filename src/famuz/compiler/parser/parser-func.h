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
#include "../reserved.h"
#include "../../util/assert.h"
#include "./parser-identifier.h"
#include "../environment.h"
#include "../stack.h"

/**
 * Parsing function "main(...)"
 */
Expr *parse_func(TokenScanner *scanner, Environment *environment, Stack *stack)
{
    Token *token = token_scanner_next(scanner);
    Expr *expr = expr_function(environment_next_expr((environment)), token);

    Expr *functionIdentifier = parse_identifier(scanner, environment);
    expr->def.function.identifier = functionIdentifier->def.constant.value.identifier;
    assert_that(token_scanner_next(scanner)->type == LEFT_PARAM, "\nparse_func :NOT LEFT PARENTHESES!\n");
    while (token_scanner_peek(scanner)->type != RIGHT_PARAM)
    {
        token_scanner_next(scanner);
    }
    assert_that(token_scanner_next(scanner)->type == RIGHT_PARAM, "\nparse_func :NOT LEFT PARENTHESES!\n");

    if(token_scanner_peek((scanner))->type == COLON) {
        token_scanner_next(scanner);
        parse_identifier(scanner, environment);
    }
    Expr *body = parse_expression(PRECEDENCE_CALL, scanner, environment, stack);

    position_union(expr->pos, body->pos, expr->pos);
    return expr;
}