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

import famuz.compiler.Context;
using famuz.compiler.expr.Expr;
using famuz.compiler.expr.ExprDef;

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
        var a = left.evaluate(context);
        var b = right.evaluate(context);

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
			TMono({ref: None}),
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
        var a = left.evaluate(context);
        var b = right.evaluate(context);

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
            TMono({ref: None}),
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
        var a = left.evaluate(context);
        var b = right.evaluate(context);
        return switch [a.def, b.def] {
            case [EArrayDecl(values), EObjectDecl(fields)]: throw "err";
            case [EObjectDecl(fields), EArrayDecl(values)]: throw "err";
            case _: throw "err";
        }
    }

    public static function equals(left :Expr, right :Expr, context :IContext) : Expr
    {
        var a = left.evaluate(context);
        var b = right.evaluate(context);

        var v = switch [a.def, b.def] {
            case [EConstant(constantA), EConstant(constantB)]:
                switch [constantA, constantB] {
                    case [CNumber(valueA), CNumber(valueB)]: valueA == valueB;
                    case [CBool(valueA), CBool(valueB)]: valueA == valueB;
                    case [CString(valueA), CString(valueB)]: valueA == valueB;
                    case _: false;
                }
            case _: 
                false;
        }

        return new Expr(EConstant(CBool(v)), TMono({ref: None}), Position.union(a.pos, b.pos));
    }

    public static function greaterThan(left :Expr, right :Expr, context :IContext) : Expr
    {
        var a = left.evaluate(context);
        var b = right.evaluate(context);

        var v = switch [a.def, b.def] {
            case [EConstant(constantA), EConstant(constantB)]:
                switch [constantA, constantB] {
                    case [CNumber(valueA), CNumber(valueB)]: valueA > valueB;
                    case _: false;
                }
            case _: 
                false;
        }

        return new Expr(EConstant(CBool(v)), TMono({ref: None}), Position.union(a.pos, b.pos));
    }
}