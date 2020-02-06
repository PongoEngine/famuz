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

struct Expr *parse_expression(int precedence, TokenScanner *scanner, Exprs *exprs);
Expr *get_expr(Exprs *exprs, ExprDefType def_type, Token *token);

#include "../expr/expr.h"
#include "../token.h"
#include "../scanner.h"
#include "./parser-rhythm.h"
#include "./parser-steps.h"
#include "./parser-binop.h"
#include "./parser-left-paren.h"
#include "./parser-left-bracket.h"
#include "./parser-assignment.h"
#include "./parser-identifier.h"
#include "./parser-colon.h"
#include "./parser-scale.h"
#include "./parser-chord.h"
#include "./parser-key.h"
#include "./parser-func.h"
#include "./precedence.h"
#include "../../util/assert.h"

Expr *get_expr(Exprs *exprs, ExprDefType def_type, Token *token)
{
    Expr *expr = &(exprs->exprs[exprs->cur_index++]);
    expr->def_type = def_type;
    expr->pos = &(token->pos);
    return expr;
}

struct Expr *parse_expression_prefix(TokenScanner *scanner, Exprs *exprs)
{
    Token token = token_scanner_peek(scanner);

    switch (token.type)
    {
    case IDENTIFIER:
        return parse_identifier_prefix(scanner, exprs);
    case SCALE:
        return parse_scale_prefix(scanner, exprs);
    case CHORD:
        return parse_chord_prefix(scanner, exprs);
    case KEY:
        return parse_key_prefix(scanner, exprs);
    case STEPS:
        return parse_steps_prefix(scanner, exprs);
    case RHYTHM:
        return parse_rhythm_prefix(scanner, exprs);
    case LEFT_PARAM:
        return parse_left_paren_prefix(scanner, exprs);
    case LEFT_BRACKET:
        return parse_left_bracket_prefix(scanner, exprs);
    case FUNC:
        return parse_func_prefix(scanner, exprs);
    case RIGHT_PARAM:
    case RIGHT_BRACKET:
    case COMMA:
    case SLASH:
    case COMMENT:
    case WHITESPACE:
    case ADD:
    case ASSIGNMENT:
    case COLON:
    {
        token_scanner_next(scanner);
        return NULL;
    }
    }
}

struct Expr *parse_expression_infix(Expr *left, TokenScanner *scanner, Exprs *exprs)
{
    Token token = token_scanner_peek(scanner);

    switch (token.type)
    {
    case ADD:
        return parse_binop_infix(left, scanner, exprs);
    case ASSIGNMENT:
        return parse_assignment_infix(left, scanner, exprs);
    case LEFT_PARAM:
        return parse_left_paren_infix(left, scanner, exprs);
    case COLON:
        return parse_colon_infix(left, scanner, exprs);
    case RIGHT_PARAM:
    case LEFT_BRACKET:
    case RIGHT_BRACKET:
    case COMMA:
    case SLASH:
    case IDENTIFIER:
    case SCALE:
    case CHORD:
    case KEY:
    case WHITESPACE:
    case STEPS:
    case COMMENT:
    case RHYTHM:
    case FUNC:
        return NULL;
    }
}

struct Expr *parse_expression(int precedence, TokenScanner *scanner, Exprs *expr)
{
    if (token_scanner_has_next(scanner))
    {
        Expr *left = parse_expression_prefix(scanner, expr);
        if (!assert_that(left != NULL, "\nIN PARSE EXPRESSION LEFT IS NULL\n"))
        {
            if (token_scanner_has_next(scanner))
            {
                token_scanner_next(scanner);
            }
            return NULL;
        }

        bool has_next = token_scanner_has_next(scanner);
        if (has_next)
        {
            Expr *infix = parse_expression_infix(left, scanner, expr);
            return infix;
        }
        else
        {
            return left;
        }
    }
    else
    {
        return NULL;
    }
}