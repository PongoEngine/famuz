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

/**
 * 
 */
class ExprBinops
{
    public static function add(this_ :Expr, expr :Expr) : Expr
    {
        var a = this_.evaluate();
        var b = expr.evaluate();

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
            expr.context, 
            constant, 
            Position.union(this_.pos, expr.pos)
        );
    }

    public static function subtract(this_ :Expr, expr :Expr) : Expr
    {
        var a = this_.evaluate();
        var b = expr.evaluate();

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
            expr.context, 
            constant, 
            Position.union(this_.pos, expr.pos)
        );
    }

    public static function equals(this_ :Expr, expr :Expr) : Bool
    {
        var a = this_.evaluate();
        var b = expr.evaluate();

        return switch [a.def, b.def] {
            case [EConstant(constantA), EConstant(constantB)]:
                switch [constantA, constantB] {
                    case [CNumber(valueA), CNumber(valueB)]: valueA == valueB;
                    case [CBool(valueA), CBool(valueB)]: valueA == valueB;
                    case _: false;
                }
            case _: false;
        }
    }
}