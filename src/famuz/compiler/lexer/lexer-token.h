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

typedef enum
{
    L_HIT = 'x',

    L_LEFT_BRACKET = '{',
    L_RIGHT_BRACKET = '}',

    L_LEFT_PARAM = '(',
    L_RIGHT_PARAM = ')',
    L_COMMA = ',',
    L_ASSIGNMENT = '=',

    L_ADD = '+',
    L_FORWARD_SLASH = '/',

    L_DURATION = '~',
    L_REST = '-',

    L_TAB = '\t',
    L_SPACE = ' ',
    L_LINE = '\n',

    L_ZERO = '0',
    L_ONE = '1',
    L_TWO = '2',
    L_THREE = '3',
    L_FOUR = '4',
    L_FIVE = '5',
    L_SIX = '6',
    L_SEVEN = '7',
    L_EIGHT = '8',
    L_NINE = '9'
} LexerToken;