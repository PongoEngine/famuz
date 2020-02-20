package famuz.compiler.parser;

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

import famuz.compiler.Expr.Hit;
import famuz.compiler.Token;
import famuz.util.Assert;

class ParserRhythm
{
    public static function parse(scanner :TokenScanner, context :Context) : Expr
    {
        var token = scanner.next();
        var rhythmScanner = new Scanner(token.lexeme, token.pos.file);
        var hits :Array<Hit> = [];

        while (rhythmScanner.hasNext()) {
            if (rhythmScanner.peek() == 'x') {
                var start = rhythmScanner.curIndex;
                rhythmScanner.next(); //consume "x"
                eatDuration(rhythmScanner);
                var duration = rhythmScanner.curIndex - start;
                hits.push({start:start, duration: duration});
            }
            else if (rhythmScanner.peek() == '-') {
                eatRest(rhythmScanner);
            }
            else {
                Assert.that(false, "INVALID RHYTHM");
                rhythmScanner.next();
            }
        }
        var duration = rhythmScanner.content.length;

        return {
            context: context,
            def: EConstant(CRhythm(hits, duration)),
            pos: token.pos,
            ret: TRhythm
        };
    }

    private static function eatDuration(scanner :Scanner) : Void
    {
        while (scanner.hasNext() && scanner.peek() == '~')
        {
            scanner.next();
        }
    }

    private static function eatRest(scanner :Scanner) : Void
    {
        while (scanner.hasNext() && scanner.peek() == '-')
        {
            scanner.next();
        }
    }
}