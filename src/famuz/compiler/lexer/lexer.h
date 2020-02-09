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
#include "../token.h"
#include "../scanner.h"
#include "../reserved.h"
#include "../../util/file-util.h"

void create_token(TokenType type, Scanner *scanner, Token *token)
{
    int line = scanner->cur_line;
    int min = scanner->cur_index;
    char lexeme[2] = {scanner_next(scanner), '\0'};
    int max = scanner->cur_index;
    token->type = type;
    strcpy(token->lexeme, lexeme);

    position_update(&(token->pos), line, min, max, scanner->file_path);
}

TokenType word_type(char *str)
{
    if (type_is_key(str))
    {
        return KEY;
    }
    else if (type_is_scale(str))
    {
        return SCALE;
    }
    else if (reserved_is_func(str))
    {
        return FUNC;
    }
    else if (reserved_is_print(str))
    {
        return PRINT;
    }
    else
    {
        return IDENTIFIER;
    }
}

void create_token_identifier(Scanner *scanner, Token *token)
{
    int line = scanner->cur_line;
    int min = scanner->cur_index;
    scanner_consume_identifier(scanner, token->lexeme);
    int max = scanner->cur_index;
    token->type = word_type(token->lexeme);
    position_update(&(token->pos), line, min, max, scanner->file_path);
}

void create_token_rhythm(Scanner *scanner, Token *token)
{
    int line = scanner->cur_line;
    int min = scanner->cur_index;
    scanner_consume_rhythm(scanner, token->lexeme);
    int max = scanner->cur_index;
    token->type = RHYTHM;
    position_update(&(token->pos), line, min, max, scanner->file_path);
}

void create_token_steps(Scanner *scanner, Token *token)
{
    scanner_next(scanner); //consume ^
    int line = scanner->cur_line;
    int min = scanner->cur_index;
    scanner_consume_steps(scanner, token->lexeme);
    int max = scanner->cur_index;
    token->type = STEPS;
    position_update(&(token->pos), line, min, max, scanner->file_path);
}

void create_token_number(Scanner *scanner, Token *token)
{
    int line = scanner->cur_line;
    int min = scanner->cur_index;
    scanner_consume_number(scanner, token->lexeme);
    int max = scanner->cur_index;
    token->type = NUMBER;
    position_update(&(token->pos), line, min, max, scanner->file_path);
}

void lex(char *file_path, TokenScanner *token_scanner)
{
    char content[2048];
    file_content(file_path, content);
    Scanner scanner = {.content = content, .file_path = file_path, .cur_index = 0, .cur_line = 1, .length = strlen(content)};
    int index = 0;
    Token *tokens = token_scanner->tokens;
    while (scanner_has_next(&scanner))
    {
        LexerToken lexer_token = scanner_peek(&scanner);
        switch (lexer_token)
        {
        case L_HIT:
        {
            char db = scanner_peek_double(&scanner);
            (db == L_REST || db == L_DURATION || db == L_SPACE)
                ? create_token_rhythm(&scanner, &tokens[index++])
                : create_token_identifier(&scanner, &tokens[index++]);
            break;
        }
        case L_ASSIGNMENT:
            create_token(ASSIGNMENT, &scanner, &tokens[index++]);
            break;
        case L_COLON:
            create_token(COLON, &scanner, &tokens[index++]);
            break;
        case L_LEFT_PARAM:
            create_token(LEFT_PARAM, &scanner, &tokens[index++]);
            break;
        case L_RIGHT_PARAM:
            create_token(RIGHT_PARAM, &scanner, &tokens[index++]);
            break;
        case L_LEFT_BRACKET:
            create_token(LEFT_BRACKET, &scanner, &tokens[index++]);
            break;
        case L_RIGHT_BRACKET:
            create_token(RIGHT_BRACKET, &scanner, &tokens[index++]);
            break;
        case L_COMMA:
            create_token(COMMA, &scanner, &tokens[index++]);
            break;
        case L_ADD:
            create_token(ADD, &scanner, &tokens[index++]);
            break;
        case L_CARROT:
            create_token_steps(&scanner, &tokens[index++]);
            break;
        case L_FORWARD_SLASH:
            scanner_peek_double(&scanner) == '/'
                ? scanner_consume_comment(&scanner)
                : scanner_next(&scanner);
            break;
        case L_DURATION:
        case L_REST:
            scanner_next(&scanner);
            break;
        case L_TAB:
        case L_SPACE:
        case L_LINE:
        case L_CARRIAGE:
        case L_TERMINATOR:
        case L_DELETE:
            scanner_consume_whitespace(&scanner);
            break;
        case L_ZERO:
        case L_ONE:
        case L_TWO:
        case L_THREE:
        case L_FOUR:
        case L_FIVE:
        case L_SIX:
        case L_SEVEN:
        case L_EIGHT:
        case L_NINE:
            create_token_number(&scanner, &tokens[index++]);
            break;
        default:
            create_token_identifier(&scanner, &tokens[index++]);
            break;
        }
    }
    token_scanner->length = index;
    token_scanner->cur_index = 0;
}
