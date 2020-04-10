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
import famuz.util.TypeMap;
using Lambda;

class TypeChecker
{
    public static function analyse(expr :Expr, env :IContext) : Type
    {
        return expr.t = switch expr.def {
            case ENativeCall(_):
                expr.t;

            case EFunction(identifier, params, body, scope):
                var new_env = new ContextInnerOuter(scope, env);

                var args = params.map(p -> {
                    var arg_type = TMono({ref: None});
                    new_env.addType(p, arg_type);
                    return new Arg(p, arg_type);
                });

                var result_type = analyse(body, new_env);
                TFun(args, result_type);

            case EBlock(exprs):
                analyse(exprs[exprs.length -1], env);

            case EConstant(constant): 
                switch constant {
                    case CIdentifier(str):
                        switch env.getType(str) {
                            case Some(v):
                                v;
                            case None:
                                analyse(env.getExpr(str), env);
                        }
                    case CBool(value): 
                        TBool;
                    case CNumber(value): 
                        TNumber;
                    case CString(str): 
                        TString;
                }

            case EBinop(type, e1, e2):
                var t1 = analyse(e1, env);
                var t2 = analyse(e2, env);
                unify(t1, t2);
                switch type {
                    case ADD, SUBTRACT: 
                        t1;
                    case EQUALITY, GREATER_THAN, LESS_THAN:
                        TBool;
                }

            case EVar(identifier, expr):
                analyse(expr, env);

            case ECall(e, call_args):
                var new_fun_args = switch analyse(e, env) {
                    case TFun(fun_args, ret):
                        call_args.mapi((index, item) -> {
                            var argType = analyse(item, env);
                            return new Arg(fun_args[index].name, argType);
                        });
                    case TMono(t):
                        call_args.mapi((index, item) -> {
                            var argType = analyse(item, env);
                            return new Arg("?", argType);
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
                    case _:
                        trace(expr.t + "\n\n");
                        throw "err";
                }
                for(v in values) {
                    unify(arrayType, analyse(v, env));
                }
                expr.t;

            case EObjectDecl(fields):
                var anonFields = new TypeMap();
                for(kv in fields.keyValueIterator()) {
                    anonFields.set(kv.key, analyse(kv.value, env));
                }
                TAnonymous({ref:{fields: anonFields}});

            case EArray(e1, e2):
                switch analyse(e1, env) {
                    case TArray(t): t.ref;
                    case _: TMono({ref:None});
                }

            case EField(e, field):
                return switch analyse(e, env) {
                    case TAnonymous(a): {
                        if(a.ref.fields.exists(field)) {
                            a.ref.fields.get(field);
                        }
                        else {
                            throw '${field} does not exist on ${e.toString()}';
                        }
                    }
                    case _: TMono({ref:None});
                }

            case EIf(econd, ethen, eelse):
                unify(
                    analyse(ethen, env),
                    analyse(eelse, env)
                );
                unify(expr.t, ethen.t);
                expr.t;

            case EParentheses(expr):
                analyse(expr, env);

            case EPrint(expr):
                analyse(expr, env);

            case ESwitch(e, cases, edef):
                var t = analyse(e, env);
                for(case_ in cases) {
                    for(value in case_.values) {
                        unify(t, analyse(value, env));
                    }
                    unify(expr.t, analyse(case_.expr, env));
                }
                unify(expr.t, analyse(edef, env));
                expr.t;

            case ETernary(econd, eif, eelse):
                unify(
                    analyse(eif, env),
                    analyse(eelse, env)
                );
                unify(expr.t, eif.t);
                expr.t;
            
            case EUnop(op, e):
                analyse(e, env);
        }
    }

    public static function unifyEquals(t1 :Type, t2 :Type) : Bool
    {
        try {
            unify(t1, t2);
            return true;
        }
        catch(e :String) {
            return false;
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
                if(args1.length != args2.length) {
                    throw "Type error: " + t1.toString() + " is not " + t2.toString();
                }
                for(i in 0...args1.length) {
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

                if(fieldsA.equalsKeys(fieldsB)) {
                    for(key in fieldsA.keys()) {
                        unify(fieldsA.get(key), fieldsB.get(key));
                    }
                }
                else {
                    throw "Type error: " + t1.toString() + " is not " + t2.toString();
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