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

#include "../compiler/expr/expr.h"
#include "../compiler/type.h"

#define create_spacer                   \
    char spacer[spaces + 1];            \
    for (size_t i = 0; i < spaces; i++) \
    {                                   \
        spacer[i] = ' ';                \
    }                                   \
    spacer[spaces] = '\0';

void expr_print(Expr *expr, int spaces);

void expr_print_var(Expr *expr, int spaces)
{
    create_spacer;
    char *name = expr->expr.var.identifier->expr.constant.value.identifier;
    Expr *e = expr->expr.var.e;
    ConstantType type = expr->ret_type;
    printf("{\n%s  type: var;\n%s  ret: %i;\n%s  name:%s;\n%s  e: ", spacer, spacer, type, spacer, name, spacer);
    expr_print(e, spaces + 2);
    printf("\n%s}", spacer);
}

void expr_print_call(Expr *expr, int spaces)
{
    create_spacer;
    Expr *e = expr->expr.call.e;
    Expr *params = expr->expr.call.params;
    int params_length = expr->expr.call.params_length;
    printf("{\n%s  type: call;\n%s  e: ", spacer, spacer);
    expr_print(e, spaces + 2);
    printf("\n%s  params:", spacer);
    printf("\n%s    [", spacer);
    for (size_t i = 0; i < params_length; i++)
    {
        expr_print(&params[i], spaces + 4);
        if (i == params_length - 1)
        {
            printf("]");
        }
        else
        {
            printf(", ");
        }
    }

    printf("\n%s}", spacer);
}

void expr_print_binop(Expr *expr, int spaces)
{
    create_spacer;
    char *name = expr->expr.var.identifier->expr.constant.value.identifier;
    Expr *e1 = expr->expr.binop.e1;
    BinopType type = expr->expr.binop.type;
    Expr *e2 = expr->expr.binop.e2;
    printf("{\n%s  type: binop;\n%s  e1: ", spacer, spacer);
    expr_print(e1, spaces + 2);
    printf("\n%s  e2: ", spacer);
    expr_print(e2, spaces + 2);
    printf("\n%s}", spacer);
}

void expr_print_rhythm(Rhythm *rhythm)
{
    int length = rhythm->length;
    printf("[ ");
    for (size_t i = 0; i < length; i++)
    {
        int start = rhythm->hits[i].start;
        int duration = rhythm->hits[i].duration;
        printf("{%i,%i} ", start, duration);
    }
    printf("]");
}

void expr_print_steps(Steps *steps)
{
    int length = steps->length;
    printf("[ ");
    for (size_t i = 0; i < length; i++)
    {
        int step = steps->steps[i];
        printf("{%d} ", step);
    }
    printf("]");
}

void expr_print_const(Expr *expr, int spaces)
{
    create_spacer;
    ConstantType type = expr->expr.constant.type;

    switch (type)
    {
    case C_IDENTIFIER:
    {
        char *identifier = expr->expr.constant.value.identifier;
        printf("{\n%s  type: identifier\n%s  value: %s\n%s}", spacer, spacer, identifier, spacer);
        break;
    }
    case C_RHYTHM:
    {
        Rhythm *rhythm = &(expr->expr.constant.value.rhythm);
        printf("{\n%s  type: rhythm\n%s  value: ", spacer, spacer);
        expr_print_rhythm(rhythm);
        printf("\n%s}", spacer);
        break;
    }
    case C_MELODY:
    {
        char *melody = expr->expr.constant.value.melody;
        printf("{\n%s  type: melody\n%s  value: %s\n%s}", spacer, spacer, melody, spacer);
        break;
    }
    case C_HARMONY:
    {
        char *harmony = expr->expr.constant.value.harmony;
        printf("{\n%s  type: harmony\n%s  value: %s\n%s}", spacer, spacer, harmony, spacer);
        break;
    }
    case C_STEPS:
    {
        Steps *steps = &(expr->expr.constant.value.steps);
        printf("{\n%s  type: steps\n%s  value: ", spacer, spacer);
        expr_print_steps(steps);
        printf("\n%s}", spacer);
        break;
    }
    case C_SCALE:
    {
        char *scale = expr->expr.constant.value.scale;
        printf("{\n%s  type: scale\n%s  value: %s\n%s}", spacer, spacer, scale, spacer);
        break;
    }
    case C_KEY:
    {
        char *key = expr->expr.constant.value.key;
        printf("{\n%s  type: key\n%s  value: %s\n%s}", spacer, spacer, key, spacer);
        break;
    }
    }
}

void expr_print(Expr *expr, int spaces)
{
    if (expr == NULL)
        return;
    switch (expr->def_type)
    {
    case E_CONST:
        expr_print_const(expr, spaces);
        break;
    case E_VAR:
        expr_print_var(expr, spaces);
        break;
    case E_CALL:
        expr_print_call(expr, spaces);
        break;
    case E_BINOP:
        expr_print_binop(expr, spaces);
        break;
    }
}
