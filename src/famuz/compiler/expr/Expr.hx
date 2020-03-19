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
using famuz.compiler.expr.ExprBinops;

/**
 * 
 */
class Expr
{
    public var def :ExprDef;
    public var pos :Position;

    public function new(def :ExprDef, pos :Position) : Void
    {
        this.def = def;
        this.pos = pos;
    }

    public static function evaluate(node :Expr, context :IContext) : Expr
    {
        return switch node.def {
            /**
             * 
             */
            case EConstant(constant):
                switch constant {
                    case CIdentifier(str):
                        evaluate(context.getExpr(str), context);
                    case _:
                        node;
                }

            /**
             * 
             */
            case ESwitch(e, cases, edef): {
                for(case_ in cases) {
                    for(v in case_.values) {
                        if(v.equals(e, context)) {
                            return evaluate(case_.expr, context);
                        }
                    }
                }

                edef == null
                    ? throw "err"
                    : evaluate(edef, context);
            }

            /**
             * 
             */
            case EEnumParameter(e, type, index):
                node;

            /**
             * 
             */
            case EObjectDecl(_):
                node;

            /**
             * 
             */
            case EArray(e1, e2):
                switch [evaluate(e1, context).def, evaluate(e2, context).def] {
                    case [EArrayDecl(values), EConstant(constant)]: switch constant {
                        case CNumber(index): evaluate(values[index], context);
                        case _: throw "err";
                    }
                    case _: throw "err";
                }

            /**
             * 
             */
            case EArrayDecl(_):
                node;

            /**
             * 
             */
             case EArrayFunc(e, op):
                var evalArra = evaluate(e, context);
                switch [evalArra.def, op] {
                    case [EArrayDecl(values), OpPush(expr)]:
                        values.push(evaluate(expr, context));
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
                switch evaluate(e, context).def {
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
                evaluate(expr, context);

            /**
             * 
             */
            case ECall(e, args):
                switch evaluate(e, context).def {
                    case EFunction(ident, params, body, scope): {
                        if(args.length == params.length) {
                            var callScoped = scope.clone();
                            for(i in 0...args.length) {
                                callScoped.addVarFunc(params[i], args[i]);
                            }
                            var ctxInnerOuter = new ContextInnerOuter(callScoped, context);
                            evaluate(body, ctxInnerOuter);
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
                            new Expr(EFunction(ident + identParams, params.slice(args.length), body, ctxInnerOuter), null);
                        }
                        else {
                            Error.create(TooManyArgs(node.pos));
                        }
                    }
                    case _:
                        throw "err";
                }

            /**
             * 
             */
            case EBlock(exprs):
                evaluate(exprs[exprs.length - 1], context);

            /**
             * 
             */
            case EIf(econd, ethen, eelse):
                switch evaluate(econd, context).def {
                    case EConstant(constant): switch constant {
                        case CBool(value): value
                            ? evaluate(ethen, context)
                            : evaluate(eelse, context);
                        case _: throw "err";
                    }
                    case _: throw "err";
                }
            
            /**
             * 
             */
            case EUnop(op, e):
                switch [op, evaluate(e, context).def] {
                    case [OpNot, EConstant(constant)]: switch constant {
                        case CBool(value): 
                            new Expr(
                                EConstant(CBool(!value)), 
                                node.pos
                            );
                        case _: throw "err";
                    }
                    case [OpNeg, EConstant(constant)]: switch constant {
                        case CNumber(value): 
                            new Expr(
                                EConstant(CNumber(-value)), 
                                node.pos
                            );
                        case _: throw "err";
                    }
                    case _: throw "err";
                }

            /**
             * 
             */
            case ETernary(econd, eif, eelse):
                switch evaluate(econd, context).def {
                    case EConstant(constant): {
                        switch constant {
                            case CBool(value): value
                                ? evaluate(eif, context)
                                : evaluate(eelse, context);
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
                    case SHIFT_LEFT: throw "SHIFT_LEFT";
                    case SHIFT_RIGHT: throw "SHIFT_RIGHT";
                }

            /**
             * 
             */
            case EParentheses(expr):
                evaluate(expr, context);

            /**
             * 
             */
            case EPrint(expr):
                var evalExpr = evaluate(expr, context);
                trace('${node.pos.file}:${node.pos.line}: ${evalExpr}\n');
                evalExpr;

            /**
             * 
             */
            case EFunction(_, _, _):
                node;
        }
    }

    public function toString() : String
    {
        return switch def {
            case EConstant(constant): switch constant {
                case CIdentifier(str): str;
                case CNumber(value): value + "";
                case CBool(value): value + "";
                case CRhythm(d, hits, duration): '@${d} ${hits.map(h -> '(${h.start}, ${h.duration})')} | ${duration}';
                case CMelody(notes, duration): throw "CMelody";
                case CHarmony(melodies): throw "CHarmony";
                case CSteps(steps): throw "CSteps";
                case CScale(scale): scale.toString();
                case CKey(key): key.toString();
                case CScaledKey(scale, key): throw "CScaledKey";
                case CMusic(music): throw "CMusic";
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
                throw "err";
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