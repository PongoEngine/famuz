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
#include "./precedence.h"
#include "../environment.h"

/**
 * Parsing call "arp(...)"
 */
Expr *
parse_call(Expr *left, TokenScanner *scanner, Environments *environments, int env_id, Stack *stack) {
    Token *token = token_scanner_next(scanner); //left parentheses
    static char temp[SETTINGS_LEXEME_LENGTH];
    strcpy(temp, left->def.constant.value.identifier);
    Expr *expr = expr_call(left, &token->pos, temp);

    int params_length = 0;
    int assigned_pointer = false;
    while (token_scanner_has_next(scanner) && token_scanner_peek(scanner)->type != RIGHT_PARAM) {
        Expr *param = parse_expression(PRECEDENCE_CALL, scanner, environments, env_id, stack);
        if (!assigned_pointer) {
            expr->def.call.params = param;
            assigned_pointer = true;
        }
        if (token_scanner_peek((scanner))->type == COMMA) {
            token_scanner_next(scanner); //consume comma
        }
        params_length++;
    }

    expr->def.call.params_length = params_length;
    assert_that(token_scanner_has_next(scanner) && token_scanner_next(scanner)->type == RIGHT_PARAM,
                "EXPECTED RIGHT PARAM");
    Expr *function_def = environment_find(environments, env_id, expr->def.call.identifier);
    expr->ret_type = function_def == NULL ? -1 : function_def->ret_type;

    return expr;
}