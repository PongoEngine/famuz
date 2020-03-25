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

import famuz.compiler.Token.PunctuatorType;
import famuz.compiler.Position;

/**
 * 
 */
class Error
{
    public static var FATAL_COMPILER_ERROR = "FATAL COMPILER ERROR";

    public static inline function create(e :ParserError) : Dynamic
    {
        printError(e);
        throw "COMPILER ERROR";
    }

    private static function printError(e :ParserError) : Void
    {
        switch e {
            case MissingPunctuator(t, pos):
                printErrorMsg('Missing punctuator: ${t}', pos);
            case MissingIdentifier(pos):
                printErrorMsg('Missing identifier', pos);
            case TooManyArgs(pos):
                printErrorMsg('Too many args', pos);
        }
    }

    private static function printErrorMsg(msg :String, pos :Position) : Void
    {
        trace('${pos.file}:${pos.line}: ${msg}\n');
    }
}

enum ParserError
{
    MissingPunctuator(t :PunctuatorType, pos :Position);
    MissingIdentifier(pos :Position);
    TooManyArgs(pos :Position);
}