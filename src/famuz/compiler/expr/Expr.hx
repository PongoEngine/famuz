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
    public var context :Context;
    public var def :ExprDef;
    public var pos :Position;

    public function new(context :Context, def :ExprDef, pos :Position) : Void
    {
        this.context = context;
        this.def = def;
        this.pos = pos;
    }

    public function evaluate() : Expr
    {
        return switch def {
            case EIntermediate(cb, expr):
                cb();
                expr.evaluate();
            /**
             * 
             */
            case EConstant(constant):
                switch constant {
                    case CIdentifier(str):
                        this.context.getExpr(str).evaluate();
                    case _:
                        this;
                }

            /**
             * 
             */
            case ESwitch(e, cases, edef): {
                for(case_ in cases) {
                    for(v in case_.values) {
                        if(v.equals(e)) {
                            return case_.expr.evaluate();
                        }
                    }
                }

                edef == null
                    ? throw "err"
                    : edef.evaluate();
            }

            /**
             * 
             */
            case EObjectDecl(_):
                this;

            /**
             * 
             */
            case EArray(e1, e2):
                switch [e1.evaluate().def, e2.evaluate().def] {
                    case [EArrayDecl(values), EConstant(constant)]: switch constant {
                        case CNumber(index): values[index].evaluate();
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
            case EField(e, field): {
                switch e.evaluate().def {
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
                expr.evaluate();

            /**
             * 
             */
            case ECall(identifier, args): {
                switch this.context.getExpr(identifier).evaluate().def {
                    case EFunction(identifier, params, body): {
                        if(args.length != params.length) {
                            throw "err";
                        }
                        var c = new Context();
                        c.parent = body.context.parent;
                        body.context.parent = c;
                        for(i in 0...params.length) {
                            c.addExpr(params[i], args[i]);
                        }
                        var evalExpr = body.evaluate();
                        body.context.parent = c.parent;
                        evalExpr;
                    }
                    case _:
                        throw "err";
                }
            }

            /**
             * 
             */
            case EBlock(exprs):
                exprs[exprs.length-1].evaluate();

            /**
             * 
             */
            case EIf(econd, ethen, eelse):
                switch econd.evaluate().def {
                    case EConstant(constant): switch constant {
                        case CBool(value): value
                            ? ethen.evaluate()
                            : eelse.evaluate();
                        case _: throw "err";
                    }
                    case _: throw "err";
                }
            
            /**
             * 
             */
            case EUnop(op, e):
                switch [op, e.evaluate().def] {
                    case [OpNot, EConstant(constant)]: switch constant {
                        case CBool(value): 
                            new Expr(
                                this.context, 
                                EConstant(CBool(!value)), 
                                Position.union(this.pos, this.pos)
                            );
                        case _: throw "err";
                    }
                    case [OpNeg, EConstant(constant)]: switch constant {
                        case CNumber(value): 
                            new Expr(
                                this.context, 
                                EConstant(CNumber(-value)), 
                                Position.union(this.pos, this.pos)
                            );
                        case _: throw "err";
                    }
                    case _: throw "err";
                }

            /**
             * 
             */
            case ETernary(econd, eif, eelse):
                switch econd.evaluate().def {
                    case EConstant(constant): {
                        switch constant {
                            case CBool(value): value
                                ? eif.evaluate()
                                : eelse.evaluate();
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
                    case ADD: e1.add(e2);
                    case SUBTRACT: e1.subtract(e2);
                    case SHIFT_LEFT: throw "SHIFT_LEFT";
                    case SHIFT_RIGHT: throw "SHIFT_RIGHT";
                }

            /**
             * 
             */
            case EParentheses(expr):
                expr.evaluate();

            /**
             * 
             */
            case EPrint(expr):
                var evalExpr = expr.evaluate();
                trace('${pos.file}:${pos.line}: ${evalExpr.toString()}\n');
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
                case CRhythm(hits, duration): throw "CRhythm";
                case CMelody(notes, duration): throw "CMelody";
                case CHarmony(melodies): throw "CHarmony";
                case CSteps(steps): throw "CSteps";
                case CScale(scale): scale.toString();
                case CKey(key): key.toString();
                case CScaledKey(scale, key): throw "CScaledKey";
                case CMusic(music): throw "CMusic";
            }
            case EArrayDecl(values):
                values.map(v -> v.evaluate().toString()) + "";
            case _:
                throw "err";
        }
    }
}