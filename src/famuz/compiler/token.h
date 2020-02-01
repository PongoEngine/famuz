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

#include <stdbool.h>
#include "./position.h"
#include "./settings.h"

typedef enum
{
    IDENTIFIER = 1,
    SCALE,
    CHORD,
    FUNC,
    KEY,
    WHITESPACE,
    STEPS,
    RHYTHM,
    COMMENT,
    ADD,
    ASSIGNMENT,
    LEFT_PARAM,
    RIGHT_PARAM,
    LEFT_BRACKET,
    RIGHT_BRACKET,
    COMMA,
    SLASH
} TokenType;

typedef struct
{
    TokenType type;
    char lexeme[SETTINGS_LEXEME_LENGTH];
    Position pos;
} Token;

typedef struct
{
    Token tokens[SETTINGS_TOKENS_LENGTH];
    int cur_index;
    int length;
} TokenScanner;

void print_token(Token *t)
{
    char *type;
    switch (t->type)
    {
    case IDENTIFIER:
        type = "IDENTIFIER";
        break;
    case SCALE:
        type = "SCALE";
        break;
    case CHORD:
        type = "CHORD";
        break;
    case KEY:
        type = "KEY";
        break;
    case WHITESPACE:
        type = "WHITESPACE";
        break;
    case STEPS:
        type = "STEPS";
        break;
    case RHYTHM:
        type = "RHYTHM";
        break;
    case COMMENT:
        type = "COMMENT";
        break;
    case ADD:
        type = "ADD";
        break;
    case ASSIGNMENT:
        type = "ASSIGNMENT";
        break;
    case LEFT_PARAM:
        type = "LEFT_PARAM";
        break;
    case RIGHT_PARAM:
        type = "RIGHT_PARAM";
        break;
    case LEFT_BRACKET:
        type = "LEFT_BRACKET";
        break;
    case RIGHT_BRACKET:
        type = "RIGHT_BRACKET";
        break;
    case COMMA:
        type = "COMMA";
        break;
    case SLASH:
        type = "SLASH";
        break;
    case FUNC:
        type = "FUNC";
        break;
    }
    printf("{ %s, %s, %s }\n", t->pos.file, type, t->lexeme);
}

bool token_scanner_has_next(TokenScanner *scanner)
{
    return scanner->cur_index < scanner->length;
}

Token token_scanner_next(TokenScanner *scanner)
{
    return scanner->tokens[scanner->cur_index++];
}

Token token_scanner_peek(TokenScanner *scanner)
{
    return scanner->tokens[scanner->cur_index];
}