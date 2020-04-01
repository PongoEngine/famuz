package famuz.compiler.expr;

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
}