#pragma once

/*
 * MIT License
 *
 * Copyright (c) 2019 Jeremy Meltingtallow
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

typedef struct
{
    union {
        Identifier identifier;
        Number number;
        Rhythm rhythm;
        Melody melody;
        Harmony harmony;
        Steps steps;
        Scale scale;
        Key key;
        ScaledKey scaled_key;
        Music music;
    } value;
    Type type;
} EConstant;

Type constant_type_add(Type a, Type b)
{
    switch (a)
    {
    case TYPE_IDENTIFIER:
        return -1;
    case TYPE_NUMBER:
        return b == TYPE_NUMBER ? TYPE_NUMBER : -1;
    case TYPE_RHYTHM:
        return b == TYPE_STEPS ? TYPE_MELODY : -1;
    case TYPE_MELODY:
        return b == TYPE_SCALED_KEY ? TYPE_MUSIC : -1;
    case TYPE_HARMONY:
        return b == TYPE_SCALED_KEY ? TYPE_MUSIC : -1;
    case TYPE_STEPS:
        return b == TYPE_RHYTHM ? TYPE_MELODY : -1;
    case TYPE_SCALE:
        return b == TYPE_KEY ? TYPE_SCALED_KEY : -1;
    case TYPE_KEY:
        return b == TYPE_SCALE ? TYPE_SCALED_KEY : -1;
    case TYPE_SCALED_KEY:
        return (b == TYPE_MELODY || b == TYPE_HARMONY) ? TYPE_MUSIC : -1;
        ;
    case TYPE_MUSIC:
        return -1;
    case TYPE_MONOMORPH:
        return -1;
    }
    return -1;
}