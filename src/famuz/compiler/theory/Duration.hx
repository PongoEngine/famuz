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
import famuz.compiler.theory.Pulse.PPQN;

extern abstract Duration(Int)
{
    inline public function new(val :Int)
    {
        this = val;
    }

    public inline static function duration(val :Int) : Duration return new Duration(val);

    public static inline var WHOLE :Duration = cast PPQN * 4;
    public static inline var HALF :Duration = cast PPQN * 2;
    public static inline var QUARTER :Duration = cast PPQN * 1;
    public static inline var EIGHTH :Duration = cast 12;
    public static inline var SIXTEENTH :Duration = cast 6;
    public static inline var THIRTYSECONDTH :Duration = cast 3;

    inline public function toInt() : Int return this;

    //Unary
    @:op(A++) static function increment(a :Duration) : Duration;
    @:op(A--) static function decrement(a :Duration) : Duration;

    //Arithmetic with Duration
    @:op(A % B) static function modulo(a :Duration, b :Duration) : Duration;
    @:op(A * B) static function multiplication(a :Duration, b :Duration) : Duration;
    @:op(A / B) static inline function divideByDuration(a :Duration, b :Duration) : Duration return cast Math.floor(a.toInt()/b.toInt());
    @:op(A + B) static function addition(a :Duration, b :Duration) : Duration;
    @:op(A - B) static function subtraction(a :Duration, b :Duration) : Duration;
    @:op(A * B) static function multiplication(a :Duration, b :Int) : Duration;

    //Comparison with Duration
    @:op(A == B) static function equal(a :Duration, b :Duration) : Bool;
    @:op(A != B) static function notEqual(a :Duration, b :Duration) : Bool;
    @:op(A < B) static function lessThan(a :Duration, b :Duration) : Bool;
    @:op(A <= B) static function lessThanOrEqual(a :Duration, b :Duration) : Bool;
    @:op(A > B) static function greaterThan(a :Duration, b :Duration) : Bool;
    @:op(A >= B) static function greaterThanOrEqual(a :Duration, b :Duration) : Bool;

    //Arithmetic with Pulse
    @:op(A % B) static function modulo(a :Duration, b :Pulse) : Duration;
    @:op(A * B) static function multiplication(a :Duration, b :Pulse) : Duration;
    @:op(A / B) static inline function divideByPulse(a :Duration, b :Pulse) : Duration return cast Math.floor(a.toInt()/b.toInt());
    @:op(A + B) static function addition(a :Duration, b :Pulse) : Duration;
    @:op(A - B) static function subtraction(a :Duration, b :Pulse) : Duration;

    //Comparison with Pulse
    @:op(A == B) static function equal(a :Duration, b :Pulse) : Bool;
    @:op(A != B) static function notEqual(a :Duration, b :Pulse) : Bool;
    @:op(A < B) static function lessThan(a :Duration, b :Pulse) : Bool;
    @:op(A <= B) static function lessThanOrEqual(a :Duration, b :Pulse) : Bool;
    @:op(A > B) static function greaterThan(a :Duration, b :Pulse) : Bool;
    @:op(A >= B) static function greaterThanOrEqual(a :Duration, b :Pulse) : Bool;
}