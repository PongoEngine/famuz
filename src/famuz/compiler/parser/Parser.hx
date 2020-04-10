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
import famuz.compiler.parser.ParserNumber;
import famuz.compiler.parser.ParserParentheses;
import famuz.compiler.parser.ParserPrint;
import famuz.compiler.parser.ParserBool;
import famuz.compiler.parser.ParserRhythm;
import famuz.compiler.parser.ParserArrayAccess;
import famuz.compiler.parser.ParserStruct;
import famuz.compiler.parser.ParserIf;
import famuz.compiler.parser.ParserLet;
import famuz.compiler.parser.ParserSwitch;
import famuz.compiler.parser.ParserDot;
import famuz.compiler.parser.ParserImport;
import famuz.compiler.parser.ParserUnop;
import famuz.compiler.parser.ParserString;
using famuz.compiler.parser.Precedence;

class Parser
{
    public static function parse(precedence :Precedence, scanner :TokenScanner, context :Context, imports :Map<String, Context>, isFunc :Bool) : Expr
    {
        if (scanner.hasNext()) {
            var left = parseExpressionPrefix(scanner, context, imports, isFunc);

            while (scanner.hasNext() && precedence < scanner.getPrecedence())
            {
                left = parseExpressionInfix(left, scanner, context, imports);
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

    private static function parseExpressionPrefix(scanner :TokenScanner, context :Context, imports :Map<String, Context>, isFunc :Bool) : Expr
    {
        return switch (scanner.peek().type) {
            case TTPunctuator(type):
                switch type {
                    case LEFT_PARENTHESES: 
                        ParserParentheses.parse(scanner, context, imports);
                    case LEFT_BRACE:
                        isFunc
                            ? ParserBlock.parse(scanner, context, imports)
                            : ParserStruct.parse(scanner, context, imports);
                    case LEFT_BRACKET: 
                        ParserArray.parse(scanner, context, imports);
                    case MINUS, BANG:
                        ParserUnop.parse(scanner, context, imports);
                    case GREATER_THAN, EQUALITY, ADD, DIVIDE, EQUALS, RIGHT_PARENTHESES, RIGHT_BRACE,
                        RIGHT_BRACKET, SHIFT_LEFT, SHIFT_RIGHT, SLASH,
                        COMMA, PERIOD, QUESTION_MARK, COLON:
                        parseConsume(scanner);
                }
            case TTKeyword(type): switch type {
                case IMPORT:
                    ParserImport.parse(scanner, context, imports);
                case LET:
                    ParserLet.parse(scanner, context, imports);
                case FUNC: 
                    ParserFunc.parse(scanner, context, imports);
                case PRINT: 
                    ParserPrint.parse(scanner, context, imports);
                case IF: 
                    ParserIf.parse(scanner, context, imports);
                case TRUE: 
                    ParserBool.parse(scanner, context, imports, type);
                case FALSE: 
                    ParserBool.parse(scanner, context, imports, type);
                case SWITCH:
                    ParserSwitch.parse(scanner, context, imports);
                case CASE:
                    parseConsume(scanner);
                case DEFAULT:
                    parseConsume(scanner);
            }
            case TTIdentifier(str):
                ParserIdentifier.parse(scanner, context, imports, str);
            case TTString(str):
                ParserString.parse(scanner, context, imports, str);
            case TTNumber(num): 
                ParserNumber.parse(scanner, context, imports, num);
            case TTRhythm(num, den, str): 
                ParserRhythm.parse(scanner, context, imports, num, den, str);
        }
    }
    
    private static function parseExpressionInfix(left :Expr, scanner :TokenScanner, context :Context, imports :Map<String, Context>) : Expr
    {
        return switch (scanner.peek().type) {
            case TTPunctuator(type):
                switch type {
                    case ADD, MINUS, SHIFT_LEFT, SHIFT_RIGHT, EQUALITY, GREATER_THAN, DIVIDE: 
                            ParserBinop.parse(left, scanner, context, imports, type);
                    case LEFT_BRACKET: 
                            ParserArrayAccess.parse(left, scanner, context, imports);
                    case PERIOD:
                            ParserDot.parse(left, scanner, context, imports);
                    case QUESTION_MARK:
                        ParserTernary.parse(left, scanner, context, imports);
                    case LEFT_PARENTHESES:
                        ParserCall.parse(left, scanner, context, imports);
                    case EQUALS, BANG, RIGHT_PARENTHESES, LEFT_BRACE, RIGHT_BRACE, 
                        RIGHT_BRACKET, SLASH, COMMA, COLON: 
                        null;
                }
            case TTKeyword(_): 
                null;
            case TTString(_): 
                null;
            case TTIdentifier(_): 
                null;
            case TTNumber(_): 
                null;
            case TTRhythm(_): 
                null;
        }
    }
}