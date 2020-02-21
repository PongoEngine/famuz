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
extern abstract Octave(Int)
{
    inline public function new(val :Int)
    {
        this = val;
    }

    public inline static function octave(val :Int) : Octave return new Octave(val);

    inline public function toInt() : Int return this;

    //Unary
    @:op(A++) static function increment(a :Octave) : Octave;
    @:op(A--) static function decrement(a :Octave) : Octave;

    //Arithmetic with Octave
    @:op(A % B) static function modulo(a :Octave, b :Octave) : Octave;
    @:op(A * B) static function multiplication(a :Octave, b :Octave) : Octave;
    @:op(A / B) static inline function divideByOctave(a :Octave, b :Octave) : Octave return cast Math.floor(a.toInt()/b.toInt());
    @:op(A + B) static function addition(a :Octave, b :Octave) : Octave;
    @:op(A - B) static function subtraction(a :Octave, b :Octave) : Octave;

    //Comparison with Octave
    @:op(A == B) static function equal(a :Octave, b :Octave) : Bool;
    @:op(A != B) static function Octavequal(a :Octave, b :Octave) : Bool;
    @:op(A < B) static function lessThan(a :Octave, b :Octave) : Bool;
    @:op(A <= B) static function lessThanOrEqual(a :Octave, b :Octave) : Bool;
    @:op(A > B) static function greaterThan(a :Octave, b :Octave) : Bool;
    @:op(A >= B) static function greaterThanOrEqual(a :Octave, b :Octave) : Bool;
}