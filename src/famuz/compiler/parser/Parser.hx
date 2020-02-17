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
import famuz.util.Assert;
import famuz.compiler.parser.ParserBinop;
import famuz.compiler.parser.ParserBlock;
import famuz.compiler.parser.ParserCall;
import famuz.compiler.parser.ParserFunc;
import famuz.compiler.parser.ParserIdentifier;
import famuz.compiler.parser.ParserKey;
import famuz.compiler.parser.ParserNumber;
import famuz.compiler.parser.ParserParentheses;
import famuz.compiler.parser.ParserPrint;
import famuz.compiler.parser.ParserRhythm;
import famuz.compiler.parser.ParserScale;
import famuz.compiler.parser.ParserSteps;
import famuz.compiler.parser.ParserTyping;
import famuz.compiler.parser.ParserVar;
using famuz.compiler.parser.Precedence;

class Parser
{
    public static function parse(precedence :Int, scanner :TokenScanner, environment :Environment) : Expr
    {
        if (scanner.hasNext()) {
            var left = parseExpressionPrefix(scanner, environment);
            if (!Assert.that(left != null, "IN PARSE EXPRESSION LEFT IS NULL")) {
                if (scanner.hasNext()) {
                    scanner.next();
                }
                return null;
            }

            while (scanner.hasNext() && precedence < scanner.getPrecedence())
            {
                left = parseExpressionInfix(left, scanner, environment);
            }
            return left;
        }
        else
        {
            return null;
        }
    }

    private static function parseExpressionPrefix(scanner :TokenScanner, environment :Environment) : Expr
    {
        return switch (scanner.peek().type) {
            case IDENTIFIER:
                return ParserIdentifier.parse(scanner, environment);
            case NUMBER:
                return ParserNumber.parse(scanner, environment);
            case SCALE:
                return ParserScale.parse(scanner, environment);
            case KEY:
                return ParserKey.parse(scanner, environment);
            case STEPS:
                return ParserSteps.parse(scanner, environment);
            case RHYTHM:
                return ParserRhythm.parse(scanner, environment);
            case LEFT_PARAM:
                return ParserParentheses.parse(scanner, environment);
            case LEFT_BRACKET:
                return ParserBlock.parse(scanner, environment);
            case FUNC:
                return ParserFunc.parse(scanner, environment);
            case PRINT:
                return ParserPrint.parse(scanner, environment);
            case RIGHT_PARAM, RIGHT_BRACKET, COMMA, SLASH, 
                COMMENT, WHITESPACE, ADD, ASSIGNMENT, COLON, 
                SHIFT_LEFT, SHIFT_RIGHT:
                {
                    scanner.next();
                    null;
                }
        }
    }
    
    private static function parseExpressionInfix(left :Expr, scanner :TokenScanner, environment :Environment) : Expr
    {
        return switch (scanner.peek().type) {
            case ADD:
                return ParserBinop.parse(left, scanner, environment);
            case ASSIGNMENT:
                return ParserVar.parse(left, scanner, environment);
            case LEFT_PARAM:
                return ParserCall.parse(left, scanner, environment);
            case COLON:
                return ParserTyping.parse(left, scanner, environment);
            case SHIFT_LEFT:
                return ParserBinop.parse(left, scanner, environment);
            case SHIFT_RIGHT:
                return ParserBinop.parse(left, scanner, environment);
            case RIGHT_PARAM, LEFT_BRACKET, RIGHT_BRACKET, COMMA, 
                SLASH, IDENTIFIER, SCALE, KEY, WHITESPACE, STEPS, 
                COMMENT, RHYTHM, FUNC, PRINT, NUMBER:
                null;
        }
    }
}