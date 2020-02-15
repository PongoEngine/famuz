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

class Position
{
    public var file :String;
    public var content :String;
    public var line :Int;
    public var min :Int;
    public var max :Int;

    public function new(line :Int, min :Int, max :Int, file :String, content :String) : Void
    {
        this.file = file;
        this.content = content;
        this.line = line;
        this.min = min;
        this.max = max;
    }

    public static function position_union(a :Position, b :Position, u :Position) : Void
    {
        u.file = a.file;
        u.content = a.content;
        u.line = (a.line < b.line) ? a.line : b.line;
        u.min = (a.min < b.min) ? a.min : b.min;
        u.max = (a.max > b.max) ? a.max : b.max;
    }
}