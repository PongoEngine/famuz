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

import famuz.compiler.Scale;
import famuz.compiler.Key;

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
    var Number = "Number";
    var Rhythm = "Rhythm";
    var Melody = "Melody";
    var Harmony = "Harmony";
    var Steps = "Steps";
    var Scale = "Scale";
    var Key = "Key";
    var ScaledKey = "ScaledKey";
    var Music = "Music";
}

enum abstract ReservedScale(String) from String 
{
    var Major = "major";
    var NaturalMinor = "natural-minor";
    var MelodicMinor = "melodic-minor";
    var HarmonicMinor = "harmonic-minor";
}

enum abstract ReservedKey(String) from String 
{
    var C = "C";
    var C_SHARP = "C#";
    var Db = "Db";
    var D = "D";
    var D_SHARP = "D#";
    var Eb = "Eb";
    var E = "E";
    var F = "F";
    var F_SHARP = "F#";
    var Gb = "Gb";
    var G = "G";
    var G_SHARP = "G#";
    var Ab = "Ab";
    var A = "A";
    var A_SHARP = "A#";
    var Bb = "Bb";
    var B = "B";
}