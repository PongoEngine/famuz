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

import famuz.compiler.expr.ExprDef;
import famuz.compiler.expr.Expr;
import famuz.compiler.expr.Type;
import famuz.compiler.expr.Type.TypeTools;

class BuiltIns
{
    public static var rhythmType (get, null): Type;
    public static var laidType (get, null): Type;

    public static function include(context :Context) : Void
    {
        BuiltIns.push(context);
        BuiltIns.pop(context);
        BuiltIns.map(context);
        BuiltIns.mapi(context);
        BuiltIns.scales(context);
    }

    private static function scales(context :Context) : Void
    {
        scale(context, "major", [0,2,4,5,7,9,11]);
        scale(context, "natural_minor", [0,2,3,5,7,8,10]);
        scale(context, "melodic_minor", [0,2,3,5,7,8,11]);
        scale(context, "harmonic_minor", [0,2,3,5,7,9,11]);
        scale(context, "chromatic", [0,1,2,3,4,5,6,7,8,9,10,11]);
    }

    private static function scale(context :Context, name :String, steps :Array<Int>) : Void
    {
        context.addVarFunc(name, 
            new Expr(EArrayDecl(steps.map(n -> 
                new Expr(EConstant(CNumber(n)), TNumber, Position.identity()))
            ), TArray({ref:TNumber}), Position.identity())
        );
    }

    private static function push(context :Context) : Void
    {
        var nativeCall = new Expr(ENativeCall("push", ["array", "element"]), TMono({ref:None}), Position.identity());
        var func = EFunction("push", ["array", "element"], nativeCall, context);
        var pushExpr = new Expr(func, TMono({ref:None}), Position.identity());
        context.addVarFunc("push", pushExpr);
    }

    private static function map(context :Context) : Void
    {
        var nativeCall = new Expr(ENativeCall("map", ["array", "fn"]), TMono({ref:None}), Position.identity());
        var func = EFunction("map", ["array", "fn"], nativeCall, context);
        var mapExpr = new Expr(func, TypeTools.createAnonTFun(1), Position.identity());
        context.addVarFunc("map", mapExpr);
    }

    private static function mapi(context :Context) : Void
    {
        var nativeCall = new Expr(ENativeCall("mapi", ["array", "fn"]), TMono({ref:None}), Position.identity());
        var func = EFunction("mapi", ["array", "fn"], nativeCall, context);
        var mapiExpr = new Expr(func, TypeTools.createAnonTFun(2), Position.identity());
        context.addVarFunc("mapi", mapiExpr);
    }

    private static function pop(context :Context) : Void
    {
        var nativeCall = new Expr(ENativeCall("pop", ["array"]), TMono({ref:None}), Position.identity());
        var func = EFunction("pop", ["array"], nativeCall, context);
        var popExpr = new Expr(func, TMono({ref:None}), Position.identity());
        context.addVarFunc("pop", popExpr);
    }

    private static function get_rhythmType() : Type
    {
        if(_rhythmType == null) {
            _rhythmType =  TypeTools.createTAnonymous([
                {name: "hits", type: TArray({ref: TypeTools.createTAnonymous([
                    {name: "velocity", type: TNumber},
                    {name: "duration", type: TNumber}
                ])})},
                {name: "d", type: TNumber}
            ]);
        }
        return _rhythmType;
    }

    private static function get_laidType() : Type
    {
        if(_laidType == null) {
            _laidType =  TypeTools.createTAnonymous([
                {name: "a", type: TNumber},
                {name: "b", type: TBool}
            ]);
        }
        return _laidType;
    }

    private static var _laidType :Type;
    private static var _rhythmType :Type;
}