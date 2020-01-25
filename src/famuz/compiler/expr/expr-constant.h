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

typedef enum
{
    C_IDENTIFIER = 1,
    C_RHYTHM,
    C_MELODY,
    C_HARMONY,
    C_STEPS,
    C_SCALE,
    C_KEY,
    C_SCALED_KEY
} ConstantType;

typedef struct
{
    union {
        Identifier identifier;
        Rhythm rhythm;
        Melody melody;
        Harmony harmony;
        Steps steps;
        Scale scale;
        Key key;
    } value;
    ConstantType type;
} Constant;

ConstantType constant_type_add(ConstantType a, ConstantType b)
{
    switch (a)
    {
    case C_IDENTIFIER:
        return -1;
    case C_RHYTHM:
        return b == C_STEPS ? C_MELODY : -1;
    case C_MELODY:
        return -1;
    case C_HARMONY:
        return -1;
    case C_STEPS:
        return b == C_RHYTHM ? C_MELODY : -1;
    case C_SCALE:
        return b == C_KEY ? C_SCALED_KEY : -1;
    case C_KEY:
        return b == C_SCALE ? C_SCALED_KEY : -1;
    case C_SCALED_KEY:
        return -1;
    }
    return -1;
}
