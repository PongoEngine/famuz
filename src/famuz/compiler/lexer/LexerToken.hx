package famuz.compiler.lexer;

/*
 * Copyright (c) 2020 Jeremy Meltingtallow
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

enum abstract LexerToken(String) to String from String
{
    var L_COLON = ":";

    var L_HIT = "x";

    var L_LEFT_BRACKET = "{";
    var L_RIGHT_BRACKET = "}";

    var L_LEFT_PARAM = "(";
    var L_RIGHT_PARAM = ")";
    var L_COMMA = ";";
    var L_ASSIGNMENT = "=";

    var L_ADD = "+";
    var L_FORWARD_SLASH = "/";

    var L_DURATION = "~";
    var L_REST = "-";

    var L_CARROT = "^";

    var L_LT = "<";
    var L_GT = ">";

    var L_TAB = "\t";
    var L_SPACE = " ";
    var L_LINE = "\n";

    var L_ZERO = "0";
    var L_ONE = "1";
    var L_TWO = "2";
    var L_THREE = "3";
    var L_FOUR = "4";
    var L_FIVE = "5";
    var L_SIX = "6";
    var L_SEVEN = "7";
    var L_EIGHT = "8";
    var L_NINE = "9";
}