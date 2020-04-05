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

import famuz.compiler.Context;
import famuz.compiler.expr.Type;
import famuz.util.Set;

using Lambda;

class TypeChecker
{
    public static function analyse(expr :Expr, env :IContext, ?non_generic :Set<Type>) : Type
    {
        if(non_generic == null) {
            non_generic = new Set<Type>();
        }

        return expr.t = switch expr.def {
            case EFunction(identifier, params, body, scope):
                var new_env = new ContextInnerOuter(scope, env);
                var new_non_generic = non_generic.copy();

                var args = params.map(p -> {
                    var arg_type = TMono({ref: None});
                    new_non_generic.set(arg_type);
                    new_env.addType(p, arg_type);
                    return new TypedName(p, arg_type);
                });

                var result_type = analyse(body, new_env, new_non_generic);
                TFun(args, result_type);

            case EBlock(exprs):
                analyse(exprs[exprs.length -1], env, non_generic);

            case EConstant(constant): 
                switch constant {
                    case CIdentifier(str):
                        switch env.getType(str) {
                            case Some(v):
                                v;
                            case None:
                                analyse(env.getExpr(str), env, non_generic);
                        }
                    case CBool(value): 
                        TBool;
                    case CNumber(value): 
                        TNumber;
                    case CScale(type): 
                        TScale;
                    case CKey(key): 
                        TKey;
                }

            case EBinop(type, e1, e2):
                analyse(e1, env, non_generic);
                analyse(e2, env, non_generic);
                unify(e1.t, e2.t);
                e1.t;

            case EVar(identifier, expr):
                analyse(expr, env, non_generic);

            case ECall(e, call_args):
                var new_fun_args = switch analyse(e, env, non_generic) {
                    case TFun(fun_args, ret):
                        call_args.mapi((index, item) -> {
                            var argType = analyse(item, env, non_generic);
                            return new TypedName(fun_args[index].name, argType);
                        });
                    case _:
                        throw "err";
                }

                var result_type = TMono({ref:None});
                unify(TFun(new_fun_args, result_type), e.t);
                result_type;

            case EArrayDecl(values):
                var arrayType = switch expr.t {
                    case TArray(t): t.ref;
                    case _: throw "err";
                }
                for(v in values) {
                    unify(arrayType, analyse(v, env, non_generic));
                }
                expr.t;

            case EObjectDecl(fields):
                var anonFields :Array<TypedName> = [];
                for(kv in fields.keyValueIterator()) {
                    anonFields.push(new TypedName(kv.key, analyse(kv.value, env, non_generic)));
                }
                TAnonymous({ref:{fields: anonFields}});

            case _:
                trace(expr.def + "\n");
                throw "err";
        }
    }

    public static function unify(t1 :Type, t2 :Type) : Void
    {
        t1 = prune(t1);
        t2 = prune(t2);

        switch [t1, t2] {
            case [TMono(t), _]: {
                if(!t1.equals(t2)) {
                    if(occursInType(t1, t2)) {
                        throw "Recursive unification";
                    }
                    t.ref = Some(t2);
                }
            }
            case [_, TMono(t)]:
                unify(t2, t1);
            case [TFun(args1, ret1), TFun(args2, ret2)]: {
                for(i in 0...Math.floor(Math.min(args1.length, args2.length))) {
                    unify(args1[i].type, args2[i].type);
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
                    if(fieldsA[i].name != fieldsB[i].name) {
                        throw "Type error: " + t1.toString() + " is not " + t2.toString();
                    }
                    unify(fieldsA[i].type, fieldsB[i].type);
                }
            }
            case _: {
                if(!t1.equals(t2)) {
                    throw "Type error: " + t1.toString() + " is not " + t2.toString();
                }
            }
        }
    }

    private static function prune(t :Type) : Type
    {
        return switch t {
            case TMono(tmono):
                switch tmono.ref {
                    case Some(v): prune(v);
                    case None: t;
                }
            case _: t;
        }
    }

    private static function occursInType(v :Type, type2 :Type) : Bool
    {
        var pruned_type2 = prune(type2);
        if (pruned_type2.equals(v)) {
            return true;
        }

        return switch pruned_type2 {
            case TFun(args, ret): {
                occursIn(v, args.map(a -> a.type).concat([ret]));
            }
            case _: false;
        }
    }

    private static function occursIn(t :Type, types :Array<Type>) : Bool
    {
        return types.filter(t2 -> occursInType(t, t2)).length > 0;
    }
}