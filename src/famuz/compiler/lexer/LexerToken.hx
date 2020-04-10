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

package famuz.compiler.lexer;

enum abstract LexerToken(String) from String
{
    var HIT = "x";

    var LEFT_BRACE = "{";
    var RIGHT_BRACE = "}";

    var LEFT_BRACKET = "[";
    var RIGHT_BRACKET = "]";

    var LEFT_PARENTHESES = "(";
    var RIGHT_PARENTHESES = ")";
    var COMMA = ",";
    var QUESTION_MARK = "?";
    var COLON = ":";
    var PERIOD = ".";
    var EQUALS = "=";

    var DOLLAR = "$";

    var ADD = "+";
    var MULTIPLY = "*";
    var MINUS = "-";
    var BANG = "!";
    var FORWARD_SLASH = "/";
    var BACKWARD_SLASH = "\\";

    var DURATION = "~";
    var REST = "-";

    var LT = "<";
    var GT = ">";

    var AT = "@";
    
    var QUOTES = '"';

    var TAB = "\t";
    var SPACE = " ";
    var LINE = "\n";

    var ZERO = "0";
    var ONE = "1";
    var TWO = "2";
    var THREE = "3";
    var FOUR = "4";
    var FIVE = "5";
    var SIX = "6";
    var SEVEN = "7";
    var EIGHT = "8";
    var NINE = "9";
}