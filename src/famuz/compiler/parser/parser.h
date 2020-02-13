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

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "../environment.h"
#include "../stack.h"

struct Expr *
parse_expression(int precedence, TokenScanner *scanner, int env_id, Environments *environments,
                 Stack *stack);

#include "../expr/expr.h"
#include "../token.h"
#include "../scanner.h"
#include "./parser-rhythm.h"
#include "./parser-number.h"
#include "./parser-steps.h"
#include "./parser-binop.h"
#include "./parser-block.h"
#include "./parser-func.h"
#include "./parser-call.h"
#include "./parser-parentheses.h"
#include "./parser-print.h"
#include "parser-var.h"
#include "./parser-identifier.h"
#include "./parser-typing.h"
#include "./parser-scale.h"
#include "./parser-key.h"
#include "./precedence.h"
#include "../../util/assert.h"
#include "../environment.h"

struct Expr *
parse_expression_prefix(TokenScanner *scanner, int env_id, Environments *environments, Stack *stack) {
    Token *token = token_scanner_peek(scanner);

    switch (token->type) {
        case IDENTIFIER:
            return parse_identifier(scanner, environments, env_id);
        case NUMBER:
            return parse_number(scanner, environments, env_id);
        case SCALE:
            return parse_scale(scanner, environments, env_id);
        case KEY:
            return parse_key(scanner, environments, env_id);
    case STEPS:
        return parse_steps(scanner, environments, env_id);
    case RHYTHM:
        return parse_rhythm(scanner, environments, env_id);
    case LEFT_PARAM:
        return parse_parentheses(scanner, env_id, environments, stack);
    case LEFT_BRACKET:
        return parse_block(scanner, env_id, environments, stack);
    case FUNC:
        return parse_func(scanner, env_id, environments, stack);
    case PRINT:
        return parse_print(scanner, env_id, environments, stack);
    case RIGHT_PARAM:
    case RIGHT_BRACKET:
    case COMMA:
    case SLASH:
    case COMMENT:
    case WHITESPACE:
    case ADD:
    case ASSIGNMENT:
    case COLON:
    case SHIFT_LEFT:
    case SHIFT_RIGHT:
    {
        token_scanner_next(scanner);
        return NULL;
    }
    }
}

struct Expr *
parse_expression_infix(Expr *left, TokenScanner *scanner, int env_id, Environments *environments,
                       Stack *stack) {
    Token *token = token_scanner_peek(scanner);

    switch (token->type) {
        case ADD:
            return parse_binop(left, scanner, env_id, environments, stack);
        case ASSIGNMENT:
            return parse_var(left, scanner, env_id, environments, stack);
        case LEFT_PARAM:
            return parse_call(left, scanner, env_id, environments, stack);
    case COLON:
        return parse_typing(left, scanner, env_id);
    case SHIFT_LEFT:
        return parse_binop(left, scanner, env_id, environments, stack);
    case SHIFT_RIGHT:
        return parse_binop(left, scanner, env_id, environments, stack);
    case RIGHT_PARAM:
    case LEFT_BRACKET:
    case RIGHT_BRACKET:
    case COMMA:
    case SLASH:
    case IDENTIFIER:
    case SCALE:
    case KEY:
    case WHITESPACE:
    case STEPS:
    case COMMENT:
    case RHYTHM:
    case FUNC:
    case PRINT:
    case NUMBER:
        return NULL;
    }
}

struct Expr *
parse_expression(int precedence, TokenScanner *scanner, int env_id, Environments *environments,
                 Stack *stack) {
    if (token_scanner_has_next(scanner)) {
        Expr *left = parse_expression_prefix(scanner, env_id, environments, stack);
        if (!assert_that(left != NULL, "\nIN PARSE EXPRESSION LEFT IS NULL\n")) {
            if (token_scanner_has_next(scanner)) {
                token_scanner_next(scanner);
            }
            return NULL;
        }

        bool has_next = token_scanner_has_next(scanner);
        while (has_next && precedence < get_precedence(scanner))
        {
            left = parse_expression_infix(left, scanner, env_id, environments, stack);
            has_next = token_scanner_has_next(scanner);
        }
        return left;
    }
    else
    {
        return NULL;
    }
}