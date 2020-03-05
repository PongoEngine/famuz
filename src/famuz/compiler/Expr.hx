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
import famuz.compiler.theory.Step;
import famuz.compiler.theory.Hit;
import famuz.compiler.theory.SteppedHit;
import famuz.compiler.theory.NotedHit;

enum BinopType
{
    ADD;
    SHIFT_LEFT;
    SHIFT_RIGHT;
}

typedef Parameter =
{
    var name :String;
    var type :Type;
}

enum Constant
{
    CIdentifier(str :String);
    CNumber(value :Int);
    CRhythm(hits :Array<Hit>, duration :Int);
    CMelody(notes :Array<SteppedHit>, duration :Int);
    CHarmony(melodies :Array<Array<SteppedHit>>);
    CSteps(steps :Array<Step>);
    CScale(type :Scale);
    CKey(key :Key);
    CScaledKey(scale :Scale, key :Key);
    CMusic(music :Array<NotedHit>);
}

enum ExprDef {
    //A constant.
    EConstant(constant :Constant);
	//Array access e1[e2].
	EArray(e1:Expr, e2:Expr);
    //An array declaration [el].
    EArrayDecl(values:Array<Expr>);
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

class ExprTools
{
    public static function copyNumber(e :Expr) : Int
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CNumber(value): value;
                case _: throw "Expected Number";
            }
            case _: throw "Expected Number";
        }
    }

    public static function copyArray(e :Expr) : Array<Expr>
    {
        return switch e.def {
			case EArrayDecl(values): values;
            case _: throw "Expected Array";
        }
    }

    public static function copySteps(e :Expr) : Array<Step>
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CSteps(steps): steps.copy();
                case _: throw "Expected Steps.";
            }
            case _: throw "Expected Steps.";
        }
    }

    public static function copyMusic(e :Expr) : Array<NotedHit>
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CMusic(music): music;
                case _: throw "Expected Music.";
            }
            case _: throw "Expected Music.";
        }
    }

    public static function copyKey(e :Expr) : Key
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CKey(key): key;
                case _: throw "Expected Key.";
            }
            case _: throw "Expected Key.";
        }
    }

    public static function copyScale(e :Expr) : Scale
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CScale(scale): scale;
                case _: throw "Expected Scale.";
            }
            case _: throw "Expected Scale.";
        }
    }

    public static function copyScaledKey(e :Expr) : {scale:Scale, key:Key}
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CScaledKey(scale, key): {scale:scale, key:key};
                case _: throw "Expected Scale.";
            }
            case _: throw "Expected Scale.";
        }
    }

    public static function copyMelody(e :Expr) : {steppedHits: Array<SteppedHit>, duration :Int}
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CMelody(melody, duration): {
                    steppedHits: melody.copy(),
                    duration: duration
                };
                case _: throw "Expected Melody.";
            }
            case _: throw "Expected Steps.";
        }
    }

    public static function copyRhythm(e :Expr) : {hits: Array<Hit>, duration :Int}
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CRhythm(hits, duration): {
                    hits: hits.copy(),
                    duration: duration
                };
                case _: throw "Expected Rhythm.";
            }
            case _: throw "Expected Rhythm";
        }
    }
}