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

#include <string.h>

typedef enum
{
    SCALE_MAJOR = 1,
    SCALE_NATURAL_MINOR,
    SCALE_MELODIC_MINOR,
    SCALE_HARMONIC_MINOR
} Scale;

static const char RESERVED_SCALE[4][16] = {
    "major",
    "natural-minor",
    "melodic-minor",
    "harmonic-minor",
};

Scale type_get_scale(char *str)
{
    for (int i = 0; i < 4; i++)
    {
        if (strcmp(RESERVED_SCALE[i], str) == 0)
        {
            return (Scale)(i + 1);
        }
    }
    return (Scale)-1;
}

bool type_is_scale(char *str)
{
    return (int)type_get_scale(str) != -1;
}