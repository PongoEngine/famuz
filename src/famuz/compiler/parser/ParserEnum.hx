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
import famuz.compiler.expr.EnumDefinition;

class ParserEnum
{
    public static function parse(scanner :TokenScanner, context :Context) : Void
    {
        var enum_ = scanner.next(); //enum
        var identifier = scanner.next().getIdentifier(); //id (ex: RHYTHMS)
        scanner.next(); //left brace

        var fields :Array<Field> = [];
        var index = 0;
        var ref :Ref<EnumDefinition> = {ref:null};
        while (scanner.hasNext() && scanner.peek().isNotPunctuator(RIGHT_BRACE)) {
            var e = Parser.parse(new Precedence(0), scanner, context, false);
            switch e.def {
                case EConstant(constant): switch constant {
                    case CIdentifier(str): {
                        var param = new Expr(context, EEnumParameter(e, ref, index), e.pos);
                        fields.push(new Field(str, param));
                    }
                    case _: throw "invalid enum";
                }
                case _: throw "invalid enum";
            }
            index++;
        }
        var rightBrace = scanner.next(); //right brace

        var def = new EnumDefinition(identifier, fields, Position.union(enum_.pos, rightBrace.pos));
        ref.ref = def;
        context.defineEnumDef(def);
    }
}