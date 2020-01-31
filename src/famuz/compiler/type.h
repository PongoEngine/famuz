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

#include "./settings.h"

typedef char Identifier[SETTINGS_LEXEME_LENGTH];

typedef struct
{
    int start;
    int duration;
} Hit;

typedef struct
{
    Hit hits[SETTINGS_HIT_LENGTH];
    int length;
} Rhythm;

typedef struct
{
    int steps[SETTINGS_STEP_LENGTH];
    int length;
} Steps;

typedef struct
{
    Hit *hit;
    int step;
} Note;

typedef struct
{
    Note notes[SETTINGS_HIT_LENGTH];
    int length;
} Melody;

typedef struct
{
    Melody *Melody[SETTINGS_POLY];
    int length;
} Harmony;

typedef enum
{
    CHORD_TRIAD = 1,
} Chord;

typedef enum
{
    SCALE_MAJOR = 1,
    SCALE_NATURAL_MINOR,
    SCALE_MELODIC_MINOR,
    SCALE_HARMONIC_MINOR
} Scale;

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

typedef struct
{
    Scale *scale;
    Key *key;
} ScaledKey;

typedef struct
{
} Music;