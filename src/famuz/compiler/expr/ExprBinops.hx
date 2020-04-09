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

import haxe.macro.Expr.ExprDef;
import famuz.compiler.Context;
using famuz.compiler.expr.Expr;
using famuz.compiler.expr.ExprDef;
using StringTools;

/**
 * 
 */
class ExprBinops
{

    public static function add(left :Expr, right :Expr, context :IContext) : Expr
    {
        var a = left.evaluate(context);
        var b = right.evaluate(context);

        var def = switch [a.def, b.def] {
            case [EConstant(constantA), EConstant(constantB)]: {
                switch [constantA, constantB] {
                    case [CNumber(valueA), CNumber(valueB)]:
                        EConstant(CNumber(valueA + valueB));
                    case [CString(valueA), CString(valueB)]:
                        EConstant(CString(valueA + valueB));
                    case [CBool(valueA), CBool(valueB)]:
                        throw "cannot add booleans";
                    case _: 
                        throw "err";
                }
            }
            case [EObjectDecl(fields1), EObjectDecl(fields2)]:
                var fields = new Map<String, Expr>();
                for(key in fields1.keys()) {
                    fields.set(key, add(fields1.get(key), fields2.get(key), context));
                }
                EObjectDecl(fields);
            case [EArrayDecl(values1), EArrayDecl(values2)]:
                EArrayDecl(values1.concat(values2));
            case _:
                throw "err";
        }

        return new Expr(
            def, 
			TMono({ref: None}),
            Position.union(left.pos, right.pos)
        );
    }

    public static function subtract(left :Expr, right :Expr, context :IContext) : Expr
    {
        var a = left.evaluate(context);
        var b = right.evaluate(context);

        var def = switch [a.def, b.def] {
            case [EConstant(constantA), EConstant(constantB)]: {
                switch [constantA, constantB] {
                    case [CNumber(valueA), CNumber(valueB)]:
                        EConstant(CNumber(valueA - valueB));
                    case [CString(_), CString(_)]:
                        throw "cannot subtract strings";
                    case [CBool(_), CBool(_)]:
                        throw "cannot subtract booleans";
                    case _: 
                        throw "err";
                }
            }
            case [EObjectDecl(fields1), EObjectDecl(fields2)]:
                var fields = new Map<String, Expr>();
                for(key in fields1.keys()) {
                    fields.set(key, subtract(fields1.get(key), fields2.get(key), context));
                }
                EObjectDecl(fields);
            case _: 
                throw "err";
        }

        return new Expr(
            def, 
            TMono({ref: None}),
            Position.union(left.pos, right.pos)
        );
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