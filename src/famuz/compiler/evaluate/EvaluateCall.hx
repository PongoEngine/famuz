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

import famuz.compiler.Expr.Parameter;

class EvaluateCall
{
    public static function evaluate(identifier :String, args :Array<Expr>, environment :Environment, stack :Stack) : Void
    {
        var func = environment.getExpr(identifier);
        switch func.def {
            case EFunction(_, params, body): {
                if(args.length == params.length && body.ret == func.ret) {
                    wrap(body.env, createEnvWithArgs(args, params));
                    Evaluate.evaluate(body, stack);
                    unwrap(body.env);
                }
            }
            case _: throw "Needs to be function";
        }
    }

    private static function createEnvWithArgs(args: Array<Expr>, params :Array<Parameter>) : Environment
    {
        var env = new Environment();
        for(i in 0...args.length) {
            env.addExpr(params[i].name, args[i]);
        }
        return env;
    }

    private static function wrap(env :Environment, newParent :Environment) {
        newParent.parent = env.parent;
        env.parent = newParent;
    }

    private static function unwrap(env :Environment) {
        env.parent = env.parent.parent;
    }
}