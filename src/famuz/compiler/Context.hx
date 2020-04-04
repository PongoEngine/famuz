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

import famuz.compiler.expr.Type;
import famuz.compiler.expr.Expr;
import famuz.compiler.expr.EnumDefinition;

interface IContext {
    function getType(name :String) : Type;
    function getExpr(name :String) : Expr;
    function clone() : IContext;
    function addType(name :String, expr :Type) : Void;
    function addVarFunc(name :String, expr :Expr) : Void;
}

/**
 * 
 */
class Context implements IContext
{
    public function new() : Void
    {
        _typeMap = new Map<String, Type>();
        _exprMap = new Map<String, Expr>();
        _enumDefs = new Map<String, EnumDefinition>();
    }

    public function addVarFunc(name :String, expr :Expr) : Void
    {
        if(_exprMap.exists(name)) {
            throw '"${name}" already exists.';
        }
        else {
            _exprMap.set(name, expr);
        }
    }

    public function addType(name :String, type :Type) : Void
    {
        if(_typeMap.exists(name)) {
            throw '"${name}" already exists.';
        }
        else {
            _typeMap.set(name, type);
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
        if(_exprMap.exists(name)) {
            return _exprMap.get(name);
        }
        else {
            throw 'Expr:${name} not found.';
        }
    }

    public function getType(name :String) : Type
    {
        if(_typeMap.exists(name)) {
            return _typeMap.get(name);
        }
        else {
            throw 'Type:${name} not found.';
        }
    }

    public function createContext() : Context
    {
        return new Context();
    }

    public function clone() : Context
    {
        var c = this.createContext();
        c._exprMap = this._exprMap.copy();
        c._enumDefs = this._enumDefs.copy();
        return c;
    }

    private var _typeMap :Map<String, Type>;
    private var _exprMap :Map<String, Expr>;
    private var _enumDefs :Map<String, EnumDefinition>;
}

class ContextInnerOuter implements IContext
{
    public function new(inner :IContext, outer :IContext)
    {
        _typeMap = new Map<String, Type>();
        _exprMap = new Map<String, Expr>();
        _inner = inner;
        _outer = outer;
    }

    public function getExpr(name :String) : Expr
    {
        if(_exprMap.exists(name)) {
            return _exprMap.get(name);
        }
        try {
            return _inner.getExpr(name);
        }
        catch(e :Dynamic) {
            return _outer.getExpr(name);
        }
    }

    public function getType(name :String) : Type
    {
        if(_typeMap.exists(name)) {
            return _typeMap.get(name);
        }
        try {
            return _inner.getType(name);
        }
        catch(e :Dynamic) {
            return _outer.getType(name);
        }
    }

    public function addVarFunc(name :String, expr :Expr) : Void
    {
        if(_exprMap.exists(name)) {
            throw '"${name}" already exists.';
        }
        else {
            _exprMap.set(name, expr);
        }
    }

    public function addType(name :String, type :Type) : Void
    {
        if(_typeMap.exists(name)) {
            throw '"${name}" already exists.';
        }
        else {
            _typeMap.set(name, type);
        }
    }

    public function clone() : ContextInnerOuter
    {
        var c = new ContextInnerOuter(this._inner, this._outer);
        c._exprMap = this._exprMap.copy();
        return c;
    }

    private var _typeMap :Map<String, Type>;
    private var _exprMap :Map<String, Expr>;
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
        var array = new Expr(EConstant(CIdentifier("array")), TMono({ref: null}), null);
        var element = new Expr(EConstant(CIdentifier("element")), TMono({ref: null}), null);
        var op = new Expr(EArrayFunc(array, OpPush(element)), TMono({ref: null}), null);
        ctx.addVarFunc("push", new Expr(
            EFunction("push", ["array", "element"], op, ctx.createContext()), 
            TMono({ref: null}),
            null
        ));
    }

    private static function addPop(ctx :Context) : Void
    {
        var array = new Expr(EConstant(CIdentifier("array")), TMono({ref: null}), null);
        var op = new Expr(EArrayFunc(array, OpPop), TMono({ref: null}), null);
        ctx.addVarFunc("pop", new Expr(
            EFunction("pop", ["array"], op, ctx.createContext()), 
            TMono({ref: null}),
            null
        ));
    }
}