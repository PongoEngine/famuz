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
import famuz.compiler.expr.ExprDef;
import famuz.compiler.expr.Type;
using famuz.compiler.expr.ExprBinops;
using famuz.util.FStringTools;

using Lambda;

/**
 * 
 */
class Expr
{
    public var def :ExprDef;
    public var pos :Position;
    public var t :Type;

    public function new(def :ExprDef, t :Type, pos :Position) : Void
    {
        this.def = def;
        this.t = t;
        this.pos = pos;
    }

    public function evaluate(context :IContext) : Expr
    {
        return switch this.def {
            case ENativeCall(funcName, args):
                switch funcName {
                    case "push":
                        var array = context.getExpr(args[0]).evaluate(context);
                        var element = context.getExpr(args[1]).evaluate(context);
                        array.def.getArrayDecl().push(element);
                        array;
                    case "pop":
                        var array = context.getExpr(args[0]).evaluate(context);
                        array.def.getArrayDecl().pop();
                        array;
                    case "map":
                        var array = context.getExpr(args[0]).evaluate(context);
                        var fn = context.getExpr(args[1]).evaluate(context);
                        var exprs = array.def.getArrayDecl().map(item -> {
                            return new Expr(ECall(fn, [item]), TMono({ref:None}), Position.identity()).evaluate(context);
                        });
                        new Expr(EArrayDecl(exprs), TArray({ref:exprs[0].t}), Position.identity());
                    case "mapi":
                        var array = context.getExpr(args[0]).evaluate(context);
                        var fn = context.getExpr(args[1]).evaluate(context);
                        var exprs = array.def.getArrayDecl().mapi((index, item) -> {
                            var i = new Expr(EConstant(CNumber(index)), TNumber, Position.identity());
                            var call = ECall(fn, [item, i]);
                            new Expr(call, TMono({ref:None}), Position.identity()).evaluate(context);
                        });
                        new Expr(EArrayDecl(exprs), TArray({ref:exprs[0].t}), Position.identity());
                    case _: 
                        throw "err";
                }

            case EConstant(constant):
                switch constant {
                    case CIdentifier(str):
                        context.getExpr(str).evaluate(context);
                    case _: this;
                }

            case ESwitch(e, cases, edef):
                for(case_ in cases) {
                    for(v in case_.values) {
                        if(v.equals(e, context).def.getBool()) {
                            return case_.expr.evaluate(context);
                        }
                    }
                }
                edef == null
                    ? throw "err"
                    : edef.evaluate(context);

            case EObjectDecl(fields):
                var newFields = new Map<String, Expr>();
                for(kv in fields.keyValueIterator()) {
                    newFields.set(kv.key, kv.value.evaluate(context));
                }
                new Expr(EObjectDecl(newFields), this.t, this.pos);

            case EArray(e1, e2):
                var array = e1.evaluate(context).def.getArrayDecl();
                var index = e2.evaluate(context).def.getNumber();
                array[index];

            case EArrayDecl(arra):
                var newArra = [];
                for(item in arra) {
                    newArra.push(item.evaluate(context));
                }
                new Expr(EArrayDecl(newArra), this.t, this.pos);

            case EField(e, field):
                switch e.evaluate(context).def {
                    case EObjectDecl(fields):
                        fields.get(field).evaluate(context);
                    case _:
                        throw "err";
                }

            case EVar(_, expr):
                expr.evaluate(context);

            case ECall(e, args):
                switch e.evaluate(context).def {
                    case EFunction(identifier, params, body, scope):
                        var ctx = new ContextInnerOuter(scope, context);
                        for(i in 0...params.length) {
                            ctx.addVarFunc(params[i], args[i]);
                        }
                        body.evaluate(ctx);
                    case _: 
                        throw "err";
                }

            case EBlock(exprs):
                exprs[exprs.length -1].evaluate(context);

            case EIf(econd, ethen, eelse):
                switch econd.evaluate(context).def {
                    case EConstant(constant): switch constant {
                        case CBool(value): value
                            ? ethen.evaluate(context)
                            : eelse.evaluate(context);
                        case _: throw "err";
                    }
                    case _: throw "err";
                }
            
            case EUnop(op, e):
                switch [op, e.evaluate(context).def] {
                    case [OpNot, EConstant(constant)]: switch constant {
                        case CBool(value): 
                            new Expr(
                                EConstant(CBool(!value)), 
                                TMono({ref: None}),
                                this.pos
                            );
                        case _: throw "err";
                    }
                    case [OpNeg, EConstant(constant)]: switch constant {
                        case CNumber(value): 
                            new Expr(
                                EConstant(CNumber(-value)), 
                                TMono({ref: None}),
                                this.pos
                            );
                        case _: throw "err";
                    }
                    case _: throw "err";
                }

            case ETernary(econd, eif, eelse):
                switch econd.evaluate(context).def {
                    case EConstant(constant): {
                        switch constant {
                            case CBool(value): value
                                ? eif.evaluate(context)
                                : eelse.evaluate(context);
                            case _:
                                throw "err";
                        }
                    }
                    case _: throw "err";
                }

            case EBinop(type, e1, e2):
                switch type {
                    case ADD: e1.add(e2, context);
                    case SUBTRACT: e1.subtract(e2, context);
                    case DIVIDE: e1.divide(e2, context);
                    case MULTIPLY: e1.multiply(e2, context);
                    case EQUALITY: e1.equals(e2, context);
                    case GREATER_THAN: e1.greaterThan(e2, context);
                    case LESS_THAN: e1.lessThan(e2, context);
                }

            case EParentheses(expr):
                expr.evaluate(context);

            case EPrint(expr):
                var e = expr.evaluate(context);
                trace('${this.pos.file}:${this.pos.line}: ${e}\n');
                e;

            case EFunction(_, _, _):
                this;
        }
    }

