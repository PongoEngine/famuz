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

#define RESERVED_KEY_COUNT 17

typedef enum
{
    KEY_C = 1,
    KEY_C_SHARP,
    KEY_D_FLAT,
    KEY_D,
    KEY_D_SHARP,
    KEY_E_FLAT,
    KEY_E,
    KEY_F,
    KEY_F_SHARP,
    KEY_G_FLAT,
    KEY_G,
    KEY_G_SHARP,
    KEY_A_FLAT,
    KEY_A,
    KEY_A_SHARP,
    KEY_B_FLAT,
    KEY_B
} Key;

static const char RESERVED_KEY[RESERVED_KEY_COUNT][16] = {
    "C",
    "C#",
    "Db",
    "D",
    "D#",
    "Eb",
    "E",
    "F",
    "F#",
    "Gb",
    "G",
    "G#",
    "Ab",
    "A",
    "A#",
    "Bb",
    "B",
};

Key type_get_key(char *str)
{
    for (int i = 0; i < RESERVED_KEY_COUNT; i++)
    {
        if (strcmp(RESERVED_KEY[i], str) == 0)
        {
            return (Key)(i + 1);
        }
    }
    return (Key)-1;
}

bool type_is_key(char *str)
{
    return (int)type_get_key(str) != -1;
}