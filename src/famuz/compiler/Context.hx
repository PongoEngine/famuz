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

import famuz.compiler.Error.ParserError;
import famuz.compiler.expr.Expr;
import famuz.compiler.expr.EnumDefinition;

interface IContext {
    function getExpr(name :String) : Expr;
    function clone() : IContext;
    function addVarFunc(name :String, expr :Expr) : Void;
    function error(e :ParserError) : Dynamic;
}

/**
 * 
 */
class Context implements IContext
{
    public function new() : Void
    {
        _map = new Map<String, Expr>();
        _enumDefs = new Map<String, EnumDefinition>();
    }

    public function addVarFunc(name :String, expr :Expr) : Void
    {
        if(_map.exists(name)) {
            throw '"${name}" already exists.';
        }
        else {
            _map.set(name, expr);
        }
    }

    public function defineEnumDef(def :EnumDefinition) : Void
    {
        if(_enumDefs.exists(def.name)) {
            throw '"${def.name}" already exists.';
        }
        else {
            _enumDefs.set(def.name, def);
            for(f in def.fields) {
                this.addVarFunc(f.name, f.expr);
            }
        }
    }

    public function getExpr(name :String) : Expr
    {
        if(_map.exists(name)) {
            return _map.get(name);
        }
        else {
            throw 'Expr:${name} not found.';
        }
    }

    public inline function error(e :ParserError) : Dynamic
    {
        Error.error(e);
        return null;
    }

    public function createContext() : Context
    {
        return new Context();
    }

    public function clone() : Context
    {
        var c = this.createContext();
        c._map = this._map.copy();
        c._enumDefs = this._enumDefs.copy();
        return c;
    }

    private var _map :Map<String, Expr>;
    private var _enumDefs :Map<String, EnumDefinition>;
}

class ContextInnerOuter implements IContext
{
    public function new(inner :IContext, outer :IContext)
    {
        _map = new Map<String, Expr>();
        _inner = inner;
        _outer = outer;
    }

    public function getExpr(name :String) : Expr
    {
        if(_map.exists(name)) {
            return _map.get(name);
        }
        try {
            return _inner.getExpr(name);
        }
        catch(e :Dynamic) {
            return _outer.getExpr(name);
        }
    }

    public function addVarFunc(name :String, expr :Expr) : Void
    {
        if(_map.exists(name)) {
            throw '"${name}" already exists.';
        }
        else {
            _map.set(name, expr);
        }
    }

    public function clone() : ContextInnerOuter
    {
        var c = new ContextInnerOuter(this._inner, this._outer);
        c._map = this._map.copy();
        return c;
    }
    public inline function error(e :ParserError) : Dynamic
    {
        Error.error(e);
        return null;
    }

    private var _map :Map<String, Expr>;
    private var _inner :IContext;
    private var _outer :IContext;
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
        var array = new Expr(EConstant(CIdentifier("array")), null);
        var element = new Expr(EConstant(CIdentifier("element")), null);
        var op = new Expr(EArrayFunc(array, OpPush(element)), null);
        ctx.addVarFunc("push", new Expr(
            EFunction("push", ["array", "element"], op, ctx.createContext()), 
            null
        ));
    }

    private static function addPop(ctx :Context) : Void
    {
        var array = new Expr(EConstant(CIdentifier("array")), null);
        var op = new Expr(EArrayFunc(array, OpPop), null);
        ctx.addVarFunc("pop", new Expr(
            EFunction("pop", ["array"], op, ctx.createContext()), 
            null
        ));
    }
}