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
import famuz.compiler.parser.ParserTyping;
import famuz.compiler.parser.ParserVar;
import famuz.compiler.parser.ParserArrayAccess;
using famuz.compiler.parser.Precedence;

class Parser
{
    public var errors (default, null):Array<{msg :String, pos :Position}>;

    public function new() : Void
    {
        this.errors = [];
    }

    public function parse(precedence :Int, scanner :TokenScanner, context :Context) : Expr
    {
        if (scanner.hasNext()) {
            var left = parseExpressionPrefix(this, scanner, context);
            if (!Assert.that(left != null, "IN PARSE EXPRESSION LEFT IS NULL\n")) {
                if (scanner.hasNext()) {
                    scanner.next();
                }
                return null;
            }

            while (scanner.hasNext() && precedence < scanner.getPrecedence())
            {
                left = parseExpressionInfix(this, left, scanner, context);
            }
            return left;
        }
        else
        {
            return null;
        }
    }

    public function assert<T>(that :Bool, success :() -> T, failure: () -> T, failureMsg :String, pos :Position) : T
    {
        return switch that {
            case true: success();
            case false: {
                this.errors.push({msg: failureMsg, pos: pos});
                failure();
            }
        }
    }

    private static function parseExpressionPrefix(parser :Parser, scanner :TokenScanner, context :Context) : Expr
    {
        return switch (scanner.peek().type) {
            case IDENTIFIER:
                return ParserIdentifier.parse(scanner, context);
            case NUMBER:
                return ParserNumber.parse(scanner, context);
            case SCALE:
                return ParserScale.parse(scanner, context);
            case KEY:
                return ParserKey.parse(scanner, context);
            case RHYTHM:
                return ParserRhythm.parse(scanner, context);
            case LEFT_PARENTHESES:
                return ParserParentheses.parse(parser, scanner, context);
            case LEFT_BRACE:
                return ParserBlock.parse(parser, scanner, context);
            case LEFT_BRACKET:
                return ParserArray.parse(parser, scanner, context);
            case FUNC:
                return ParserFunc.parse(parser, scanner, context);
            case PRINT:
                return ParserPrint.parse(parser, scanner, context);
            case RIGHT_PARENTHESES, RIGHT_BRACE, RIGHT_BRACKET, COMMA, SLASH, 
                COMMENT, WHITESPACE, ADD, ASSIGNMENT, COLON, 
                SHIFT_LEFT, SHIFT_RIGHT:
                {
                    scanner.next();
                    null;
                }
        }
    }
    
    private static function parseExpressionInfix(parser :Parser, left :Expr, scanner :TokenScanner, context :Context) : Expr
    {
        return switch (scanner.peek().type) {
            case ADD:
                return ParserBinop.parse(parser, left, scanner, context);
            case ASSIGNMENT:
                return ParserVar.parse(parser, left, scanner, context);
            case LEFT_PARENTHESES:
                return ParserCall.parse(parser, left, scanner, context);
			case LEFT_BRACKET:
				return ParserArrayAccess.parse(parser, left, scanner, context);
            case COLON:
                return ParserTyping.parse(left, scanner, context);
            case SHIFT_LEFT:
                return ParserBinop.parse(parser, left, scanner, context);
            case SHIFT_RIGHT:
                return ParserBinop.parse(parser, left, scanner, context);
            case RIGHT_PARENTHESES, LEFT_BRACE, RIGHT_BRACE, RIGHT_BRACKET, COMMA, 
                SLASH, IDENTIFIER, SCALE, KEY, WHITESPACE, 
                COMMENT, RHYTHM, FUNC, PRINT, NUMBER:
				trace("\n\n\n" + scanner.peek().type + "\n\n\n");
                null;
        }
    }
}