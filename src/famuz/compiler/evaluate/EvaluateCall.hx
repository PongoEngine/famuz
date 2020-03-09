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

import famuz.compiler.expr.exprDef.ExprDef.Parameter;
import famuz.compiler.expr.ExprStack;
import famuz.compiler.expr.Expr;

class EvaluateCall
{
    public static function evaluate(identifier :String, args :Array<Expr>, pos :Position, context :Context, stack :ExprStack) : Void
    {
        var func = context.getExpr(identifier);

        switch func.def {
            case EFunction(_, params, body): {
                if(args.length == params.length) {
                    wrap(body.context, createEnvWithArgs(args, params, context));
                    Evaluate.evaluate(body, stack);
                    unwrap(body.context);
                }
            }
            case _: throw "Needs to be function";
        }
    }

    private static function createEnvWithArgs(args: Array<Expr>, params :Array<Parameter>, context :Context) : Context
    {
        var context = context.createChild();
        for(i in 0...args.length) {
            context.addExpr(params[i].name, args[i]);
        }
        return context;
    }

    private static function wrap(ctx :Context, newContext :Context) {
        newContext.parent = ctx.parent;
        ctx.parent = newContext;
    }

    private static function unwrap(context :Context) {
        context.parent = context.parent.parent;
    }
}