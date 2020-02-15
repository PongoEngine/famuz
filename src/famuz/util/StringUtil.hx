package famuz.util;

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

class StringUtil
{
    public static function isWhitespace(ch :String) : Bool
    {
        return ch == L_SPACE || ch == L_LINE || ch == L_TAB;
    }

    public static function isIdentifer(ch :String) : Bool
    {
        return ch != L_ADD && ch != L_FORWARD_SLASH &&
            ch != L_TAB && ch != L_SPACE && ch != L_LINE &&
            ch != L_LEFT_PARAM && ch != L_RIGHT_PARAM && ch != L_COMMA;
    }

    public static function isRhythm(ch :String) : Bool
    {
        return ch == L_HIT || ch == L_DURATION || ch == L_REST;
    }

    public static function isDigit(ch :String) : Bool
    {
        var code = ch.charCodeAt(0);
        return code > 47 && code < 58;
    }

    public static function isEmpty(str :String) : Bool
    {
        return str == null || str.length == 0;
    }
}