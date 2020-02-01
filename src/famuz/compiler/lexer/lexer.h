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
#include "./lexer-token.h"
#include "./reserved.h"

void create_token(TokenType type, Scanner *scanner, Token *token)
{
    int min = scanner->cur_index;
    char lexeme[2] = "\0";
    lexeme[0] = scanner_next(scanner);
    int max = scanner->cur_index;
    token->type = type;
    strcpy(token->lexeme, lexeme);

    position_update(&(token->pos), min, max, scanner->file_path);
}

TokenType word_type(char *str)
{
    if (strcmp(R_MAIN, str) == 0 || strcmp(R_CHORD, str) == 0 || strcmp(R_ARP, str) == 0)
    {
        return IDENTIFIER;
    }
    else if (strcmp(R_C, str) == 0 || strcmp(R_C_SHARP, str) == 0 || strcmp(R_D_FLAT, str) == 0 || strcmp(R_D, str) == 0 || strcmp(R_D_SHARP, str) == 0 || strcmp(R_E_FLAT, str) == 0 || strcmp(R_E, str) == 0 || strcmp(R_F, str) == 0 || strcmp(R_F_SHARP, str) == 0 || strcmp(R_G_FLAT, str) == 0 || strcmp(R_G, str) == 0 || strcmp(R_G_SHARP, str) == 0 || strcmp(R_A_FLAT, str) == 0 || strcmp(R_A, str) == 0 || strcmp(R_A_SHARP, str) == 0 || strcmp(R_B_FLAT, str) == 0 || strcmp(R_B, str) == 0)
    {
        return KEY;
    }
    else if (strcmp(R_MAJOR, str) == 0 || strcmp(R_NATURAL_MINOR, str) == 0 || strcmp(R_MELODIC_MINOR, str) == 0 || strcmp(R_HARMONIC_MINOR, str) == 0)
    {
        return SCALE;
    }
    else if (strcmp(R_TRIAD, str) == 0)
    {
        return CHORD;
    }
    else if (strcmp(R_FUNC, str) == 0)
    {
        return FUNC;
    }
    else
    {
        return IDENTIFIER;
    }
}

void create_token_identifier(Scanner *scanner, Token *token)
{
    int min = scanner->cur_index;
    scanner_consume_identifier(scanner, token->lexeme);
    int max = scanner->cur_index;
    token->type = word_type(token->lexeme);
    position_update(&(token->pos), min, max, scanner->file_path);
}

void create_token_rhythm(Scanner *scanner, Token *token)
{
    int min = scanner->cur_index;
    scanner_consume_rhythm(scanner, token->lexeme);
    int max = scanner->cur_index;
    token->type = RHYTHM;
    position_update(&(token->pos), min, max, scanner->file_path);
}

void create_token_steps(Scanner *scanner, Token *token)
{
    int min = scanner->cur_index;
    scanner_consume_steps(scanner, token->lexeme);
    int max = scanner->cur_index;
    token->type = STEPS;
    position_update(&(token->pos), min, max, scanner->file_path);
}

int lex(char *content, char *file_path, Token *tokens)
{
    Scanner scanner = {.content = content, .file_path = file_path, .cur_index = 0, .length = strlen(content)};
    int index = 0;
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
        case L_FORWARD_SLASH:
            scanner_peek_double(&scanner) == '/'
                ? scanner_consume_comment(&scanner)
                : scanner_next(&scanner);
            break;
        case L_DURATION:
            scanner_next(&scanner);
            printf("FAILURE");
            break;
        case L_REST:
            scanner_next(&scanner);
            printf("FAILURE");
            break;
        case L_TAB:
        case L_SPACE:
        case L_LINE:
        case L_CARRAIGE:
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
            create_token_steps(&scanner, &tokens[index++]);
            break;

        default:
            create_token_identifier(&scanner, &tokens[index++]);
            break;
        }
    }
    return index;
}
