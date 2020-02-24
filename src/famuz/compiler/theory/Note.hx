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
using famuz.util.MathTools;

@:notNull
abstract Note(Int)
{
    inline public function new(val :Int)
    {
        this = val;
    }

    public static function create(root :Key, scale :Scale, step :Step, octave :Octave) : Note
    {
        var rangedStep = new Step(step.toInt().mod(scale.length()));
        var realOctave = new Octave(Math.floor(step.toInt() / scale.length())) + octave;
        var value = scale.steppedValue(root, rangedStep.toInt()) + 12 * realOctave.toInt();
        return new Note(value);
    }
    
    public function toInt() : Int return this;

    public function toString() : String
    {
        var v = this%12;
        var o = Math.floor(this/12);
        return PRETTY_NOTES[v]+o;
    }

    //Unary
    @:op(A++) static function increment(a :Note) : Note;
    @:op(A--) static function decrement(a :Note) : Note;

    //Arithmetic with Note
    @:op(A % B) static function modulo(a :Note, b :Note) : Note;
    @:op(A * B) static function multiplication(a :Note, b :Note) : Note;
    @:op(A / B) static inline function divideByNote(a :Note, b :Note) : Note return cast Math.floor(a.toInt()/b.toInt());
    @:op(A + B) static function addition(a :Note, b :Note) : Note;
    @:op(A - B) static function subtraction(a :Note, b :Note) : Note;

    //Comparison with Note
    @:op(A == B) static function equal(a :Note, b :Note) : Bool;
    @:op(A != B) static function notEqual(a :Note, b :Note) : Bool;
    @:op(A < B) static function lessThan(a :Note, b :Note) : Bool;
    @:op(A <= B) static function lessThanOrEqual(a :Note, b :Note) : Bool;
    @:op(A > B) static function greaterThan(a :Note, b :Note) : Bool;
    @:op(A >= B) static function greaterThanOrEqual(a :Note, b :Note) : Bool;

    private static var PRETTY_NOTES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
    // private static var PRETTY_NOTES = ["C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B"];
}