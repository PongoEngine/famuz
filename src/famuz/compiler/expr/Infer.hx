package famuz.compiler.expr;

import famuz.compiler.expr.Type.TypeTools;

class Infer
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
                for(i in 0...Std.int(Math.min(args1.length, args2.length))) {
                    unify(args1[i].t, args2[i].t);
                }
                unify(ret1, ret2);
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

    private static function fresh(type :Type, nonGeneric :Array<Type>, ?mappings : Map<Type, Type>) : Type
    {
        if(mappings == null) mappings = new Map<Type, Type>();
    
        type = prune(type);

        return switch type {
            case TMono(t): {
                if(occursInTypeArray(type, nonGeneric)) {
                    type;
                } 
                else {
                    if(!mappings.exists(type)) {
                        mappings.set(type, TMono({ref: null}));
                    }
                    mappings.get(type);
                }
            }
            case TBool: 
                TBool;
            case TFun(args, ret): 
                var freshArgs = args.map(a -> {t:fresh(a.t, nonGeneric, mappings), name:a.name});
                var freshRet = fresh(ret, nonGeneric, mappings);
                TFun(freshArgs, freshRet);
            case TNumber: 
                TNumber;
            case TScale: 
                TScale;
            case TKey: 
                TKey;
        }
    }

    private static function analyse(node :Expr, env :Context, ?nonGeneric :Array<Type>) : Type
    {
        if(nonGeneric == null) nonGeneric = [];

        return switch node.def {
            case EBlock(exprs): 
                null;
            case EConstant(constant): 
                null;
            case EEnumParameter(e, def, index): 
                null;
            case ESwitch(e, cases, edef): 
                null;
            case EObjectDecl(fields): 
                null;
            case EArray(e1, e2): 
                null;
            case EArrayFunc(e, op): 
                null;
            case EArrayDecl(values): 
                null;
            case EField(e, field): 
                null;
            case EVar(identifier, expr): 
                null;
            case ECall(e, args): 
                null;
            case EIf(econd, ethen, eelse): 
                null;
            case EUnop(op, e): 
                null;
            case ETernary(econd, eif, eelse): 
                null;
            case EBinop(type, e1, e2): 
                null;
            case EParentheses(expr): 
                null;
            case EPrint(expr): 
                null;
            case EFunction(identifier, params, body, scope): 
                null;
        }
    }
}