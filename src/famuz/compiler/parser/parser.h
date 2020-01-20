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
#include "expr.h"
#include "expr-printer.h"
#include "../token.h"

struct Expr *parse_expression(TokenScanner *scanner, Exprs *exprs);

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
        expr->expr.constant.type = C_IDENTIFIER;
        strcpy(expr->expr.constant.value.identifier, token.lexeme);
        return expr;
    }
    case SCALE:
    {
        Expr *expr = get_expr(exprs, E_CONST, &token);
        expr->expr.constant.type = C_SCALE;
        strcpy(expr->expr.constant.value.scale, token.lexeme);
        return expr;
    }
    case KEY:
    {
        Expr *expr = get_expr(exprs, E_CONST, &token);
        expr->expr.constant.type = C_KEY;
        strcpy(expr->expr.constant.value.key, token.lexeme);
        return expr;
    }

    case STEPS:
    {
        Expr *expr = get_expr(exprs, E_CONST, &token);
        expr->expr.constant.type = C_STEPS;
        strcpy(expr->expr.constant.value.steps, token.lexeme);
        return expr;
    }
    case RHYTHM:
    {
        Expr *expr = get_expr(exprs, E_CONST, &token);
        expr->expr.constant.type = C_RHYTHM;
        strcpy(expr->expr.constant.value.rhythm, token.lexeme);
        return expr;
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
    //

    switch (token.type)
    {
    case ADD:
    {
        token_scanner_next(scanner);
        Expr *expr = get_expr(exprs, E_BINOP, &token);
        expr->expr.binop.e1 = left;
        expr->expr.binop.e2 = parse_expression(scanner, exprs);
        return expr;
    }
    case ASSIGNMENT:
    {
        token_scanner_next(scanner);
        Expr *expr = get_expr(exprs, E_VAR, &token);
        strcpy(expr->expr.var.name, left->expr.constant.value.identifier);
        expr->expr.var.e = parse_expression(scanner, exprs);
        return expr;
    }
    case LEFT_PARAM:
    {
        token_scanner_next(scanner);
        Expr *expr = get_expr(exprs, E_CALL, &token);
        expr->expr.call.e = left;
        expr->expr.call.params = parse_expression(scanner, exprs);
        int params_length = 1;
        while (token_scanner_has_next(scanner) && token_scanner_peek(scanner).type != RIGHT_PARAM)
        {
            if (token_scanner_peek(scanner).type == COMMA)
            {
                token_scanner_next(scanner);
            }
            parse_expression(scanner, exprs);
            params_length++;
        }
        expr->expr.call.params_length = params_length;
        token_scanner_next(scanner);
        return expr;
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