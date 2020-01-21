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
#include <stdbool.h>
#include "./util/file-util.h"
#include "./compiler/lexer/lexer.h"
#include "./compiler/token.h"
#include "./compiler/expr.h"
#include "./compiler/parser/parser.h"
#include "./compiler/parser/expr-printer.h"
#include "./compiler/generator/generate.h"

bool is_main(Expr *expr)
{
    return expr->def_type == E_CALL &&
           expr->expr.call.e->def_type == E_CONST &&
           expr->expr.call.e->expr.constant.type == C_IDENTIFIER &&
           strcmp(expr->expr.call.e->expr.constant.value.identifier, "main") == 0;
}

void famuz_parse(char *file_path)
{
    if (file_exists(file_path))
    {
        char content[2048];
        file_content(file_path, content);
        TokenScanner token_scanner;
        token_scanner.length = lex(content, file_path, token_scanner.tokens);
        token_scanner.cur_index = 0;
        //
        Exprs exprs;
        exprs.main = NULL;
        exprs.cur_index = 0;

        while (token_scanner_has_next(&token_scanner))
        {
            Expr *expr = parse_expression(&token_scanner, &exprs);
            if (is_main(expr))
            {
                exprs.main = expr;
            }
            expr_print(expr, 0);
        }

        if (exprs.main == NULL)
        {
            // printf("No Main Found!");
        }
        else
        {
            generate(exprs.main);
        }
    }
}