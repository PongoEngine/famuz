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
import famuz.compiler.evaluate.EvaluatePrint;
import famuz.compiler.Expr.ExprStack;

class Evaluate
{
    public static function evaluate(e :Expr, stack :ExprStack) : Void
    {
        switch (e.def) {
            case EConstant(constant): {
                switch constant {
                    case CIdentifier(str): {
                        var expr = e.context.getExpr(str);
                        evaluate(expr, stack);
                    }
                    case _: stack.push(e);
                }
            }
            case EVar(_, expr):
                evaluate(expr, stack);
            case ECall(identifier, args): 
                EvaluateCall.evaluate(identifier, args, e.pos, e.context, stack);
            case EBlock(exprs): if(exprs.length > 0) {
                evaluate(exprs[exprs.length-1], stack);
            }
            case EBinop(type, e1, e2): 
                EvaluateBinop.evaluate(type, e1, e2, e.context, stack);
            case EParentheses(expr): 
                stack.push(expr);
            case EPrint(expr): 
                EvaluatePrint.evaluate(expr, e.context, stack);
            case EArrayDecl(_): 
                stack.push(e);
            case EFunction(_, _, _): 
                stack.push(e);
        }
    }
}

