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

package famuz.compiler.parser;

import famuz.compiler.Token;

// https://github.com/HaxeFoundation/haxe/blob/development/src/syntax/parser.ml
// let precedence op =
// 	let left = true and right = false in
// 	match op with
// 	| OpIn -> 0, right
// 	| OpMod -> 1, left
// 	| OpMult | OpDiv -> 2, left
// 	| OpAdd | OpSub -> 3, left
// 	| OpShl | OpShr | OpUShr -> 4, left
// 	| OpOr | OpAnd | OpXor -> 5, left
// 	| OpEq | OpNotEq | OpGt | OpLt | OpGte | OpLte -> 6, left
// 	| OpInterval -> 7, left
// 	| OpBoolAnd -> 8, left
// 	| OpBoolOr -> 9, left
// 	| OpArrow -> 10, right
// 	| OpAssign | OpAssignOp _ -> 11, right

abstract Precedence(Int)
{
    public static var PRECEDENCE_ASSIGNMENT = new Precedence(1);
	public static var PRECEDENCE_TERNARY = new Precedence(2);
	public static var PRECEDENCE_PERIOD = new Precedence(2);
	public static var PRECEDENCE_ARRAY = new Precedence(2);
    public static var PRECEDENCE_SUM = new Precedence(3);
    public static var PRECEDENCE_SUBTRACT = new Precedence(3);
	public static var PRECEDENCE_CALL = new Precedence(4);

    public function new(val :Int) : Void
    {
        this = val;
    }
    
    public function toInt() : Int
    {
        return this;
    }

    public static function getPrecedence(scanner :TokenScanner) : Precedence
    {
        return switch (scanner.peek().type)
        {
            case TTPunctuator(type): {
                switch type {
                    case EQUALS:
                        PRECEDENCE_ASSIGNMENT;
                    case ADD, SHIFT_LEFT, SHIFT_RIGHT, WRAP:
                        PRECEDENCE_SUM;
                    case MINUS:
                        PRECEDENCE_SUBTRACT;
                    case LEFT_PARENTHESES:
                        PRECEDENCE_CALL;
                    case LEFT_BRACKET:
                        PRECEDENCE_ARRAY;
                    case PERIOD:
                        PRECEDENCE_PERIOD;
                    case QUESTION_MARK:
                        PRECEDENCE_TERNARY;
                    default:
                        new Precedence(0);
                }
            }
            default:
                new Precedence(0);
        }
    }

    //Comparison with Octave
    @:op(A < B) static function lessThan(a :Precedence, b :Precedence) : Bool;
}