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

package famuz.compiler;

import famuz.compiler.Position;
import famuz.compiler.theory.Key;
import famuz.compiler.theory.Scale;

/**
 * 
 */
class Token
{
    public var type :TokenType;
    public var pos :Position;

    public function new(type :TokenType, pos :Position) : Void
    {
        this.type = type;
        this.pos = pos;
    }

    public function isPunctuator(punctuator: PunctuatorType) : Bool
    {
        return switch this.type {
            case TTPunctuator(type): type == punctuator;
            case _: false;
        }
    }

    public inline function isNotPunctuator(punctuator: PunctuatorType) : Bool
    {
        return !isPunctuator(punctuator);
    }

    public function isIdentifier() : Bool
    {
        return switch this.type {
            case TTIdentifier(str): true;
            case _: false;
        }
    }

    public function getIdentifier() : String
    {
        return switch this.type {
            case TTIdentifier(str): str;
            case _: throw "Error";
        }
    }
}

class TokenScanner
{
    public var tokens :Array<Token>;
    public var curIndex :Int;

    public function new(tokens :Array<Token>) : Void
    {
        this.tokens = tokens;
        this.curIndex = 0;
    }

    public function hasNext() : Bool
    {
        return this.curIndex < this.tokens.length;
    }

    public function next() : Token
    {
        return this.tokens[this.curIndex++];
    }

    public function peek() : Token
    {
        return this.tokens[this.curIndex];
    }

    public function lastPosition() : Position
    {
        var index = this.curIndex > 0
            ? this.curIndex - 1
            : this.curIndex;
        return this.tokens[index].pos;
    }
}

enum TokenType 
{
    TTPunctuator(type :PunctuatorType);
    TTKeyword(type :KeywordType);
    TTIdentifier(str :String);
    TTScale(scale :Scale);
    TTKey(key :Key);
    TTNumber(num :Int);
    TTRhythm(duration: Int, str :String);
}

enum PunctuatorType 
{
	ADD;
	MINUS;
	BANG;
	EQUALS;
	LEFT_PARENTHESES;
	RIGHT_PARENTHESES;
	LEFT_BRACE;
	RIGHT_BRACE;
	LEFT_BRACKET;
	RIGHT_BRACKET;
	SHIFT_LEFT;
	SHIFT_RIGHT;
	WRAP;
	SLASH;
	COMMA;
	PERIOD;
	QUESTION_MARK;
	COLON;
}

enum KeywordType 
{
	FUNC;
	LET;
	SWITCH;
	CASE;
	DEFAULT;
	PRINT;
	IF;
	TRUE;
    FALSE;
    ENUM;
}