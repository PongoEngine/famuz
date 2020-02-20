package famuz.compiler.evaluate;

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

import famuz.compiler.Expr.ExprStack;

class EvaluatePrint
{
    public static function evaluate(expr :Expr, context :Context, stack :ExprStack) : Void
    {
        Evaluate.evaluate(expr, stack);

        var printExpr = stack.pop();
        switch printExpr.def {
            case EFunction(_): {
                var str = "";
                for(i in printExpr.pos.min...printExpr.pos.max) {
                    str += printExpr.pos.content.charAt(i);
                }
                print(str, printExpr.pos);
            }
            case _: print(getValue(printExpr), printExpr.pos);
        }
        stack.push(printExpr);
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