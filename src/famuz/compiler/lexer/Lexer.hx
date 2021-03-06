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

import famuz.compiler.lexer.LexerToken;
import famuz.compiler.Token;
import famuz.compiler.Scanner;
using famuz.util.FStringTools;

class Lexer
{
    public static function lex(filePath :String, content :String) : Array<Token>
    {
        var scanner = new Scanner(content, filePath);
        var tokens = [];
        while (scanner.hasNext())
        {
            var lexerToken :LexerToken = scanner.peek();
            switch (lexerToken)
            {
                case AT:
                    scanner.peekDouble().isNumber()
                        ? tokens.push(createTokenRhythm(scanner))
                        : throw "err";
                case EQUALS:
                    scanner.peekDouble() == '='
                        ? tokens.push(createToken(EQUALITY, 2, scanner))
                        : tokens.push(createToken(ASSIGNMENT, 1, scanner));
                case LEFT_PARENTHESES:
                    tokens.push(createToken(LEFT_PARENTHESES, 1, scanner));
                case RIGHT_PARENTHESES:
                    tokens.push(createToken(RIGHT_PARENTHESES, 1, scanner));
                case LEFT_BRACE:
                    tokens.push(createToken(LEFT_BRACE, 1, scanner));
                case RIGHT_BRACE:
                    tokens.push(createToken(RIGHT_BRACE, 1, scanner));
                case LEFT_BRACKET:
                    tokens.push(createToken(LEFT_BRACKET, 1, scanner));
                case RIGHT_BRACKET:
                    tokens.push(createToken(RIGHT_BRACKET, 1, scanner));
                case COMMA:
                    tokens.push(createToken(COMMA, 1, scanner));
                case PERIOD:
                    tokens.push(createToken(PERIOD, 1, scanner));
                case QUESTION_MARK:
                    tokens.push(createToken(QUESTION_MARK, 1, scanner));
                case COLON:
                    tokens.push(createToken(COLON, 1, scanner));
                case DOLLAR:
                    tokens.push(createToken(DOLLAR, 1, scanner));
                case ADD:
                    tokens.push(createToken(ADD, 1, scanner));
                case MULTIPLY:
                    tokens.push(createToken(MULTIPLY, 1, scanner));
                case MINUS:
                    tokens.push(createToken(MINUS, 1, scanner));
                case BANG:
                    tokens.push(createToken(BANG, 1, scanner));
                case BACKWARD_SLASH: {
                    throw "err";
                }
                case FORWARD_SLASH:
                    scanner.peekDouble() == '/'
                        ? scanner.consumeComment()
                        : tokens.push(createToken(DIVIDE, 1, scanner));
                case LT:
                    tokens.push(createToken(LESS_THAN, 1, scanner));
                case GT:
                    tokens.push(createToken(GREATER_THAN, 1, scanner));
                case DURATION:
                    scanner.next();
                case QUOTES:
                    tokens.push(createTokenString(scanner));
                case TAB, SPACE, LINE:
                    scanner.consumeWhitespace();
                case ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE:
                    tokens.push(createTokenNumber(scanner));
                default:
                    tokens.push(createTokenIdentifier(scanner));
            }
        }
        return tokens;
    }

    public static function createToken(type :PunctuatorType, length :Int, scanner :Scanner) : Token
    {
        var line = scanner.curLine;
        var min = scanner.curIndex;
        for(i in 0...length) {
            scanner.next();
        }
        var max = scanner.curIndex;
        var pos = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(TTPunctuator(type), pos);
    }

    public static function createTokenIdentifier(scanner :Scanner) : Token
    {
        var line = scanner.curLine;
        var min = scanner.curIndex;
        var lexeme = scanner.consumeIdentifier();
        var max = scanner.curIndex;
        var position = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(wordType(lexeme), position);
    }

    public static function createTokenString(scanner :Scanner) : Token
    {
        var line = scanner.curLine;
        var min = scanner.curIndex;
        var lexeme = scanner.consumeString();
        var max = scanner.curIndex;
        var position = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(TTString(lexeme), position);
    }

    public static function createTokenRhythm(scanner :Scanner) : Token
    {
        var line = scanner.curLine;
        var min = scanner.curIndex;
        scanner.next(); //consume '@'
        var num = Std.parseInt(scanner.consumeNumber());
        scanner.next(); //consume '/'
        var den = Std.parseInt(scanner.consumeNumber());
        var lexeme = scanner.consumeRhythm();
        var max = scanner.curIndex;
        var position = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(TTRhythm(num, den, lexeme), position);
    }

    public static function createTokenNumber(scanner :Scanner) : Token
    {
        var line = scanner.curLine;
        var min = scanner.curIndex;
        var lexeme = scanner.consumeNumber();
        var num = Std.parseInt(lexeme);
        var max = scanner.curIndex;
        var position = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(TTNumber(num), position);
    }

    public static function wordType(str :String) : TokenType
    {
        return switch str {
            //keyword
            case "import": TTKeyword(IMPORT);
            case "let": TTKeyword(LET);
            case "func": TTKeyword(FUNC);
            case "switch": TTKeyword(SWITCH);
            case "case": TTKeyword(CASE);
            case "default": TTKeyword(DEFAULT);
            case "print": TTKeyword(PRINT);
            case "if": TTKeyword(IF);
            case "true": TTKeyword(TRUE);
            case "false": TTKeyword(FALSE);
            //key
            case "C": TTNumber(24);
            case "C#": TTNumber(25);
            case "Db": TTNumber(25);
            case "D": TTNumber(26);
            case "D#": TTNumber(27);
            case "Eb": TTNumber(27);
            case "E": TTNumber(28);
            case "F": TTNumber(29);
            case "F#": TTNumber(30);
            case "Gb": TTNumber(30);
            case "G": TTNumber(31);
            case "G#": TTNumber(32);
            case "Ab": TTNumber(32);
            case "A": TTNumber(21);
            case "A#": TTNumber(22);
            case "Bb": TTNumber(22);
            case "B": TTNumber(23);
            default: TTIdentifier(str);
        }
    }
}