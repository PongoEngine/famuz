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
import famuz.compiler.parser.Parser;
import famuz.compiler.expr.Expr;
import famuz.compiler.expr.ExprDef;

class ParserSwitch
{
    public static function parse(scanner :TokenScanner, context :Context) : Expr
    {
        var switch_ = scanner.next(); //switch
        var e = Parser.parse(new Precedence(0), scanner, context, false);
        scanner.next(); //{

        var cases :Array<Case> = [];
        var default_ :Expr = null;
        while(scanner.peek().isNotPunctuator(RIGHT_BRACE)) {
            switch scanner.peek().type {
                case TTKeyword(type): switch type {
                    case CASE: 
                        cases.push(parseCase(scanner, context));
                    case DEFAULT: {
                        default_ = parseDefault(scanner, context);
                    }
                    case _: throw "err";
                }
                case _: throw "err";
            }
        }
        var endBrace = scanner.next(); //}

        if(default_ == null) {
            throw "err";
        }
 
        return new Expr(
            ESwitch(e, cases, default_), 
			TMono({ref: None}),
            Position.union(switch_.pos, endBrace.pos)
        );
    }

    public static function parseCase(scanner :TokenScanner, context :Context) : Case
    {
        scanner.next(); //case
        var values :Array<Expr> = [];
        while(scanner.peek().isNotPunctuator(COLON)) {
            values.push(Parser.parse(new Precedence(0), scanner, context, false));
            if(scanner.peek().isPunctuator(COMMA)) {
                scanner.next();
            }
        }
        scanner.next(); //colon
        var expr = Parser.parse(new Precedence(0), scanner, context, false);

        return {expr:expr, values: values};
    }

    public static function parseDefault(scanner :TokenScanner, context :Context) : Expr
    {
        scanner.next(); //default
        scanner.next(); //:
        return Parser.parse(new Precedence(0), scanner, context, false);
    }
}