package famuz.compiler.parser;

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

import famuz.compiler.Token;

class Precedence
{
    public static inline var PRECEDENCE_ASSIGNMENT = 1;
    public static inline var PRECEDENCE_SUM = 2;
	public static inline var PRECEDENCE_CALL = 3;
	public static inline var PRECEDENCE_ARRAY = 3;
    public static inline var PRECEDENCE_TYPE = 4;

    public static function getPrecedence(scanner :TokenScanner) : Int
    {
        return switch (scanner.peek().type)
        {
            case TTPunctuator(type): {
                switch type {
                    case ASSIGNMENT:
                        PRECEDENCE_ASSIGNMENT;
                    case ADD, SHIFT_LEFT, SHIFT_RIGHT:
                        PRECEDENCE_SUM;
                    case LEFT_PARENTHESES:
                        PRECEDENCE_CALL;
                    case LEFT_BRACKET:
                        PRECEDENCE_ARRAY;
                    case COLON:
                        PRECEDENCE_TYPE;
                    default:
                        0;
                }
            }
            default:
                0;
        }
    }
}