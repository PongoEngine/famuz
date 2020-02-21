package famuz.compiler;

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

import famuz.compiler.Context;
import famuz.compiler.theory.Key;
import famuz.compiler.theory.Scale;

enum BinopType
{
    B_ADD;
    B_SHIFT_LEFT;
    B_SHIFT_RIGHT;
}

typedef Parameter =
{
    var name :String;
    var type :Type;
}

typedef Hit = {start :Int, duration :Int};
typedef Note = {step :Int, hit :Hit};

enum Constant
{
    CIdentifier(str :String);
    CNumber(value :Int);
    CRhythm(hits :Array<Hit>, duration :Int);
    CMelody(notes :Array<Note>);
    CHarmony(melodies :Array<Array<Note>>);
    CSteps(steps :Array<Int>);
    CScale(type :ScaleType);
    CKey(key :Key);
    CScaledKey(type :ScaleType, key :Key);
    CMusic(music :Int);
}

enum ExprDef {
    //A constant.
    EConstant(constant :Constant);
    //Variable declaration.
    EVar(identifier :String, expr :Expr);
    //A call e(params).
    ECall(identifier :String, args :Array<Expr>);
    //A block of expressions {exprs}.
    EBlock(expr :Array<Expr>);
    //Binary operator e1 op e2.
    EBinop(type :BinopType, e1 :Expr, e2 :Expr);
    //Parentheses (e).
    EParentheses(expr :Expr);
    //Print print(e).
    EPrint(expr :Expr);
    //A function declaration.
    EFunction(identifier :String, params :Array<Parameter>, body :Expr);
}

typedef Expr = {
    var context :Context;
    var def :ExprDef;
    var pos :Position;
    var ret :Type;
}

@:forward(length)
abstract ExprStack(Array<Expr>)
{
    public inline function new() : Void
    {
        this = [];
    }

    public inline function push(expr :Expr) : Void
    {
        this.push(expr);
    }

    public inline function pop() : Expr
    {
        return this.pop();
    }

    public inline function peek() : Expr
    {
        return this[this.length-1];
    }

    @:arrayAccess
    public inline function get(index :Int) : Expr
    {
        return this[index];
    }
}