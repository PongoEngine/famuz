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
    public static function parse(precedence :Int, scanner :TokenScanner, context :Context) : Expr
    {
        if (scanner.hasNext()) {
            var left = parseExpressionPrefix(scanner, context);
            if (!Assert.that(left != null, "IN PARSE EXPRESSION LEFT IS NULL\n")) {
                if (scanner.hasNext()) {
                    scanner.next();
                }
                return null;
            }

            while (scanner.hasNext() && precedence < scanner.getPrecedence())
            {
                left = parseExpressionInfix(left, scanner, context);
            }
            return left;
        }
        else
        {
            return null;
        }
    }

    private static function parseConsume(scanner :TokenScanner) : Expr
    {
        scanner.next();
        return null;
    }

    private static function parseExpressionPrefix(scanner :TokenScanner, context :Context) : Expr
    {
        return switch (scanner.peek().type) {
            case TTPunctuator(type):
                switch type {
                    case COLON: parseConsume(scanner);
                    case ADD: parseConsume(scanner);
                    case ASSIGNMENT: parseConsume(scanner);
                    case LEFT_PARENTHESES: ParserParentheses.parse(scanner, context);
                    case RIGHT_PARENTHESES: parseConsume(scanner);
                    case LEFT_BRACE: ParserBlock.parse(scanner, context);
                    case RIGHT_BRACE: parseConsume(scanner);
                    case LEFT_BRACKET: ParserArray.parse(scanner, context);
                    case RIGHT_BRACKET: parseConsume(scanner);
                    case SHIFT_LEFT: parseConsume(scanner);
                    case SHIFT_RIGHT: parseConsume(scanner);
                    case SLASH: parseConsume(scanner);
                    case COMMA: parseConsume(scanner);
                }
            case TTKeyword(type): switch type {
                case FUNC: ParserFunc.parse(scanner, context);
                case PRINT: ParserPrint.parse(scanner, context);
                case IF: parseConsume(scanner);
            }
            case TTIdentifier(str): ParserIdentifier.parse(scanner, context, str);
            case TTScale(scale): ParserScale.parse(scanner, context, scale);
            case TTKey(key): ParserKey.parse(scanner, context, key);
            case TTNumber(str): ParserNumber.parse(scanner, context, str);
            case TTRhythm(str): ParserRhythm.parse(scanner, context, str);
            case TTType(type): parseConsume(scanner);
        }
    }
    
    private static function parseExpressionInfix(left :Expr, scanner :TokenScanner, context :Context) : Expr
    {
        return switch (scanner.peek().type) {
            case TTPunctuator(type):
                switch type {
                    case COLON: ParserTyping.parse(left, scanner, context);
                    case ADD: ParserBinop.parse(left, scanner, context, type);
                    case ASSIGNMENT: ParserVar.parse(left, scanner, context);
                    case LEFT_PARENTHESES: ParserCall.parse(left, scanner, context);
                    case RIGHT_PARENTHESES: null;
                    case LEFT_BRACE: null;
                    case RIGHT_BRACE: null;
                    case LEFT_BRACKET: ParserArrayAccess.parse(left, scanner, context);
                    case RIGHT_BRACKET: null;
                    case SHIFT_LEFT: ParserBinop.parse(left, scanner, context, type);
                    case SHIFT_RIGHT: ParserBinop.parse(left, scanner, context, type);
                    case SLASH: null;
                    case COMMA: null;
                }
            case TTKeyword(type): null;
            case TTIdentifier(str): null;
            case TTScale(str): null;
            case TTKey(str): null;
            case TTNumber(str): null;
            case TTRhythm(str): null;
            case TTType(type): null;
        }
    }
}