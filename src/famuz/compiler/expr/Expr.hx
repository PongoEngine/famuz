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

/**
 * 
 */
class Expr
{
    public var def :ExprDef;
    public var pos :Position;
    public var t :Type;

    public static var _T :Type = null;

    public function new(def :ExprDef, t :Type, pos :Position) : Void
    {
        this.def = def;
        this.t = t;
        this.pos = pos;
    }

    public function evaluate(context :IContext) : Expr
    {
        return switch this.def {
            /**
             * 
             */
            case EConstant(constant):
                switch constant {
                    case CIdentifier(str):
                        context.getExpr(str).evaluate(context);
                    case _:
                        this;
                }

            /**
             * 
             */
            case ESwitch(e, cases, edef): {
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
            }

            /**
             * 
             */
            case EEnumParameter(e, type, index):
                this;

            /**
             * 
             */
            case EObjectDecl(_):
                this;

            /**
             * 
             */
            case EArray(e1, e2):
                switch [e1.evaluate(context).def, e2.evaluate(context).def] {
                    case [EArrayDecl(values), EConstant(constant)]: switch constant {
                        case CNumber(index): values[index].evaluate(context);
                        case _: throw "err";
                    }
                    case _: throw "err";
                }

            /**
             * 
             */
            case EArrayDecl(_):
                this;

            /**
             * 
             */
             case EArrayFunc(e, op):
                var evalArra = e.evaluate(context);
                switch [evalArra.def, op] {
                    case [EArrayDecl(values), OpPush(expr)]:
                        values.push(expr.evaluate(context));
                        evalArra;
                    case [EArrayDecl(values), OpPop]:
                        values.pop();
                        evalArra;
                    case _:throw "err";
                }

            /**
             * 
             */
            case EField(e, field): {
                switch e.evaluate(context).def {
                    case EObjectDecl(fields):
                        fields.get(field);
                    case _:
                        throw "err";
                }
            }

            /**
             * 
             */
            case EVar(_, expr):
                expr.evaluate(context);

            /**
             * 
             */
            case ECall(e, args):
                switch e.evaluate(context).def {
                    case EFunction(ident, params, body, scope): {
                        if(args.length == params.length) {
                            var callScoped = scope.clone();
                            for(i in 0...args.length) {
                                callScoped.addVarFunc(params[i], args[i].evaluate(context));
                            }
                            var ctxInnerOuter = new ContextInnerOuter(callScoped, context);
                            body.evaluate(ctxInnerOuter);
                        }
                        else if(args.length < params.length) {
                            var callScoped = scope.clone();
                            for(i in 0...args.length) {
                                callScoped.addVarFunc(params[i], args[i]);
                            }
                            var ctxInnerOuter = new ContextInnerOuter(callScoped, context);
                            var identParams = "";
                            for(i in 0...args.length) {
                                identParams += '_${params[i]}';
                            }
                            new Expr(EFunction(ident + identParams, params.slice(args.length), body, ctxInnerOuter), Expr._T, null);
                        }
                        else {
                            Error.create(TooManyArgs(this.pos));
                        }
                    }
                    case _:
                        throw "err";
                }

            /**
             * 
             */
            case EBlock(exprs):
                exprs[exprs.length - 1].evaluate(context);

            /**
             * 
             */
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
            
            /**
             * 
             */
            case EUnop(op, e):
                switch [op, e.evaluate(context).def] {
                    case [OpNot, EConstant(constant)]: switch constant {
                        case CBool(value): 
                            new Expr(
                                EConstant(CBool(!value)), 
                                Expr._T,
                                this.pos
                            );
                        case _: throw "err";
                    }
                    case [OpNeg, EConstant(constant)]: switch constant {
                        case CNumber(value): 
                            new Expr(
                                EConstant(CNumber(-value)), 
                                Expr._T,
                                this.pos
                            );
                        case _: throw "err";
                    }
                    case _: throw "err";
                }

            /**
             * 
             */
            case ETernary(econd, eif, eelse):
                switch econd.evaluate(context).def {
                    case EConstant(constant): {
                        switch constant {
                            case CBool(value): value
                                ? eif.evaluate(context)
                                : eelse.evaluate(context);
                            case _: throw "err";
                        }
                    }
                    case _: throw "err";
                }

            /**
             * 
             */
            case EBinop(type, e1, e2):
                switch type {
                    case ADD: e1.add(e2, context);
                    case SUBTRACT: e1.subtract(e2, context);
                    case WRAP: e1.wrap(e2, context);
                    case EQUALITY: e1.equals(e2, context);
                    case GREATER_THAN: e1.greaterThan(e2, context);
                    case SHIFT_LEFT: throw "SHIFT_LEFT";
                    case SHIFT_RIGHT: throw "SHIFT_RIGHT";
                }

            /**
             * 
             */
            case EParentheses(expr):
                expr.evaluate(context);

            /**
             * 
             */
            case EPrint(expr):
                var evalExpr = expr.evaluate(context);
                trace('${this.pos.file}:${this.pos.line}: ${evalExpr}\n');
                evalExpr;

            /**
             * 
             */
            case EFunction(_, _, _):
                this;
        }
    }

    public function toString() : String
    {
        return switch def {
            case EConstant(constant): switch constant {
                case CIdentifier(str): str;
                case CNumber(value): value + "";
                case CBool(value): value + "";
                case CScale(scale): scale.toString();
                case CKey(key): key.toString();
            }
            case EArrayDecl(values):
                values.map(v -> v.toString()) + "";
            case EFunction(identifier, params, _):
                '${identifier}(${params.join(",")}){...}';
            case EVar(identifier, expr):
                '${identifier}: ${expr}';
            case EBlock(exprs):
                '{...}';
            case EArray(e1, e2):
                throw "err";
            case EArrayFunc(e, op):
                throw "err";
            case EBinop(type, e1, e2):
                var op = switch type {
                    case ADD: '+';
                    case SUBTRACT: '-';
                    case WRAP: ':>';
                    case EQUALITY: '==';
                    case GREATER_THAN: ">";
                    case SHIFT_LEFT: '<<';
                    case SHIFT_RIGHT: '>>';
                }
                '${e1}${op}${e2}';
            case ECall(e, params):
                '${e}(${params.join(",")})';
            case EEnumParameter(e, def, index):
                throw "err";
            case EField(e, field):
                throw "err";
            case EIf(econd, ethen, eelse):
                throw "err";
            case EObjectDecl(fields):
                '${fields.mapToStringSmall()}';
            case EParentheses(expr):
                throw "err";
            case EPrint(expr):
                'print ${expr}';
            case ESwitch(e, cases, edef):
                throw "err";
            case ETernary(econd, eif, eelse):
                throw "err";
            case EUnop(op, e):
                throw "err";
        }
    }
}

typedef Ref<T> = {ref :T};

class ExprTools
{
    public static function createCNumber(value :Int, position :Position) : Expr
    {
        return new Expr(EConstant(CNumber(value)), Expr._T, position);
    }

    public static function createEObjectDecl(fields :Map<String, Expr>, position :Position) : Expr
    {
        return new Expr(EObjectDecl(fields), Expr._T, position);
    }

    public static function createEArrayDecl(values :Array<Expr>, position :Position) : Expr
    {
        return new Expr(EArrayDecl(values), Expr._T, position);
    }
}