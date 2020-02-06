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

#include <stdbool.h>
#include <string.h>
#include "./type/type.h"

#define RESERVED_WORD_COUNT 33

static const char RESERVED[RESERVED_WORD_COUNT][16] = {
    "func",  //0
    "TRIAD", //1
    "C",     //2
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
    "Identifier", //RESERVED_TYPE_INDEX
    "Rhythm",
    "Melody",
    "Harmony",
    "Steps",
    "Scale",
    "Key",
    "ScaledKey",
    "Music",
    "Chord",
};

Type reserved_get_type(char *str)
{
    for (size_t i = RESERVED_TYPE_INDEX; i < RESERVED_WORD_COUNT; i++)
    {
        if (strcmp(RESERVED[i], str) == 0)
        {
            return i;
        }
    }
    return -1;
}

bool reserved_is_type(char *str)
{
    return (int)reserved_get_type(str) != -1;
}

static const char R_FUNC[] = "func";
static const char R_TRIAD[] = "TRIAD";

static const char R_C[] = "C";
static const char R_C_SHARP[] = "C#";
static const char R_D_FLAT[] = "Db";
static const char R_D[] = "D";
static const char R_D_SHARP[] = "D#";
static const char R_E_FLAT[] = "Eb";
static const char R_E[] = "E";
static const char R_F[] = "F";
static const char R_F_SHARP[] = "F#";
static const char R_G_FLAT[] = "Gb";
static const char R_G[] = "G";
static const char R_G_SHARP[] = "G#";
static const char R_A_FLAT[] = "Ab";
static const char R_A[] = "A";
static const char R_A_SHARP[] = "A#";
static const char R_B_FLAT[] = "Bb";
static const char R_B[] = "B";