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

import famuz.compiler.lexer.LexerToken;
using famuz.util.StringUtil;

class Scanner
{
    public var content :String;
    public var filepath :String;
    public var curLine :Int;
    public var curIndex :Int;

    public function new(content :String, filepath :String) : Void
    {
        this.content = content;
        this.filepath = filepath;
        this.curLine = 0;
        this.curIndex = 0;
    }

    public function hasNext() : Bool
    {
        return this.curIndex < this.content.length;
    }

    public function next() : String
    {
        var c = this.content.charAt(this.curIndex++);
        if(c == '\n') {
            this.curLine += 1;
        }
        return c;
    }

    public function peek() : String
    {
        return this.content.charAt(this.curIndex);
    }

    public function peekDouble() : String
    {
        return this.content.charAt(this.curIndex + 1);
    }


    public function consumeWhitespace() : Void
    {
        while (this.hasNext() && this.peek().isWhitespace())
        {
            this.next();
        }
    }

    public function consumeComment() : Void
    {
        while (this.hasNext() && this.peek() != "\n")
        {
            this.next();
        }
    }

    public function consumeIdentifier() : String
    {
        var str = "";
        while(this.hasNext() && this.peek().isIdentifer()) {
            str += this.next();
        }
        return str;
    }

    public function consumeRhythm() : String
    {
        var str = "";
        while(this.hasNext() && (this.peek().isRhythm() || this.peek() == L_SPACE)) {
            var c = this.next();
            if(c != L_SPACE) {
                str += c;
            }
        }
        return str;
    }

    public function consumeSteps() : String
    {
        var str = "";
        while(this.hasNext() && (this.peek().isDigit() || this.peek() == L_SPACE)) {
            var c = this.next();
            if(c != L_SPACE) {
                str += c;
            }
        }
        return str;
    }

    public function consumeNumber() : String
    {
        var str = "";
        while(this.hasNext() && this.peek().isDigit()) {
            str += this.next();
        }
        return str;
    }
}