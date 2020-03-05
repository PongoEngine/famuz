package famuz.compiler;

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

import famuz.compiler.Position;

class Token
{
    public var type :TokenType;
    public var lexeme :String;
    public var pos :Position;

    public function new(lexeme :String, type :TokenType, pos :Position) : Void
    {
        this.lexeme = lexeme;
        this.type = type;
        this.pos = pos;
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
}

enum TokenType {
	IDENTIFIER;
	COLON;
	SCALE;
	FUNC;
	PRINT;
	KEY;
	WHITESPACE;
	NUMBER;
	RHYTHM;
	COMMENT;
	ADD;
	ASSIGNMENT;
	LEFT_PARENTHESES;
	RIGHT_PARENTHESES;
	LEFT_BRACE;
	RIGHT_BRACE;
	LEFT_BRACKET;
	RIGHT_BRACKET;
	COMMA;
	SHIFT_LEFT;
	SHIFT_RIGHT;
	SLASH;
}