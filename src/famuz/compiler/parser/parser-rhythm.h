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
#include "../../util/assert.h"
#include "../environment.h"

void parse_rhythm_eat_duration(Scanner *scanner)
{
    while (scanner_has_next(scanner) && scanner_peek(scanner) == '~')
    {
        scanner_next(scanner);
    }
}

void parse_rhythm_eat_rest(Scanner *scanner)
{
    while (scanner_has_next(scanner) && scanner_peek(scanner) == '-')
    {
        scanner_next(scanner);
    }
}

/**
 * Parsing rhythm "x~~~ x--- x~~~ x~--"
 */
Expr *parse_rhythm(TokenScanner *scanner, Environment *environment)
{
    Token *token = token_scanner_next(scanner);
    Expr *expr = expr_constant_rhythm(environment_next_expr((environment)), &token->pos);
    Rhythm *rhythm = &(expr->def.constant.value.rhythm);

    Scanner rhythm_scanner = {.content = token->lexeme, .cur_index = 0, .length = strlen(token->lexeme)};
    int index = 0;

    while (scanner_has_next(&rhythm_scanner))
    {
        if (scanner_peek(&rhythm_scanner) == 'x')
        {
            int start = rhythm_scanner.cur_index;
            scanner_next(&rhythm_scanner);
            parse_rhythm_eat_duration(&rhythm_scanner);
            int duration = rhythm_scanner.cur_index - start;
            rhythm->hits[index].start = start;
            rhythm->hits[index].duration = duration;
            index++;
        }
        else if (scanner_peek(&rhythm_scanner) == '-')
        {
            parse_rhythm_eat_rest(&rhythm_scanner);
        }
        else
        {
            assert_that(false, "INVALID RHYTHM");
            scanner_next(&rhythm_scanner);
        }
    }
    rhythm->length = index;
    return expr;
}