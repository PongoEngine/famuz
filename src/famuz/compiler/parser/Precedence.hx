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

package famuz.compiler.parser;

import famuz.compiler.Token;

class Precedence
{
    public static function get(type :TokenType) : Int
    {
        return switch (type)
        {
            case TTPunctuator(type): {
                switch type {
                    case RIGHT_BRACE: 0;
                    case RIGHT_PARENTHESES: 0;
                    case RIGHT_BRACKET: 0;
                    case COMMA: 0;
                    case ASSIGNMENT: 0;
                    case COLON: 0;
                    case BANG: 1;
                    case EQUALITY, GREATER_THAN, LESS_THAN, QUESTION_MARK: 3;
                    case ADD: 4;
                    case MINUS: 4;
                    case DIVIDE: 5;
                    case MULTIPLY: 5;
                    case LEFT_BRACE: 6;
                    case LEFT_PARENTHESES: 7;
                    case DOLLAR: 8;
                    case LEFT_BRACKET: 8;
                    case PERIOD: 9;
                }
            }
            default:
                0;
        }
    }
}