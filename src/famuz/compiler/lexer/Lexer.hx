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
                case L_HIT:
                {
                    var db = scanner.peekDouble();
                    var token = (db == L_REST || db == L_DURATION || db == L_SPACE)
                        ? createTokenRhythm(scanner)
                        : createTokenIdentifier(scanner);
                    tokens.push(token);
                }
                case L_ASSIGNMENT:
                    tokens.push(createToken(ASSIGNMENT, scanner));
                case L_COLON:
                    tokens.push(createToken(COLON, scanner));
                case L_LEFT_PARAM:
                    tokens.push(createToken(LEFT_PARAM, scanner));
                case L_RIGHT_PARAM:
                    tokens.push(createToken(RIGHT_PARAM, scanner));
                case L_LEFT_BRACKET:
                    tokens.push(createToken(LEFT_BRACKET, scanner));
                case L_RIGHT_BRACKET:
                    tokens.push(createToken(RIGHT_BRACKET, scanner));
                case L_COMMA:
                    tokens.push(createToken(COMMA, scanner));
                case L_ADD:
                    tokens.push(createToken(ADD, scanner));
                case L_CARROT:
                    tokens.push(createTokenSteps(scanner));
                case L_FORWARD_SLASH:
                    scanner.peekDouble() == '/'
                        ? scanner.consumeComment()
                        : scanner.next();
                case L_LT:
                    scanner.peekDouble() == '<'
                        ? tokens.push(createTokenShiftLeft(scanner))
                        : scanner.next();
                case L_GT:
                    scanner.peekDouble() == '>'
                        ? tokens.push(createTokenShiftRight(scanner))
                        : scanner.next();
                case L_DURATION, L_REST:
                    scanner.next();
                case L_TAB, L_SPACE, L_LINE:
                    scanner.consumeWhitespace();
                case L_ZERO, L_ONE, L_TWO, L_THREE, L_FOUR, L_FIVE, L_SIX, L_SEVEN, L_EIGHT, L_NINE:
                    tokens.push(createTokenNumber(scanner));
                default:
                    tokens.push(createTokenIdentifier(scanner));
            }
        }
        return tokens;
    }

    public static function createToken(type :TokenType, scanner :Scanner) : Token
    {
        var line = scanner.curLine;
        var min = scanner.curIndex;
        var lexeme = scanner.next();
        var max = scanner.curIndex;
        var pos = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(lexeme, type, pos);
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
        var line = scanner.curLine;
        var min = scanner.curIndex;
        var lexeme = scanner.consumeRhythm();
        var max = scanner.curIndex;
        var position = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(lexeme, RHYTHM, position);
    }

    public static function createTokenSteps(scanner :Scanner) : Token
    {
        scanner.next(); //consume ^
        var line = scanner.curLine;
        var min = scanner.curIndex;
        var lexeme = scanner.consumeSteps();
        var max = scanner.curIndex;
        var position = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(lexeme, STEPS, position);
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
        return new Token(lexeme, SHIFT_LEFT, position);
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
        return new Token(lexeme, SHIFT_RIGHT, position);
    }

    public static function createTokenNumber(scanner :Scanner) : Token
    {
        var line = scanner.curLine;
        var min = scanner.curIndex;
        var lexeme = scanner.consumeNumber();
        var max = scanner.curIndex;
        var position = new Position(line, min, max, scanner.filepath, scanner.content);
        return new Token(lexeme, NUMBER, position);
    }

    public static function wordType(str :String) : TokenType
    {
        if (str.isKey()) {
            return KEY;
        }
        else if (str.isScale()) {
            return SCALE;
        }
        else if (str.isFunc()) {
            return FUNC;
        }
        else if (str.isPrint()) {
            return PRINT;
        }
        else {
            return IDENTIFIER;
        }
    }

 }