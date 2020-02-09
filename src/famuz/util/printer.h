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

#include <stdio.h>
#include "../compiler/expr/expr.h"
#include "../compiler/type/type.h"
#include "../compiler/position.h"

void print_position(Position *p)
{
    printf("%s: ", p->file);
}

void print_constant(char *str)
{
    printf("\n%s\n", str);
}

void print_hit(Hit *hit)
{
    int start = hit->start;
    int duration = hit->duration;
    printf("(%i,%i) ", start, duration);
}

void print_rhythm(Rhythm *rhythm)
{
    int length = rhythm->length;
    printf("[ ");
    for (size_t i = 0; i < length; i++)
    {
        print_hit(&rhythm->hits[i]);
    }
    printf("]");
}

void print(Expr *expr)
{
    if (expr == NULL)
        return;
    switch (expr->def_type)
    {
    case E_CONST:
    {
        switch (expr->def.constant.type)
        {
        case TYPE_IDENTIFIER:
            print_constant("TYPE_IDENTIFIER");
            break;
        case TYPE_RHYTHM:
        {
            print_position(expr->pos);
            print_rhythm(&expr->def.constant.value.rhythm);
            printf("\n");
            break;
        }
        case TYPE_HARMONY:
            print_constant("TYPE_HARMONY");
            break;
        case TYPE_STEPS:
            print_constant("TYPE_STEPS");
            break;
        case TYPE_MELODY:
            print_constant("TYPE_MELODY");
            break;
        case TYPE_SCALE:
            print_constant("TYPE_SCALE");
            break;
        case TYPE_KEY:
            print_constant("TYPE_KEY");
            break;
        case TYPE_SCALED_KEY:
            print_constant("TYPE_SCALED_KEY");
            break;
        case TYPE_MUSIC:
            print_constant("TYPE_MUSIC");
            break;
        case TYPE_CHORD:
            print_constant("TYPE_CHORD");
            break;
        case TYPE_MONOMORPH:
            print_constant("TYPE_MONOMORPH");
            break;
        }
        break;
    }
    case E_FUNC:
    {
        break;
    }
    default:
    {
        printf("\n\nWE FAILED IN OUR PRINT STATEMENT!\n\n");
        break;
    }
    }
}