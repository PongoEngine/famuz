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
#include "./compiler/lexer/lexer.h"
#include "./compiler/environment.h"
#include "./compiler/stack.h"
#include "./compiler/parser/parser.h"
#include "../../util/file-util.h"

void famuz_parse(char *file_path)
{
    if (file_exists(file_path))
    {
        TokenScanner token_scanner;
        char content[2048];
        file_content(file_path, content);

        lex(file_path, content, &token_scanner);

        Environments environments;
        environments_initialize(&environments);
        Environment *environment = environments_create(&environments, -1);

        Stack stack;
        while (token_scanner_has_next(&token_scanner)) {
            parse_expression(0, &token_scanner, environment, &environments, &stack);
        }
    }
}