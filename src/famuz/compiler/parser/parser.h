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

struct Expr *parse_expression(TokenScanner *scanner, Exprs *exprs);

#include "../expr/expr.h"
#include "../token.h"
#include "../scanner.h"
#include "./parser-rhythm.h"
#include "./parser-steps.h"
#include "./parser-binop.h"
#include "./parser-left-paren.h"
#include "./parser-assignment.h"
#include "./parser-identifier.h"
#include "./parser-scale.h"
#include "./parser-key.h"
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
    Token token = token_scanner_next(scanner);

    switch (token.type)
    {
    case IDENTIFIER:
    {
        Expr *expr = get_expr(exprs, E_CONST, &token);
        return parse_identifier_prefix(expr, exprs, &token);
    }
    case SCALE:
    {
        Expr *expr = get_expr(exprs, E_CONST, &token);
        return parse_scale_prefix(expr, &token);
    }
    case KEY:
    {
        Expr *expr = get_expr(exprs, E_CONST, &token);
        return parse_key_prefix(expr, &token);
    }

    case STEPS:
    {
        Expr *expr = get_expr(exprs, E_CONST, &token);
        return parse_steps_prefix(expr, &token);
    }
    case RHYTHM:
    {
        Expr *expr = get_expr(exprs, E_CONST, &token);
        return parse_rhythm_prefix(expr, &token);
    }
    case COMMENT:
        return NULL;
    case WHITESPACE:
        return NULL;
    case ADD:
        return NULL;
    case ASSIGNMENT:
        return NULL;
    case LEFT_PARAM:
        return NULL;
    case RIGHT_PARAM:
        return NULL;
    case COMMA:
        return NULL;
    case SLASH:
        return NULL;
    }
}

struct Expr *parse_expression_infix(Expr *left, TokenScanner *scanner, Exprs *exprs)
{
    Token token = token_scanner_peek(scanner);

    switch (token.type)
    {
    case ADD:
    {
        token_scanner_next(scanner);
        Expr *expr = get_expr(exprs, E_BINOP, &token);
        return parse_binop_infix(left, expr, scanner, exprs);
    }
    case ASSIGNMENT:
    {
        token_scanner_next(scanner);
        Expr *expr = get_expr(exprs, E_VAR, &token);
        return parse_assignment_infix(left, expr, scanner, exprs);
    }
    case LEFT_PARAM:
    {
        token_scanner_next(scanner);
        Expr *expr = get_expr(exprs, E_CALL, &token);
        return parse_left_paren_infix(left, expr, scanner, exprs);
    }
    case RIGHT_PARAM:
    case COMMA:
    case SLASH:
    case IDENTIFIER:
    case SCALE:
    case KEY:
    case WHITESPACE:
    case STEPS:
    case COMMENT:
    case RHYTHM:
        return NULL;
    }
}

struct Expr *parse_expression(TokenScanner *scanner, Exprs *expr)
{
    if (token_scanner_has_next(scanner))
    {
        Expr *left = parse_expression_prefix(scanner, expr);
        if (left == NULL)
        {
            printf("\n\nWE FOUND AN ERROR!\n\n");
        }

        bool has_next = token_scanner_has_next(scanner);
        Expr *infix = has_next ? parse_expression_infix(left, scanner, expr) : NULL;

        if (infix == NULL)
        {
            return left;
        }
        else
        {
            return infix;
        }
    }
    else
    {
        return NULL;
    }
}