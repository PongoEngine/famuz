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
import famuz.compiler.expr.Expr;
import famuz.compiler.parser.ParserBinop;
import famuz.compiler.parser.ParserBlock;
import famuz.compiler.parser.ParserCall;
import famuz.compiler.parser.ParserFunc;
import famuz.compiler.parser.ParserIdentifier;
import famuz.compiler.parser.ParserKey;
import famuz.compiler.parser.ParserNumber;
import famuz.compiler.parser.ParserParentheses;
import famuz.compiler.parser.ParserPrint;
import famuz.compiler.parser.ParserBool;
import famuz.compiler.parser.ParserRhythm;
import famuz.compiler.parser.ParserScale;
import famuz.compiler.parser.ParserArrayAccess;
import famuz.compiler.parser.ParserStruct;
import famuz.compiler.parser.ParserIf;
import famuz.compiler.parser.ParserLet;
import famuz.compiler.parser.ParserSwitch;
import famuz.compiler.parser.ParserDot;
import famuz.compiler.parser.ParserUnop;
using famuz.compiler.parser.Precedence;

class Parser
{
    public static function parse(precedence :Precedence, scanner :TokenScanner, context :Context, isFunc :Bool) : Expr
    {
        if (scanner.hasNext()) {
            var left = parseExpressionPrefix(scanner, context, isFunc);
            // if (left == null) {
            //     if (scanner.hasNext()) {
            //         scanner.next();
            //     }
            //     return null;
            // }

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
        if(scanner.hasNext()) {
            scanner.next();
        }
        return null;
    }

    private static function parseExpressionPrefix(scanner :TokenScanner, context :Context, isFunc :Bool) : Expr
    {
        return switch (scanner.peek().type) {
            case TTPunctuator(type):
                switch type {
                    case LEFT_PARENTHESES: 
                        ParserParentheses.parse(scanner, context);
                    case LEFT_BRACE:
                        isFunc
                            ? ParserBlock.parse(scanner, context)
                            : ParserStruct.parse(scanner, context);
                    case LEFT_BRACKET: 
                        ParserArray.parse(scanner, context);
                    case MINUS, BANG:
                        ParserUnop.parse(scanner, context);
                    case GREATER_THAN, EQUALITY, WRAP, ADD, EQUALS, RIGHT_PARENTHESES, RIGHT_BRACE,
                        RIGHT_BRACKET, SHIFT_LEFT, SHIFT_RIGHT, SLASH,
                        COMMA, PERIOD, QUESTION_MARK, COLON:
                        parseConsume(scanner);
                }
            case TTKeyword(type): switch type {
                case IMPORT:
                    throw "err";
                case LET:
                    ParserLet.parse(scanner, context);
                case FUNC: 
                    ParserFunc.parse(scanner, context);
                case PRINT: 
                    ParserPrint.parse(scanner, context);
                case IF: 
                    ParserIf.parse(scanner, context);
                case TRUE: 
                    ParserBool.parse(scanner, context, type);
                case FALSE: 
                    ParserBool.parse(scanner, context, type);
                case SWITCH:
                    ParserSwitch.parse(scanner, context);
                case CASE:
                    parseConsume(scanner);
                case DEFAULT:
                    parseConsume(scanner);
            }
            case TTIdentifier(str):
                ParserIdentifier.parse(scanner, context, str);
            case TTScale(scale): 
                ParserScale.parse(scanner, context, scale);
            case TTKey(key): 
                ParserKey.parse(scanner, context, key);
            case TTNumber(str): 
                ParserNumber.parse(scanner, context, str);
            case TTRhythm(d, str): 
                ParserRhythm.parse(scanner, context, d, str);
        }
    }
    
    private static function parseExpressionInfix(left :Expr, scanner :TokenScanner, context :Context) : Expr
    {
        return switch (scanner.peek().type) {
            case TTPunctuator(type):
                switch type {
                    case ADD, MINUS, SHIFT_LEFT, SHIFT_RIGHT, WRAP, EQUALITY, GREATER_THAN: 
                            ParserBinop.parse(left, scanner, context, type);
                    case LEFT_BRACKET: 
                            ParserArrayAccess.parse(left, scanner, context);
                    case PERIOD:
                            ParserDot.parse(left, scanner, context);
                    case QUESTION_MARK:
                        ParserTernary.parse(left, scanner, context);
                    case LEFT_PARENTHESES:
                        ParserCall.parse(left, scanner, context);
                    case EQUALS, BANG, RIGHT_PARENTHESES, LEFT_BRACE, RIGHT_BRACE, 
                        RIGHT_BRACKET, SLASH, COMMA, COLON: 
                        null;
                }
            case TTKeyword(_): 
                null;
            case TTIdentifier(_): 
                null;
            case TTScale(_): 
                null;
            case TTKey(_): 
                null;
            case TTNumber(_): 
                null;
            case TTRhythm(_): 
                null;
        }
    }
}