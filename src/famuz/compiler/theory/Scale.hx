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
import famuz.compiler.theory.Key;
import famuz.compiler.Reserved.ReservedScale;

@:notNull
@:forward(length)
abstract Scale(Array<Note>)
{
    public function new(root :Key, type :ScaleType) : Void
    {
        this = switch (type) {
            case MAJOR: fromSteps(root, [WHOLE,WHOLE,HALF,WHOLE,WHOLE,WHOLE]);
            case NATURAL_MINOR: fromSteps(root, [WHOLE,HALF,WHOLE,WHOLE,HALF,WHOLE]);
            case HARMONIC_MINOR: fromSteps(root, [WHOLE,HALF,WHOLE,WHOLE,HALF,WHOLE+HALF]);
            case MELODIC_MINOR: fromSteps(root, [WHOLE,HALF,WHOLE,WHOLE,WHOLE,WHOLE]);
            case CHROMATIC: fromSteps(root, [HALF,HALF,HALF,HALF,HALF,HALF,HALF,HALF,HALF,HALF,HALF]);
            case INVALID: [];
        }
    }

    public function getNote(step :Step, octave :Octave) : Note
    {
        var step = step.toInt();
        var octave = octave.toInt();

        var offsetOctave :Int = Math.floor(step / this.length);
        var rangedStep :Int = step - (offsetOctave*this.length);
        var note :Int = this[rangedStep].toInt() + (12 * (offsetOctave+octave));

        return new Note(note);
    }

    private static function fromSteps(root :Key, steps :Array<Interval>) : Array<Note>
    {
        var root = root.toInt();
        var arra = [new Note(root)];
        for(step in steps) {
            root = root + step;
            arra.push(new Note(root));
        }
        return arra;
    }
}

@:enum
@:using(famuz.compiler.theory.Scale.ScaleTools)
abstract ScaleType(Int)
{
    var MAJOR = 0;
    var NATURAL_MINOR = 1;
    var HARMONIC_MINOR = 2;
    var MELODIC_MINOR = 3;
    var CHROMATIC = 4;
    var INVALID = 5;
}

@:enum
abstract Interval(Int) to Int
{
    var HALF = 1;
    var WHOLE = 2;

    @:op(A + B) static function addition(a :Interval, b :Interval) : Interval;
}

class ScaleTools
{
    public static function toString(scale :ScaleType) : String
    {
        return switch scale {
            case MAJOR: "major";
            case NATURAL_MINOR: "natural-minor";
            case MELODIC_MINOR: "melodic-minor";
            case HARMONIC_MINOR: "harmonic-minor";
            case CHROMATIC: "chomatic";
            case INVALID: "Invalid";
        }
    }

    public static function getScale(reserved :ReservedScale) : ScaleType
    {
        var scale = switch reserved {
            case ReservedMajor: MAJOR;
            case ReservedNaturalMinor: NATURAL_MINOR;
            case ReservedMelodicMinor: MELODIC_MINOR;
            case ReservedHarmonicMinor: HARMONIC_MINOR;
            case ReservedChromatic: CHROMATIC;
        }
        return scale != null ? scale : INVALID;
    }
}