    public function toString() : String
    {
        var str = switch def {
            case ENativeCall(_): "NativeCall";
            case EConstant(constant): switch constant {
                case CIdentifier(str): str;
                case CString(str): '"${str}"';
                case CNumber(value): value + "";
                case CBool(value): value + "";
            }
            case EArrayDecl(values):
                '[${values.map(v -> v.toString()).join(", ")}]';
            case EFunction(identifier, params, _):
                '${identifier} ${t.toString()}';
            case EVar(identifier, expr):
                '${identifier}: ${expr}';
            case EBlock(exprs):
                '{...}';
            case EArray(e1, e2):
                throw "err";
            case EBinop(type, e1, e2):
                var op = switch type {
                    case ADD: '+';
                    case SUBTRACT: '-';
                    case DIVIDE: '/';
                    case MULTIPLY: '*';
                    case EQUALITY: '==';
                    case LESS_THAN: "<";
                    case GREATER_THAN: ">";
                }
                '${e1}${op}${e2}';
            case ECall(e, params):
                '${e}(${params.join(",")})';
            case EField(e, field):
                throw "err";
            case EIf(econd, ethen, eelse):
                throw "err";
            case EObjectDecl(fields):
                '${fields.mapToStringSmall()}';
            case EParentheses(expr):
                '( ${expr.toString()} )';
            case EPrint(expr):
                'print ${expr}';
            case ESwitch(e, cases, edef):
                throw "err";
            case ETernary(econd, eif, eelse):
                throw "err";
            case EUnop(op, e):
                throw "err";
        }
        
        return str;
    }
}

class ExprTools
{
    public static function createIdentifier(value :String, position :Position) : Expr
    {
        return new Expr(EConstant(CIdentifier(value)), TMono({ref: None}), position);
    }

    public static function createCNumber(value :Int, position :Position) : Expr
    {
        return new Expr(EConstant(CNumber(value)), TMono({ref: None}), position);
    }

    public static function createEObjectDecl(fields :Map<String, Expr>, position :Position) : Expr
    {
        return new Expr(EObjectDecl(fields), TMono({ref: None}), position);
    }

    public static function createEArrayDecl(values :Array<Expr>, position :Position) : Expr
    {
        return new Expr(EArrayDecl(values), TArray({ref:TMono({ref: None})}), position);
    }
}