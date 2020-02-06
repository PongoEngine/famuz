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

#define RESERVED_TYPE_COUNT 10

#include "../settings.h"
#include "./type-scale.h"
#include "./type-identifier.h"
#include "./type-hit.h"
#include "./type-rhythm.h"
#include "./type-steps.h"
#include "./type-note.h"
#include "./type-melody.h"
#include "./type-harmony.h"
#include "./type-chord.h"
#include "./type-key.h"
#include "./type-scaled-key.h"
#include "./type-music.h"

typedef enum
{
    TYPE_IDENTIFIER = 1,
    TYPE_RHYTHM,
    TYPE_MELODY,
    TYPE_HARMONY,
    TYPE_STEPS,
    TYPE_SCALE,
    TYPE_KEY,
    TYPE_SCALED_KEY,
    TYPE_MUSIC,
    TYPE_CHORD
} Type;

static const char RESERVED_TYPE[RESERVED_TYPE_COUNT][16] = {
    "Identifier",
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

Type type_get_type(char *str)
{
    for (int i = 0; i < RESERVED_TYPE_COUNT; i++)
    {
        if (strcmp(RESERVED_TYPE[i], str) == 0)
        {
            return (Type)(i + 1);
        }
    }
    return (Type)-1;
}

bool type_is_type(char *str)
{
    return (int)type_get_type(str) != -1;
}