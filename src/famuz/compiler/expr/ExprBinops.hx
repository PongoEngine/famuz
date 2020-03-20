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

package famuz.compiler.expr;

import famuz.compiler.expr.ExprDef;
import famuz.compiler.Context;
import famuz.compiler.theory.SteppedHit;

/**
 * 
 */
class ExprBinops
{
    /**
     * [Description]
     * @param left 
     * @param right 
     * @param context 
     * @return Expr
     */
    public static function add(left :Expr, right :Expr, context :IContext) : Expr
    {
        var a = Expr.evaluate(left, context);
        var b = Expr.evaluate(right, context);

        var constant = switch [a.def, b.def] {
            case [EConstant(constantA), EConstant(constantB)]: {
                switch [constantA, constantB] {
                    case [CNumber(valueA), CNumber(valueB)]:
                        EConstant(CNumber(valueA + valueB));
                    case _: 
                        throw "Only Supports Numbers";
                }
            }
            case _: 
                throw "Can only add constants";
        }

        return new Expr(
            constant, 
            Position.union(left.pos, right.pos)
        );
    }

    /**
     * [Description]
     * @param left 
     * @param right 
     * @param context 
     * @return Expr
     */
    public static function subtract(left :Expr, right :Expr, context :IContext) : Expr
    {
        var a = Expr.evaluate(left, context);
        var b = Expr.evaluate(right, context);

        var constant = switch [a.def, b.def] {
            case [EConstant(constantA), EConstant(constantB)]: {
                switch [constantA, constantB] {
                    case [CNumber(valueA), CNumber(valueB)]:
                        EConstant(CNumber(valueA - valueB));
                    case _: 
                        throw "Only Supports Numbers";
                }
            }
            case _: 
                throw "Can only add constants";
        }

        return new Expr(
            constant, 
            Position.union(left.pos, right.pos)
        );
    }

    /**
     * [Description]
     * @param left 
     * @param right 
     * @param context 
     * @return Expr
     */
    public static function wrap(left :Expr, right :Expr, context :IContext) : Expr
    {
        var a = Expr.evaluate(left, context);
        var b = Expr.evaluate(right, context);

        var constant = switch [a.def, b.def] {
            case [EConstant(constantA), EArrayDecl(values)]: {
                switch constantA {
                    case CRhythm(d, hits, duration):
                        var notes :Array<SteppedHit> = [];
                        for(i in 0...hits.length) {
                            var hit = hits[i];
                            var step = values[i%values.length].def.getNumber();
                            notes.push(new SteppedHit(step, hit));
                        }
                        EConstant(CMelody(notes, duration));
                    case _: 
                        throw "err";
                }
            }
            case [EArrayDecl(values), EConstant(constantA)]: {
                switch constantA {
                    case CRhythm(d, hits, duration):
                        var notes :Array<SteppedHit> = [];
                        for(i in 0...values.length) {
                            var step = values[i].def.getNumber();
                            var hit = hits[i%hits.length];
                            notes.push(new SteppedHit(step, hit));
                        }
                        EConstant(CMelody(notes, duration));
                    case _: 
                        throw "err";
                }
            }
            case _: 
                throw "err";
        }

        return new Expr(
            constant, 
            Position.union(left.pos, right.pos)
        );
    }

    /**
     * [Description]
     * @param left 
     * @param right 
     * @param context 
     * @return Bool
     */
    public static function equals(left :Expr, right :Expr, context :IContext) : Bool
    {
        var a = Expr.evaluate(left, context);
        var b = Expr.evaluate(right, context);

        return switch [a.def, b.def] {
            case [EConstant(constantA), EConstant(constantB)]:
                switch [constantA, constantB] {
                    case [CNumber(valueA), CNumber(valueB)]: valueA == valueB;
                    case [CBool(valueA), CBool(valueB)]: valueA == valueB;
                    case _: false;
                }
            case [EEnumParameter(e1, type1, index1), EEnumParameter(e2, type2, index2)]:
                return index1 == index2 && type1 == type2;
            case _: 
                false;
        }
    }
}