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

package famuz.compiler.evaluate;

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
                print(str, expr.pos);
            }
            case _: print(getValue(printExpr), expr.pos);
        }
        stack.push(printExpr);
    }

    private static function print(value :Dynamic, pos :Position) : Void
    {
        trace('${pos.file}:${pos.line}: ${value}\n');
    }

    private static function getValue(expr :Expr) : String
    {
        return switch expr.def {
            case EConstant(constant): switch constant {
                case CIdentifier(str):
                    str;
                case CNumber(value):
                    value + "";
                case CRhythm(hits, duration):
                    '${hits.map(h -> '(${h.start},${h.duration})')}, ${duration}';
                case CMelody(notes, duration):
                    notes.map(n -> '${n.step}-(${n.hit.start},${n.hit.duration}), ${duration}') + "";
                case CHarmony(melodies):
                    melodies + "";
                case CSteps(steps):
                    steps + "";
                case CScale(scale):
                    scale.toString();
                case CKey(key):
                    key.toString();
                case CScaledKey(scale, key):
                    {scale: scale.toString(), key: key.toString()} + "";
                case CMusic(music):
                    music.map(n -> '${n.note}-(${n.hit.start},${n.hit.duration})') + "";
            }
            case EArrayDecl(values): 
                values.map(getValue) + "";
            case EObjectDecl(fields): {
                var obj = "{";
                for(i in 0...fields.length) {
                    var field = fields[i];
                    obj += '${field.field}: ${getValue(field.expr)}';
                    if(i != fields.length -1) {
                        obj += ", ";
                    }
                }
                obj + "}";
            }
            case _: throw "invalid getValue";
        }
    }
}