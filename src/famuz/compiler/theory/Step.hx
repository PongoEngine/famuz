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

package famuz.compiler.theory;
extern abstract Step(Int)
{
    inline public function new(val :Int)
    {
        this = val;
    }

    public inline static function step(val :Int) : Step return new Step(val);

    inline public function toInt() : Int return this;

    //Unary
    @:op(A++) static function increment(a :Step) : Step;
    @:op(A--) static function decrement(a :Step) : Step;

    //Arithmetic with Step
    @:op(A % B) static function modulo(a :Step, b :Step) : Step;
    @:op(A * B) static function multiplication(a :Step, b :Step) : Step;
    @:op(A / B) static inline function divideByStep(a :Step, b :Step) : Step return cast Math.floor(a.toInt()/b.toInt());
    @:op(A + B) static function addition(a :Step, b :Step) : Step;
    @:op(A - B) static function subtraction(a :Step, b :Step) : Step;

    //Comparison with Step
    @:op(A == B) static function equal(a :Step, b :Step) : Bool;
    @:op(A != B) static function notEqual(a :Step, b :Step) : Bool;
    @:op(A < B) static function lessThan(a :Step, b :Step) : Bool;
    @:op(A <= B) static function lessThanOrEqual(a :Step, b :Step) : Bool;
    @:op(A > B) static function greaterThan(a :Step, b :Step) : Bool;
    @:op(A >= B) static function greaterThanOrEqual(a :Step, b :Step) : Bool;
}