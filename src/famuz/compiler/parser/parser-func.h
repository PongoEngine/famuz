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
#include "../lexer/reserved.h"
#include "../../util/assert.h"
#include "./parser-identifier.h"

int parse_params(TokenScanner *scanner, Parameter *params)
{
    return 0;
}

/**
 * Parsing function "main(...)"
 */
Expr *parse_func_prefix(Expr *expr, TokenScanner *scanner, Exprs *exprs)
{
    // Expr *call = parse_expression(scanner, exprs);
    // Expr *body = parse_expression(scanner, exprs);
    // expr_print(call, 0);
    // expr_print(body, 0);
    // printf("%s", possibleIdentifier->def.constant.value.identifier);
    // expr->def.function.identifier = parse_expression(scanner, exprs);
    return expr;
}