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
#include "compiler/evaluate/evaluate.h"
#include "./parser.h"
#include "../scanner.h"
#include "../../util/assert.h"
#include "../../util/printer.h"
#include "./precedence.h"
#include "../environment.h"

/**
 * Parsing print "print(...)"
 */
Expr *parse_print(TokenScanner *scanner, Environments *environments, int env_id, Stack *stack) {
    token_scanner_next(scanner); //consume "print"
    token_scanner_next(scanner); //consume "("
    Expr *expr = parse_expression(0, scanner, environments, env_id, stack);
    evaluate(expr, environments, env_id, stack);
    print(stack_pop(stack), expr->pos);
    assert_that(stack->cur_index == 0, "Stack is not empty!");
    token_scanner_next(scanner); //consume ")"
    return expr;
}