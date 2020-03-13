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

import famuz.compiler.Error;
import famuz.compiler.Token;
import famuz.util.Assert;
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
import famuz.compiler.parser.ParserVar;
import famuz.compiler.parser.ParserArrayAccess;
import famuz.compiler.parser.ParserStruct;
import famuz.compiler.parser.ParserIf;
import famuz.compiler.parser.ParserSwitch;
import famuz.compiler.parser.ParserDot;
import famuz.compiler.parser.ParserUnop;
import famuz.compiler.parser.ParserEnum;
using famuz.compiler.parser.Precedence;

class Parser
{
    public static function parse(precedence :Precedence, scanner :TokenScanner, context :Context, error :Error, isFunc :Bool) : Expr
    {
        if (scanner.hasNext()) {
            while(isEnumType(scanner)) {
                ParserEnum.parse(scanner, context, error);
            }
            var left = parseExpressionPrefix(scanner, context, error, isFunc);
            if (!Assert.that(left != null, "IN PARSE EXPRESSION LEFT IS NULL\n")) {
                if (scanner.hasNext()) {
                    scanner.next();
                }
                return null;
            }

            while (scanner.hasNext() && precedence < scanner.getPrecedence())
            {
                left = parseExpressionInfix(left, scanner, context, error);
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
        return EMPTY_EXPR;
    }

    private static function parseExpressionPrefix(scanner :TokenScanner, context :Context, error :Error, isFunc :Bool) : Expr
    {
        return switch (scanner.peek().type) {
            case TTPunctuator(type):
                switch type {
                    case LEFT_PARENTHESES: 
                        ParserParentheses.parse(scanner, context, error);
                    case LEFT_BRACE:
                        isFunc
                            ? ParserBlock.parse(scanner, context, error)
                            : ParserStruct.parse(scanner, context, error);
                    case LEFT_BRACKET: 
                        ParserArray.parse(scanner, context, error);
                    case MINUS, BANG:
                        ParserUnop.parse(scanner, context, error);
                    case ADD, ASSIGNMENT, RIGHT_PARENTHESES, RIGHT_BRACE,
                        RIGHT_BRACKET, SHIFT_LEFT, SHIFT_RIGHT, SLASH,
                        COMMA, PERIOD, QUESTION_MARK, COLON:
                        parseConsume(scanner);
                }
            case TTKeyword(type): switch type {
                case FUNC: 
                    ParserFunc.parse(scanner, context, error);
                case PRINT: 
                    ParserPrint.parse(scanner, context, error);
                case IF: 
                    ParserIf.parse(scanner, context, error);
                case TRUE: 
                    ParserBool.parse(scanner, context, error);
                case FALSE: 
                    ParserBool.parse(scanner, context, error);
                case SWITCH:
                    ParserSwitch.parse(scanner, context, error);
                case CASE:
                    parseConsume(scanner);
                case DEFAULT:
                    parseConsume(scanner);
                case ENUM:
                    throw "err";
            }
            case TTIdentifier(str): 
                ParserIdentifier.parse(scanner, context, str);
            case TTScale(scale): 
                ParserScale.parse(scanner, context, scale);
            case TTKey(key): 
                ParserKey.parse(scanner, context, key);
            case TTNumber(str): 
                ParserNumber.parse(scanner, context, str);
            case TTRhythm(str): 
                ParserRhythm.parse(scanner, context, str);
        }
    }
    
    private static function parseExpressionInfix(left :Expr, scanner :TokenScanner, context :Context, error :Error) : Expr
    {
        return switch (scanner.peek().type) {
            case TTPunctuator(type):
                switch type {
                    case ADD: 
                            ParserBinop.parse(left, scanner, context, error, type);
                    case MINUS: 
                            ParserBinop.parse(left, scanner, context, error, type);
                    case ASSIGNMENT: 
                            ParserVar.parse(left, scanner, context, error);
                    case LEFT_PARENTHESES: 
                            ParserCall.parse(left, scanner, context, error);
                    case LEFT_BRACKET: 
                            ParserArrayAccess.parse(left, scanner, context, error);
                    case SHIFT_LEFT: 
                            ParserBinop.parse(left, scanner, context, error, type);
                    case SHIFT_RIGHT: 
                            ParserBinop.parse(left, scanner, context, error, type);
                    case PERIOD:
                            ParserDot.parse(left, scanner, context, error);
                    case QUESTION_MARK:
                        ParserTernary.parse(left, scanner, context, error);
                    case BANG, RIGHT_PARENTHESES, LEFT_BRACE, RIGHT_BRACE, 
                        RIGHT_BRACKET, SLASH, COMMA, COLON: 
                            EMPTY_EXPR;
                }
            case TTKeyword(type): 
                EMPTY_EXPR;
            case TTIdentifier(str): 
                EMPTY_EXPR;
            case TTScale(str): 
                EMPTY_EXPR;
            case TTKey(str): 
                EMPTY_EXPR;
            case TTNumber(str): 
                EMPTY_EXPR;
            case TTRhythm(str): 
                EMPTY_EXPR;
        }
    }

    private static function isEnumType(scanner :TokenScanner) : Bool
    {
        return switch scanner.peek().type {
            case TTKeyword(type): switch type {
                case ENUM: true;
                case _: false;
            }
            case _: false;
        }
    }

    private static var EMPTY_EXPR :Expr = null;
}