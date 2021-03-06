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

package famuz.compiler.parser;

import famuz.compiler.Token;
import famuz.compiler.Context;
import famuz.compiler.expr.Expr;
import famuz.compiler.expr.Expr.ExprTools;
using famuz.compiler.Scanner.ScannerTools;

class ParserRhythm
{
    public static function parse(scanner :TokenScanner, context :IContext, imports :Map<String, Context>, numerator :Int, denominator :Int, rhythm :String) : Expr
    {
        var token = scanner.next();
        var rhythmScanner = new Scanner(rhythm, token.pos.file);
        var hits :Array<Expr> = [];
        var ratio = Math.floor((numerator/denominator) * 1000);

        while (rhythmScanner.hasNext()) {
            if (rhythmScanner.peek().isDigit()) {
                var start = pos(rhythmScanner.curIndex, ratio);
                var velocity = Std.parseInt(rhythmScanner.next());
                eatDuration(rhythmScanner);
                var duration = pos(rhythmScanner.curIndex, ratio) - start;

                hits.push(ExprTools.createEObjectDecl([
                    "velocity" => ExprTools.createCNumber(velocity, token.pos),
                    "duration" => ExprTools.createCNumber(duration, token.pos)
                ], token.pos));
            }
            else if (rhythmScanner.peek() == '-') {
                var start = pos(rhythmScanner.curIndex, ratio);
                eatRest(rhythmScanner);
                var duration = pos(rhythmScanner.curIndex, ratio) - start;
                hits.push(ExprTools.createEObjectDecl([
                    "velocity" => ExprTools.createCNumber(-1, token.pos),
                    "duration" => ExprTools.createCNumber(duration, token.pos)
                ], token.pos));
            }
            else {
                throw "err";
                rhythmScanner.next();
            }
        }

        return ExprTools.createEArrayDecl(hits, token.pos);
    }

    private static function pos(curIndex :Int, ratio :Int) : Int
    {
        return curIndex * ratio;
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