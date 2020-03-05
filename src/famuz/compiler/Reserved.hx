package famuz.compiler;

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

import famuz.compiler.theory.Scale;
import famuz.compiler.theory.Key;

class Reserved
{
    public static function isFunc(str :String) : Bool
    {
        return str == "func";
    }

    public static function isPrint(str :String) : Bool
    {
        return str == "print";
    }

    public static function isScale(str :String) : Bool
    {
        return ScaleTools.getScale(str) != INVALID;
    }

    public static function isKey(str :String) : Bool
    {
        var key = KeyTools.getKey(str);
        return key != INVALID;
    }
}

enum abstract ReservedType(String) from String 
{
    var ReservedNumber = "Number";
    var ReservedBool = "Bool";
    var ReservedRhythm = "Rhythm";
    var ReservedMelody = "Melody";
    var ReservedScale = "Scale";
    var ReservedKey = "Key";
    var ReservedScaledKey = "ScaledKey";
    var ReservedMusic = "Music";
}

enum abstract ReservedScale(String) from String 
{
    var ReservedMajor = "major";
    var ReservedNaturalMinor = "natural-minor";
    var ReservedMelodicMinor = "melodic-minor";
    var ReservedHarmonicMinor = "harmonic-minor";
    var ReservedChromatic = "chromatic";
}

enum abstract ReservedKey(String) from String 
{
    var ReservedC = "C";
    var ReservedC_SHARP = "C#";
    var ReservedDb = "Db";
    var ReservedD = "D";
    var ReservedD_SHARP = "D#";
    var ReservedEb = "Eb";
    var ReservedE = "E";
    var ReservedF = "F";
    var ReservedF_SHARP = "F#";
    var ReservedGb = "Gb";
    var ReservedG = "G";
    var ReservedG_SHARP = "G#";
    var ReservedAb = "Ab";
    var ReservedA = "A";
    var ReservedA_SHARP = "A#";
    var ReservedBb = "Bb";
    var ReservedB = "B";
}