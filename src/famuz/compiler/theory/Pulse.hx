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
extern abstract Pulse(Int)
{
    public static inline var PPQN = 24;
    
    inline public function new(val :Int)
    {
        this = val;
    }

    public inline static function pulse(val :Int) : Pulse return new Pulse(val);

    inline public function toInt() : Int return this;

    //Unary
    @:op(A++) static function increment(a :Pulse) : Pulse;
    @:op(A--) static function decrement(a :Pulse) : Pulse;

    //Arithmetic with Pulse
    @:op(A % B) static function modulo(a :Pulse, b :Pulse) : Pulse;
    @:op(A * B) static function multiplication(a :Pulse, b :Pulse) : Pulse;
    @:op(A / B) static inline function divideByPulse(a :Pulse, b :Pulse) : Pulse return cast Math.floor(a.toInt()/b.toInt());
    @:op(A + B) static function addition(a :Pulse, b :Pulse) : Pulse;
    @:op(A - B) static function subtraction(a :Pulse, b :Pulse) : Pulse;

    //Comparison with Pulse
    @:op(A == B) static function equal(a :Pulse, b :Pulse) : Bool;
    @:op(A != B) static function notEqual(a :Pulse, b :Pulse) : Bool;
    @:op(A < B) static function lessThan(a :Pulse, b :Pulse) : Bool;
    @:op(A <= B) static function lessThanOrEqual(a :Pulse, b :Pulse) : Bool;
    @:op(A > B) static function greaterThan(a :Pulse, b :Pulse) : Bool;
    @:op(A >= B) static function greaterThanOrEqual(a :Pulse, b :Pulse) : Bool;

    //Arithmetic with Duration
    @:op(A % B) static function modulo(a :Pulse, b :Duration) : Pulse;
    @:op(A * B) static function multiplication(a :Pulse, b :Duration) : Pulse;
    @:op(A / B) static inline function divideByDuration(a :Pulse, b :Duration) : Pulse return cast Math.floor(a.toInt()/b.toInt());
    @:op(A + B) static function addition(a :Pulse, b :Duration) : Pulse;
    @:op(A - B) static function subtraction(a :Pulse, b :Duration) : Pulse;

    //Comparison with Duration
    @:op(A == B) static function equal(a :Pulse, b :Duration) : Bool;
    @:op(A != B) static function notEqual(a :Pulse, b :Duration) : Bool;
    @:op(A < B) static function lessThan(a :Pulse, b :Duration) : Bool;
    @:op(A <= B) static function lessThanOrEqual(a :Pulse, b :Duration) : Bool;
    @:op(A > B) static function greaterThan(a :Pulse, b :Duration) : Bool;
    @:op(A >= B) static function greaterThanOrEqual(a :Pulse, b :Duration) : Bool;
}