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
import famuz.compiler.expr.Expr;
import famuz.compiler.theory.Key;

/**
 * 
 */
@:using(famuz.compiler.expr.ExprDef.ExprDefTools)
enum ExprDef 
{
    /**
     * A constant.
     */
    EConstant(constant :Constant);

    /**
     * Represents a switch expression with related cases and an optional. 
     * default case if edef != null.
     */
    ESwitch(e:Expr, cases:Array<Case>, edef:Expr);

    /**
     * A object declaration.
     */
    EObjectDecl(fields :Map<String, Expr>);
    
    /**
     * Array access e1[e2].
     */
    EArray(e1:Expr, e2:Expr);
    
    /**
     * An array declaration [el].
     */
    EArrayDecl(values:Array<Expr>);

    /**
     * Field access on e.field.
     */
    EField(e:Expr, field:String);
    
    /**
     * Variable declaration.
     */
    EVar(identifier :String, expr :Expr);
    
    /**
     * A call e(args).
     */
    ECall(e :Expr, args :Array<Expr>);
    
    /**
     * A block of expressions {exprs}.
     */
    EBlock(exprs :Array<Expr>);
    
    /**
     * Aif(econd) ethen else eelse expression.
     */
    EIf(econd:Expr, ethen:Expr, eelse:Expr);

    /**
     * An unary operator op on e:
     * 
     * -e (op = OpNeg) !e (op = OpNot)
     */
    EUnop(op:Unop, e:Expr); //TODO: add to parser
    
    /**
     * A (econd) ? eif : eelse expression.
     */
    ETernary(econd:Expr, eif:Expr, eelse:Expr);
    
    /**
     * Binary operator e1 op e2.
     */
    EBinop(type :BinopType, e1 :Expr, e2 :Expr);
    
    /**
     * Parentheses (e).
     */
    EParentheses(expr :Expr);
    
    /**
     * Print print(e).
     */
    EPrint(expr :Expr);
    
    /**
     * A function declaration.
     */
    EFunction(identifier :String, params :Array<String>, body :Expr, scope :IContext);

    /**
     * A Native Function.
     */
    ENativeCall(funcName :String, args :Array<String>);
}

class ExprDefTools
{
    public static function getIdentifier(def :ExprDef) : String
    {
        return switch def {
            case EConstant(constant): switch constant {
                case CIdentifier(str): str;
                case _: throw "err";
            }
            case _: throw "err";
        }
    }

    public static function getBool(def :ExprDef) : Bool
    {
        return switch def {
            case EConstant(constant): switch constant {
                case CBool(value): value;
                case _: throw "err";
            }
            case _: throw "err";
        }
    }

    public static function getNumber(def :ExprDef) : Int
    {
        return switch def {
            case EConstant(constant): switch constant {
                case CNumber(value): value;
                case _: throw "err";
            }
            case _: throw "err";
        }
    }

    public static function getKey(def :ExprDef) : Key
    {
        return switch def {
            case EConstant(constant): switch constant {
                case CKey(type): type;
                case _: throw "err";
            }
            case _: throw "err";
        }
    }

    public static function getArrayDecl(def :ExprDef) : Array<Expr>
    {
        return switch def {
            case EArrayDecl(values): values;
            case _: throw "err";
        }
    }

    public static function getEObjectDecl(def :ExprDef) : Map<String, Expr>
    {
        return switch def {
            case EObjectDecl(fields): fields;
            case _: throw "err";
        }
    }
}

/**
 * 
 */
enum Constant
{
    CIdentifier(str :String);
    CString(str :String);
    CBool(value :Bool);
    CNumber(value :Int);
    CKey(key :Key);
}

/**
 * 
 */
typedef Case =
{
    /**
     * The expression of the case, if available.
     */
    expr:Expr,

    /**
     * The value expressions of the case.
     */
    values:Array<Expr>
}

/**
 * 
 */
enum Unop
{
    /**
     * !
     */
    OpNot;
    
    /**
     * -
     */
    OpNeg;
}

/**
 * 
 */
enum ArrayOp
{
    /**
     * push
     */
    OpPush(expr :Expr);

    /**
     * pop
     */
    OpPop;
}

/**
 * 
 */
enum BinopType
{
    ADD;
    SUBTRACT;
    SHIFT_LEFT;
    SHIFT_RIGHT;
    EQUALITY;
    GREATER_THAN;
}