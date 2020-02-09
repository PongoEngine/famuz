#pragma once

/*
 * MIT License
 *
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

#include <stdbool.h>
#include "../util/string-util.h"

typedef struct
{
    char *content;
    char *file_path;
    int cur_index;
    unsigned long length;
} Scanner;

bool scanner_has_next(Scanner *scanner)
{
    return scanner->cur_index < scanner->length;
}

char scanner_next(Scanner *scanner)
{
    return scanner->content[scanner->cur_index++];
}

char scanner_peek(Scanner *scanner)
{
    return scanner->content[scanner->cur_index];
}

char scanner_peek_double(Scanner *scanner)
{
    return scanner->content[scanner->cur_index + 1];
}

void scanner_consume_whitespace(Scanner *scanner)
{
    while (scanner_has_next(scanner) && is_whitespace(scanner_peek(scanner)))
    {
        scanner_next(scanner);
    }
}

void scanner_consume_comment(Scanner *scanner)
{
    while (scanner_has_next(scanner) && scanner_peek(scanner) != '\n')
    {
        scanner_next(scanner);
    }
}

void scanner_consume_identifier(Scanner *scanner, char *str)
{
    int index = 0;
    while (scanner_has_next(scanner) && is_identifer(scanner_peek(scanner)))
    {
        str[index++] = scanner_next(scanner);
    }
    str[index] = '\0';
}

void scanner_consume_rhythm(Scanner *scanner, char *str)
{
    int index = 0;
    while (scanner_has_next(scanner) && (is_rhythm(scanner_peek(scanner)) || scanner_peek(scanner) == L_SPACE))
    {
        char c = scanner_next(scanner);
        if (c != L_SPACE)
        {
            str[index++] = c;
        }
    }
    str[index] = '\0';
}

void scanner_consume_steps(Scanner *scanner, char *str)
{
    int index = 0;
    while (scanner_has_next(scanner) && (is_steps(scanner_peek(scanner)) || scanner_peek(scanner) == L_SPACE))
    {
        char c = scanner_next(scanner);
        if (c != L_SPACE)
        {
            str[index++] = c;
        }
    }
    str[index] = '\0';
}