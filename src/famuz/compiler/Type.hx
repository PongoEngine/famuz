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

import famuz.compiler.Reserved.ReservedType;

@:using(famuz.compiler.Type.TypeTools)
enum Type
{
    TIdent;
    TNumber;
    TRhythm;
    TMelody;
    THarmony;
    TSteps;
    TScale;
    TKey;
    TScaledKey;
    TMusic;
    TMonomorph;
    TInvalid;
}

class TypeTools
{
    public static function add(a :Type, b :Type) : Type
    {
        return switch (a)
        {
            case TNumber:
                return b == TNumber ? TNumber : TInvalid;
            case TRhythm:
                return b == TSteps ? TMelody : TInvalid;
            case TMelody:
                return b == TScaledKey ? TMusic : TInvalid;
            case THarmony:
                return b == TScaledKey ? TMusic : TInvalid;
            case TSteps:
                return b == TRhythm ? TMelody : TInvalid;
            case TScale:
                return b == TKey ? TScaledKey : TInvalid;
            case TKey:
                return b == TScale ? TScaledKey : TInvalid;
            case TScaledKey:
                return (b == TMelody || b == THarmony) ? TMusic : TInvalid;
            case TIdent, TMusic, TMonomorph, TInvalid:
                return TInvalid;
        }
    }

    public static function getType(r :ReservedType) : Type
    {
        var type = switch (r) {
            case Harmony: THarmony;
            case Key: TKey;
            case Melody: TMelody;
            case Music: TMusic;
            case Number: TNumber;
            case Rhythm: TRhythm;
            case Scale: TScale;
            case ScaledKey: TScaledKey;
            case Steps: TSteps;
        }
        return type != null ? type : TInvalid;
    }

}