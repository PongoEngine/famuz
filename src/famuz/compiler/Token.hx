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

    public inline function isApplicable() : Bool
    {
        return switch this.type {
            case TTPunctuator(type): switch type {
                case ADD: false;
                case MINUS: true;
                case BANG: true;
                case EQUALS: false;
                case LEFT_PARENTHESES: true;
                case RIGHT_PARENTHESES: false;
                case LEFT_BRACE: true;
                case RIGHT_BRACE: false;
                case LEFT_BRACKET: true;
                case RIGHT_BRACKET: false;
                case SHIFT_LEFT: false;
                case SHIFT_RIGHT: false;
                case SLASH: false;
                case COMMA: false;
                case PERIOD: false;
                case QUESTION_MARK: false;
                case COLON: false;
            }
            case TTKeyword(type): switch type {
                case FUNC: false;
                case LET: false;
                case SWITCH: true;
                case CASE: false;
                case DEFAULT: false;
                case PRINT: true;
                case IF: true;
                case TRUE: true;
                case FALSE: true;
                case ENUM: false;
            }
            case TTIdentifier(str): true;
            case TTScale(scale): true;
            case TTKey(key): true;
            case TTNumber(num): true;
            case TTRhythm(str): true;
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
    TTRhythm(str :String);
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