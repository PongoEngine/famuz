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
            return ContextArrayTools.getExpr(this, name);
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

class ContextArrayTools
{
    public static function getExpr(this_ :Context, name :String) : Expr
    {
        if(name == "push") {
            var array = new Expr(this_, EConstant(CIdentifier("array")), null);
            var element = new Expr(this_, EConstant(CIdentifier("element")), null);
            var op = new Expr(this_, EArrayFunc(array, OpPush(element)), null);
            return new Expr(
                this_, 
                EFunction("push", ["array", "element"], op), 
                null
            );
        }
        else if(name == "pop") {
            var array = new Expr(this_, EConstant(CIdentifier("array")), null);
            var op = new Expr(this_, EArrayFunc(array, OpPop), null);
            return new Expr(
                this_, 
                EFunction("push", ["array"], op), 
                null
            );
        }
        else {
            return null;
        }
    }
}