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

#define RESERVED_CHORD_COUNT 1

typedef enum
{
    CHORD_TRIAD = 1,
} Chord;

static const char RESERVED_CHORD[RESERVED_CHORD_COUNT][16] = {
    "TRIAD",
};

Chord type_get_chord(char *str)
{
    for (int i = 0; i < RESERVED_CHORD_COUNT; i++)
    {
        if (strcmp(RESERVED_CHORD[i], str) == 0)
        {
            return (Chord)(i + 1);
        }
    }
    return (Chord)-1;
}

bool type_is_chord(char *str)
{
    return (int)type_get_chord(str) != -1;
}