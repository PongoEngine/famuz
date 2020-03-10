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

import famuz.compiler.theory.Hit;
import famuz.compiler.theory.SteppedHit;
import famuz.compiler.theory.Step;
import famuz.compiler.theory.Scale;
import famuz.compiler.theory.Key;
import famuz.compiler.theory.NotedHit;

/**
 * 
 */
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
	ESwitch(e:Expr, cases:Array<Case>, edef:Null<Expr>); //TODO: add to parser

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
	 * A call e(params).
     */
    ECall(identifier :String, args :Array<Expr>);
    
    /**
	 * A block of expressions {exprs}.
     */
    EBlock(expr :Array<Expr>);
    
    /**
	 * Aif(econd) ethen else eelse expression.
     */
    EIf(econd:Expr, ethen:Expr, eelse:Expr); //TODO: add to parser

	/**
	 * An unary operator op on e:
     * 
	 * e++ (op = OpIncrement, postFix = true) e-- (op = OpDecrement, postFix = 
     * true) ++e (op = OpIncrement, postFix = false) --e (op = OpDecrement, 
     * postFix = false) -e (op = OpNeg, postFix = false) !e (op = OpNot, postFix 
     * = false) ~e (op = OpNegBits, postFix = false)
	 */
	EUnop(op:Unop, postFix:Bool, e:Expr); //TODO: add to parser
    
    /**
	 * A (econd) ? eif : eelse expression.
     */
    ETernary(econd:Expr, eif:Expr, eelse:Expr); //TODO: add to parser
    
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
    EFunction(identifier :String, params :Array<Parameter>, body :Expr);
}

/**
 * 
 */
enum Constant
{
    CIdentifier(str :String);
    CBool(value :Bool);
    CNumber(value :Int);
    CRhythm(hits :Array<Hit>, duration :Int);
    CMelody(notes :Array<SteppedHit>, duration :Int);
    CHarmony(melodies :Array<Array<SteppedHit>>);
    CSteps(steps :Array<Step>);
    CScale(type :Scale);
    CKey(key :Key);
    CScaledKey(scale :Scale, key :Key);
    CMusic(music :Array<NotedHit>);
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
	 * ++
	 */
    OpIncrement; 
    
    /**
	 * --
     */
    OpDecrement;
    
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
enum BinopType
{
    ADD;
    SHIFT_LEFT;
    SHIFT_RIGHT;
}

/**
 * 
 */
typedef Parameter =
{
    var name :String;
    var type :Type;
}