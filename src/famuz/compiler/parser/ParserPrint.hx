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

import famuz.compiler.Token;
import famuz.util.Assert;
import famuz.compiler.parser.Parser;
import famuz.compiler.evaluate.Evaluate;

class ParserPrint
{
    public static function parse(scanner :TokenScanner, context :Context) : Expr
    {
        var startPos = scanner.next().pos; //consume "print"
        scanner.next(); //consume "("
        var stack = new Stack();
        var expr = Parser.parse(0, scanner, context);
        Evaluate.evaluate(expr, stack);
        var endPos = scanner.next().pos; //consume ")"

        if(stack.length > 0) {
            var poppedExpr = stack.pop();
            switch poppedExpr.def {
                case EFunction(_): {
                    var str = "";
                    for(i in poppedExpr.pos.min...poppedExpr.pos.max) {
                        str += poppedExpr.pos.content.charAt(i);
                    }
                    print(str, poppedExpr.pos);
                }
                case _: print(getValue(poppedExpr), Position.union(startPos, endPos));
            }
        }

        Assert.that(stack.length == 0, "Stack is not empty!");

        return expr;
    }

    private static function print(value :Dynamic, pos :Position) : Void
    {
        trace('${pos.file}:${pos.line}: ${value}\n');
    }

    private static function getValue(expr :Expr) : Dynamic
    {
        return switch expr.def {
            case EConstant(constant): switch constant {
                case CIdentifier(str):
                    str;
                case CNumber(value):
                    value;
                case CRhythm(hits, duration):
                    '${hits.map(h -> '(${h.start},${h.duration})')}, ${duration}';
                case CMelody(notes):
                    notes.map(n -> '${n.step}-(${n.hit.start},${n.hit.duration})');
                case CHarmony(melodies):
                    melodies;
                case CSteps(steps):
                    steps;
                case CScale(scale):
                    scale;
                case CKey(key):
                    key;
                case CScaledKey(scale, key):
                    {scale: scale, key: key};
                case CMusic:
                    "Music";
            }
            case _: throw "invalid getValue";
        }
    }
}