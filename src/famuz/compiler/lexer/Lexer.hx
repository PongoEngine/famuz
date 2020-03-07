package famuz.compiler.lexer;

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

import famuz.compiler.lexer.LexerToken;
import famuz.compiler.Token;
import famuz.compiler.Scanner;
using famuz.compiler.Reserved;

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
                case ASSIGNMENT:
                    tokens.push(createToken(ASSIGNMENT, scanner));
                case COLON:
                    tokens.push(createToken(COLON, scanner));
                case LEFT_PARENTHESES:
                    tokens.push(createToken(LEFT_PARENTHESES, scanner));
                case RIGHT_PARENTHESES:
                    tokens.push(createToken(RIGHT_PARENTHESES, scanner));
                case LEFT_BRACE:
                    tokens.push(createToken(LEFT_BRACE, scanner));
                case RIGHT_BRACE:
                    tokens.push(createToken(RIGHT_BRACE, scanner));
                case LEFT_BRACKET:
                    tokens.push(createToken(LEFT_BRACKET, scanner));
                case RIGHT_BRACKET:
                    tokens.push(createToken(RIGHT_BRACKET, scanner));
                case COMMA:
                    tokens.push(createToken(COMMA, scanner));
                case ADD:
                    tokens.push(createToken(ADD, scanner));
                case BACKWARD_SLASH: {
                    tokens.push(createTokenRhythm(scanner));
                }
                case FORWARD_SLASH:
                    scanner.peekDouble() == '/'
                        ? scanner.consumeComment()
                        : scanner.next();
                case LT:
                    scanner.peekDouble() == '<'
                        ? tokens.push(createTokenShiftLeft(scanner))
                        : scanner.next();
                case GT:
                    scanner.peekDouble() == '>'
                        ? tokens.push(createTokenShiftRight(scanner))
                        : scanner.next();
                case DURATION, REST:
                    scanner.next();
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

    public static function createToken(type :PunctuatorType, scanner :Scanner) : Token
    {
        var line = scanner.curLine;
        var min = scanner.curIndex;
        var lexeme = scanner.next();
        var max = scanner.curIndex;
        var pos = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(lexeme, TTPunctuator(type), pos);
    }

    public static function createTokenIdentifier(scanner :Scanner) : Token
    {
        var line = scanner.curLine;
        var min = scanner.curIndex;
        var lexeme = scanner.consumeIdentifier();
        var max = scanner.curIndex;
        var position = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(lexeme, wordType(lexeme), position);
    }

    public static function createTokenRhythm(scanner :Scanner) : Token
    {
        scanner.next(); //consume \
        var line = scanner.curLine;
        var min = scanner.curIndex;
        var lexeme = scanner.consumeRhythm();
        var max = scanner.curIndex;
        var position = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(lexeme, TTRhythm(lexeme), position);
    }

    public static function createTokenShiftLeft(scanner :Scanner) : Token
    {
        var line = scanner.curLine;
        var min = scanner.curIndex;
        var lexeme = "";
        lexeme += scanner.next(); //'<'
        lexeme += scanner.next(); //'<'
        var max = scanner.curIndex;
        var position = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(lexeme, TTPunctuator(SHIFT_LEFT), position);
    }

    public static function createTokenShiftRight(scanner :Scanner) : Token
    {
        var line = scanner.curLine;
        var min = scanner.curIndex;
        var lexeme = "";
        lexeme += scanner.next(); //'>'
        lexeme += scanner.next(); //'>'
        var max = scanner.curIndex;
        var position = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(lexeme, TTPunctuator(SHIFT_RIGHT), position);
    }

    public static function createTokenNumber(scanner :Scanner) : Token
    {
        var line = scanner.curLine;
        var min = scanner.curIndex;
        var lexeme = scanner.consumeNumber();
        var max = scanner.curIndex;
        var position = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(lexeme, TTNumber(lexeme), position);
    }

    public static function wordType(str :String) : TokenType
    {
        if (str.isKey()) {
            return TTKey(str);
        }
        else if (str.isScale()) {
            return TTScale(str);
        }
        else if (str.isFunc()) {
            return TTKeyword(FUNC);
        }
        else if (str.isPrint()) {
            return TTKeyword(PRINT);
        }
        else {
            return TTIdentifier(str);
        }
    }

 }