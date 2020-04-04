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

package famuz.compiler.expr;

import famuz.compiler.expr.Ref;

using Lambda;

@:using(famuz.compiler.expr.Type.TypeTools)
enum Type
{
    TAnonymous(a:Ref<AnonType>);
    TNumber;
    TBool;
    TScale;
    TKey;
    TMono(t:Ref<Null<Type>>);
    TArray(t:Ref<Null<Type>>);
    TFun(args:Array<{t:Type, name:String}>, ret:Type);
}

typedef AnonType = {fields :Array<{name :String, type :Type}>};

class TypeTools
{
    public static function unify(t1 :Type, t2 :Type) : Void
    {
        t1 = prune(t1);
        t2 = prune(t2);

        switch [t1, t2] {
            case [TMono(t), _]: {
                if(t1 != t2) {
                    if(occursInType(t1, t2)) {
                        throw "Recursive unification";
                    }
                    t.ref = t2;
                }
            }
            case [_, TMono(t)]:
                unify(t2, t1);
            case [TFun(args1, ret1), TFun(args2, ret2)]: {
                if(args1.length != args2.length) {
                    throw "Type error: " + t1.toString() + " is not " + t2.toString();
                }
                for(i in 0...args1.length) {
                    unify(args1[i].t, args2[i].t);
                }
                unify(ret1, ret2);
            }
            case [TArray(a), TArray(b)]: {
                unify(a.ref, b.ref);
            }
            case [TAnonymous(a), TAnonymous(b)]: {
                var fieldsA = a.ref.fields;
                var fieldsB = b.ref.fields;
                if(fieldsA.length != fieldsB.length) {
                    throw "Type error: " + t1.toString() + " is not " + t2.toString();
                }
                for(i in 0...fieldsA.length) {
                    unify(fieldsA[i].type, fieldsB[i].type);
                }
            }
            case _: {
                if(t1 != t2) {
                    throw "Type error: " + t1.toString() + " is not " + t2.toString();
                }
            }
        }
    }

    private static function prune(type :Type) : Type
    {
        return switch type {
            case TMono(t): t.ref != null
                ? t.ref
                : type;
            case _: type;
        }
    }

    private static function occursInType(t1 :Type, t2 :Type) : Bool
    {
        t2 = prune(t2);
        if(t2.equals(t1)) {
            return true;
        } 
        return switch t2 {
            case TFun(args, ret): {
                occursInTypeArray(t1, args.map(a -> a.t).concat([ret]));
            }
            case _: false;
        }
    }
    
    private static function occursInTypeArray(t1 :Type, types :Array<Type>) : Bool
    {
        return types.map(function(t2) {
            return occursInType(t1, t2);
        }).indexOf(true) >= 0;
    }

    public static function toString(t :Type) : String
    {
        return switch t {
            case TAnonymous(a):
                "{" + a.ref.fields.map(f -> {
                    return '${f.name}: ${f.type.toString()}';
                }).join(", ") + "}";
            case TArray(t):
                'Array<${TypeTools.toString(t.ref)}>';
            case TNumber: 
                "Number";
            case TBool: 
                "Bool";
            case TScale: 
                "Scale";
            case TKey: 
                "Key";
            case TMono(t): 
                t.ref != null
                    ? TypeTools.toString(t.ref)
                    : "a";
            case TFun(args, ret): {
                var argsStr = args.length > 0
                    ? args.mapi((i, a) -> {
                        return '${a.name}:${a.t.toString()}';
                    }).join(" -> ")
                    : "()";
                '(${argsStr} -> ${ret.toString()})';
            }
        }    
    }
}