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

#define SET_COLOR_ERROR printf("\033[0;31m");
#define SET_COLOR_CONST printf("\033[1;32m");
#define SET_COLOR_VAR printf("\033[01;33m");
#define SET_COLOR_CALL printf("\033[1;34m");
#define SET_COLOR_BINOP printf("\033[1;35m");
#define SET_COLOR_PAREN printf("\033[1;36m");
#define SET_COLOR_RESET printf("\033[0m");


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
    char *name = expr->def.var.identifier->def.constant.value.identifier;
    Expr *e = expr->def.var.e;
    ConstantType ret_type = expr->ret_type;
    printf("{\n%s  type: var;\n%s  ret: %i;\n%s  name:%s;\n%s  e: ", spacer, spacer, ret_type, spacer, name, spacer);
    expr_print(e, spaces + 2);
    SET_COLOR_VAR
    printf("\n%s}", spacer);
}

void expr_print_call(Expr *expr, int spaces)
{
    create_spacer;
    Expr *e = expr->def.call.e;
    Expr *params = expr->def.call.params;
    int params_length = expr->def.call.params_length;
    ConstantType ret_type = expr->ret_type;
    printf("{\n%s  type: call;\n%s  ret: %i;\n%s  e: ", spacer, spacer, ret_type, spacer);
    expr_print(e, spaces + 2);
    SET_COLOR_CALL
    printf("\n%s  params:", spacer);
    printf("\n%s    [", spacer);
    for (size_t i = 0; i < params_length; i++)
    {
        expr_print(&params[i], spaces + 4);
        SET_COLOR_CALL
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

void expr_print_paren(Expr *expr, int spaces)
{
    create_spacer;
    Expr *e = expr->def.parentheses.e;
    ConstantType ret_type = expr->ret_type;
    printf("{\n%s  type: parentheses;\n%s  ret: %i;\n%s  e: ", spacer, spacer, ret_type, spacer);
    expr_print(e, spaces + 2);
    SET_COLOR_PAREN
    printf("\n%s}", spacer);
}

void expr_print_binop(Expr *expr, int spaces)
{
    create_spacer;
    char *name = expr->def.var.identifier->def.constant.value.identifier;
    Expr *e1 = expr->def.binop.e1;
    BinopType type = expr->def.binop.type;
    Expr *e2 = expr->def.binop.e2;
    ConstantType ret_type = expr->ret_type;
    printf("{\n%s  type: binop;\n%s  ret: %i;\n%s  e1: ", spacer, spacer, ret_type, spacer);
    expr_print(e1, spaces + 2);
    SET_COLOR_BINOP
    printf("\n%s  e2: ", spacer);
    expr_print(e2, spaces + 2);
    SET_COLOR_BINOP
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
    ConstantType type = expr->def.constant.type;
    ConstantType ret_type = expr->ret_type;

    switch (type)
    {
    case C_IDENTIFIER:
    {
        char *identifier = expr->def.constant.value.identifier;
        printf("{\n%s  type: identifier;\n%s  ret: %i;\n%s  value: %s\n%s}", spacer, spacer, ret_type, spacer, identifier, spacer);
        break;
    }
    case C_RHYTHM:
    {
        Rhythm *rhythm = &(expr->def.constant.value.rhythm);
        printf("{\n%s  type: rhythm;\n%s  ret: %i;\n%s  value: ", spacer, spacer, ret_type, spacer);
        expr_print_rhythm(rhythm);
        printf("\n%s}", spacer);
        break;
    }
    case C_MELODY:
    {
        Melody *melody = &(expr->def.constant.value.melody);
        printf("{\n%s  type: melody;\n%s  ret: %i;\n%s  value: ", spacer, spacer, ret_type, spacer);
        // expr_print_rhythm(rhythm);
        printf("\n%s}", spacer);
        break;
    }
    case C_HARMONY:
    {
        Harmony *harmony = &(expr->def.constant.value.harmony);
        printf("{\n%s  type: harmony;\n%s  ret: %i;\n%s  value: ", spacer, spacer, ret_type, spacer);
        // expr_print_rhythm(rhythm);
        printf("\n%s}", spacer);
        break;
    }
    case C_STEPS:
    {
        Steps *steps = &(expr->def.constant.value.steps);
        printf("{\n%s  type: steps;\n%s  ret: %i;\n%s  value: ", spacer, spacer, ret_type, spacer);
        expr_print_steps(steps);
        printf("\n%s}", spacer);
        break;
    }
    case C_SCALE:
    {
        char *scale = expr->def.constant.value.scale;
        printf("{\n%s  type: scale;\n%s  ret: %i;\n%s  value: %s\n%s}", spacer, spacer, ret_type, spacer, scale, spacer);
        break;
    }
    case C_KEY:
    {
        char *key = expr->def.constant.value.key;
        printf("{\n%s  type: key;\n%s  ret: %i;\n%s  value: %s\n%s}", spacer, spacer, ret_type, spacer, key, spacer);
        break;
    }
    case C_SCALED_KEY:
    {
        char *key = expr->def.constant.value.key;
        printf("{\n%s  type: scaled-key;\n%s  ret: %i;\n%s  value: %s\n%s}", spacer, spacer, ret_type, spacer, key, spacer);
        break;
    }
    case C_MUSIC:
    {
        char *key = expr->def.constant.value.key;
        printf("{\n%s  type: music;\n%s  ret: %i;\n%s  value: %s\n%s}", spacer, spacer, ret_type, spacer, key, spacer);
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
    {
        SET_COLOR_CONST
        expr_print_const(expr, spaces);
        break;
    }
    case E_VAR:
    {
        SET_COLOR_VAR
        expr_print_var(expr, spaces);
        break;
    }
    case E_CALL:
    {
        SET_COLOR_CALL
        expr_print_call(expr, spaces);
        break;
    }
    case E_BINOP:
    {
        SET_COLOR_BINOP
        expr_print_binop(expr, spaces);
        break;
    }
    case E_PAREN:
    {
        SET_COLOR_PAREN
        expr_print_paren(expr, spaces);
        break;
    }
    }
    SET_COLOR_RESET
}