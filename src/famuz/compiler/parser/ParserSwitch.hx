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
import famuz.util.Assert;
import famuz.compiler.parser.Parser;
import famuz.compiler.expr.Expr;
using famuz.compiler.Type;

class ParserSwitch
{
    public static function parse(scanner :TokenScanner, context :Context) : Expr
    {
        var switch_ = scanner.next(); //switch
        var e = Parser.parse(new Precedence(0), scanner, context, false);
        scanner.next(); //{

        scanner.next(); //case
        while(scanner.peek().isNotPunctuator(COLON)) {
            var value = Parser.parse(new Precedence(0), scanner, context, false);
            if(scanner.peek().isPunctuator(COMMA)) {
                scanner.next();
            }
        }
        scanner.next(); //colon
        var expr = Parser.parse(new Precedence(0), scanner, context, false);
        trace(expr + "\n");


        // var ethen = Parser.parse(new Precedence(0), scanner, context, false);
        // scanner.next(); //else
        // var eelse = Parser.parse(new Precedence(0), scanner, context, false);

        // return new Expr(
        //     context, 
        //     EIf(econd, ethen, eelse), 
        //     Position.union(if_.pos, eelse.pos), 
        //     TMonomorph
        // );

        throw "switch";
    }
}