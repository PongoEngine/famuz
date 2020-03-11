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

package famuz.compiler;

import famuz.compiler.expr.Expr;

/**
 * 
 */
class Context
{
    public var parent :Context = null;

    public function new() : Void
    {
        _map = new Map<String, Expr>();
    }

    public function addExpr(name :String, expr :Expr) : Void
    {
        if(_map.exists(name)) {
            throw '"${name}" already exists.';
        }
        else {
            _map.set(name, expr);
        }
    }

    public function getExpr(name :String) : Expr
    {
        if(_map.exists(name)) {
            return _map.get(name);
        }
        else if(this.parent != null) {
            return this.parent.getExpr(name);
        }
        else {
            return null;
        }
    }

    public function createChild() : Context
    {
        var context = new Context();
        context.parent = this;
        return context;
    }

    private var _map :Map<String, Expr>;
}

class ContextTools
{
    public static function addArrayExprs(ctx :Context) : Void
    {
        addPush(ctx);
        addPop(ctx);
    }

    private static function addPush(ctx :Context) : Void
    {
        var array = new Expr(ctx, EConstant(CIdentifier("array")), null);
        var element = new Expr(ctx, EConstant(CIdentifier("element")), null);
        var op = new Expr(ctx, EArrayFunc(array, OpPush(element)), null);
        ctx.addExpr("push", new Expr(
            ctx, 
            EFunction("push", ["array", "element"], op), 
            null
        ));
    }

    private static function addPop(ctx :Context) : Void
    {
        var array = new Expr(ctx, EConstant(CIdentifier("array")), null);
        var op = new Expr(ctx, EArrayFunc(array, OpPop), null);
        ctx.addExpr("pop", new Expr(
            ctx, 
            EFunction("pop", ["array"], op), 
            null
        ));
    }
}