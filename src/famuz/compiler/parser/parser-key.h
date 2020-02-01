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
 * Parsing key "c#"
 */
Expr *parse_key_prefix(TokenScanner *scanner, Exprs *exprs)
{
    Token token = token_scanner_next(scanner);
    Expr *expr = get_expr(exprs, E_CONST, &token);

    expr->def.constant.type = TYPE_KEY;

    if (strcmp(R_C, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_C;
    }
    else if (strcmp(R_C_SHARP, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_C_SHARP;
    }
    else if (strcmp(R_D_FLAT, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_D_FLAT;
    }
    else if (strcmp(R_D, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_D;
    }
    else if (strcmp(R_D_SHARP, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_D_SHARP;
    }
    else if (strcmp(R_E_FLAT, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_E_FLAT;
    }
    else if (strcmp(R_E, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_E;
    }
    else if (strcmp(R_F, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_F;
    }
    else if (strcmp(R_F_SHARP, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_F_SHARP;
    }
    else if (strcmp(R_G_FLAT, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_G_FLAT;
    }
    else if (strcmp(R_G, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_G;
    }
    else if (strcmp(R_G_SHARP, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_G_SHARP;
    }
    else if (strcmp(R_A_FLAT, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_A_FLAT;
    }
    else if (strcmp(R_A, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_A;
    }
    else if (strcmp(R_A_SHARP, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_A_SHARP;
    }
    else if (strcmp(R_B_FLAT, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_B_FLAT;
    }
    else if (strcmp(R_B, token.lexeme) == 0)
    {
        expr->def.constant.value.key = KEY_B;
    }

    expr->ret_type = TYPE_KEY;
    return expr;
}