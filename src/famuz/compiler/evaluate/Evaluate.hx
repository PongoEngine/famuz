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

import famuz.compiler.evaluate.EvaluateBinop;

class Evaluate
{
    public static function evaluate(e :Expr, stack :Stack) : Void
    {
        switch (e.def) {
            case EConstant(constant): {
                switch constant {
                    case CIdentifier(str): {
                        evaluate(e.env.getExpr(str), stack);
                    }
                    case _: stack.push(e);
                }
            }
            case EVar(identifier, expr):
                evaluate(expr, stack);
            case ECall(identifier, args): 
                EvaluateCall.evaluate(identifier, args, e.env, stack);
            case EBlock(exprs): if(exprs.length > 0) {
                trace("we blocking!\n");
                evaluate(exprs[exprs.length-1], stack);
            }
            case EBinop(type, e1, e2): 
                EvaluateBinop.evaluate(type, e1, e2, e.env, stack);
            case EParentheses(expr): 
                stack.push(expr);
            case EFunction(identifier, params, body): 
                stack.push(e);
        }
    }
}

