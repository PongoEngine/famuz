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
import famuz.compiler.Token.PunctuatorType;
import famuz.compiler.expr.Expr;
import famuz.compiler.expr.EnumDefinition;
using famuz.util.FStringTools;

/**
 * 
 */
class Context
{
    public var parent :Context = null;

    public function new(error :Error) : Void
    {
        _error = error;
        _map = new Map<String, Expr>();
        _enumDefs = new Map<String, EnumDefinition>();
    }

    public function addVarFunc(name :String, expr :Expr) : Void
    {
        if(_map.exists(name)) {
            this.printEnvironment("ALREADY EXISTS:");
            throw '"${name}" already exists.';
        }
        else {
            _map.set(name, expr);
        }
    }

    public function removeVarFunc(name :String) : Void
    {
        if(!_map.exists(name)) {
            throw '"${name}" doesn\'t exists.';
        }
        else {
            _map.remove(name);
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
        else if(this.parent != null) {
            return this.parent.getExpr(name);
        }
        else {
            this.printEnvironment("MISSING EXPR:");
            throw 'Expr:${name} not found.';
        }
    }

    public inline function printErrors() : Void
    {
        this._error.printErrors();
    }

    public inline function addError(e :ParserError) : Void
    {
        _error.addError(e);
    }

    public function hasErrors() : Bool
    {
        return this._error.hasErrors();
    }

    public function createChild() : Context
    {
        var context = new Context(_error);
        context.parent = this;
        return context;
    }

    public function printEnvironment(msg :String) : Void
    {
        trace(msg + "\n" + _map.mapToString() + "\n");
    }

    private var _error :Error;
    private var _map :Map<String, Expr>;
    private var _enumDefs :Map<String, EnumDefinition>;
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
        var array = new Expr(ctx, EConstant(CIdentifier("___array___")), null);
        var element = new Expr(ctx, EConstant(CIdentifier("___element___")), null);
        var op = new Expr(ctx, EArrayFunc(array, OpPush(element)), null);
        ctx.addVarFunc("push", new Expr(
            ctx, 
            EFunction("push", ["___array___", "___element___"], op), 
            null
        ));
    }

    private static function addPop(ctx :Context) : Void
    {
        var array = new Expr(ctx, EConstant(CIdentifier("___array___")), null);
        var op = new Expr(ctx, EArrayFunc(array, OpPop), null);
        ctx.addVarFunc("pop", new Expr(
            ctx, 
            EFunction("pop", ["___array___"], op), 
            null
        ));
    }
}