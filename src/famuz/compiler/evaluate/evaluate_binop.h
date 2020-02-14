#pragma once

/*
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

#include <compiler/expr/expr-constant.h>
#include "evaluate.h"
#include "../expr/expr.h"
#include "../position.h"
#include "../environment.h"
#include "../stack.h"
#include "../../util/assert.h"
#include "../../util/printer.h"

static Position p;
static Expr temp;

int compare_hits(const void * a, const void * b)
{
    int l = ((Hit *)a)->start;
    int r = ((Hit *)b)->start;
    return (l - r);
}

Expr *prepare_binop_expr(ExprDefType def_type, Type constant_type, Position *p1, Position *p2)
{
    temp.def_type = def_type;
    temp.ret_type = constant_type;
    temp.def.constant.type = constant_type;
    temp.pos = &p;
    position_union(p1, p2, temp.pos);
    return &temp;
}

Expr *prepare_expr(ExprDefType def_type, Type constant_type, Position *pos)
{
    temp.def_type = def_type;
    temp.ret_type = constant_type;
    temp.def.constant.type = constant_type;
    temp.pos = pos;
    return &temp;
}

void evaluate_binop_add_harmony(Stack *stack, Expr *harmony, Expr *right)
{
    switch (right->def.constant.type)
    {
        case TYPE_SCALED_KEY:
        {
            Harmony *h = &(harmony->def.constant.value.harmony);
            ScaledKey *s_k = &(right->def.constant.value.scaled_key);
            Expr *expr = prepare_binop_expr(E_CONST, TYPE_MUSIC, harmony->pos, right->pos);
            stack_push(stack, expr);
            break;
        }
        default:
            assert_that(false, "WE FAILED HARMONY GENERATION");
            break;
    }
}

void evaluate_binop_add_rhythm(Stack *stack, Expr *rhythm, Expr *right)
{
    switch (right->def.constant.type)
    {
        case TYPE_STEPS:
        {
            Rhythm *r = &(rhythm->def.constant.value.rhythm);
            Steps *s = &(right->def.constant.value.steps);
            Expr *expr_melody = prepare_binop_expr(E_CONST, TYPE_MELODY, rhythm->pos, right->pos);
            expr_melody->def.constant.value.melody.length = r->length;
            for (size_t i = 0; i < r->length; i++)
            {
                size_t i_wrapped = i % s->length;
                expr_melody->def.constant.value.melody.notes[i].hit = &(r->hits[i]);
                expr_melody->def.constant.value.melody.notes[i].step = s->steps[i_wrapped];
            }

            stack_push(stack, expr_melody);
            break;
        }
        default:
            assert_that(false, "WE FAILED RHYTHM GENERATION");
            break;
    }
}

void evaluate_binop_add_scale(Stack *stack, Expr *scale, Expr *right)
{
    switch (right->def.constant.type)
    {
        case TYPE_KEY:
        {
            Scale *s = &(scale->def.constant.value.scale);
            Key *k = &(right->def.constant.value.key);
            Expr *expr = prepare_binop_expr(E_CONST, TYPE_SCALED_KEY, scale->pos, right->pos);
            expr->def.constant.value.scaled_key.scale = s;
            expr->def.constant.value.scaled_key.key = k;
            stack_push(stack, expr);
            break;
        }
        default:
            assert_that(false, "WE FAILED SCALE GENERATION");
            break;
    }
}

void evaluate_binop_add_number(Stack *stack, Expr *number, Expr *right)
{
    switch (right->def.constant.type)
    {
        case TYPE_NUMBER:
        {
            Expr *expr = prepare_binop_expr(E_CONST, TYPE_NUMBER, number->pos, right->pos);
            int a = number->def.constant.value.number;
            int b = right->def.constant.value.number;
            expr->def.constant.value.number = a + b;
            stack_push(stack, expr);
            break;
        }
        default:
            assert_that(false, "WE FAILED NUMBER GENERATION");
            break;
    }
}

void evaluate_binop_add_key(Stack *stack, Expr *key, Expr *right)
{
    switch (right->def.constant.type)
    {
        case TYPE_SCALE:
        {
            evaluate_binop_add_scale(stack, right, key);
            break;
        }
        default:
            assert_that(false, "WE FAILED KEY GENERATION");
            break;
    }
}

void evaluate_binop_add_steps(Stack *stack, Expr *steps, Expr *right)
{
    switch (right->def.constant.type)
    {
        case TYPE_RHYTHM:
        {
            evaluate_binop_add_rhythm(stack, right, steps);
            break;
        }
        default:
            assert_that(false, "WE FAILED STEPS GENERATION");
            break;
    }
}

void evaluate_binop_add_scaled_key(Stack *stack, Expr *scaled_key, Expr *right)
{
    switch (right->def.constant.type)
    {
        case TYPE_MELODY:
        {
            assert_that(false, "WE FAILED TYPE_MELODY GENERATION");
            break;
        }
        case TYPE_HARMONY:
        {
            evaluate_binop_add_harmony(stack, right, scaled_key);
            break;
        }
        default:
            assert_that(false, "WE FAILED SCALED_KEY GENERATION");
            break;
    }
}

void evaluate_binop_add(Stack *stack, Expr *left, Expr *right)
{
    switch (left->def.constant.type)
    {
        case TYPE_IDENTIFIER:
        {
            assert_that(false, "\n-CANNOT DO TYPE_IDENTIFIER-\n");
            break;
        }
        case TYPE_RHYTHM:
            evaluate_binop_add_rhythm(stack, left, right);
            break;
        case TYPE_MELODY:
            assert_that(false, "\n-CANNOT DO TYPE_MELODY-\n");
            break;
        case TYPE_HARMONY:
            evaluate_binop_add_harmony(stack, left, right);
            break;
        case TYPE_STEPS:
            evaluate_binop_add_steps(stack, left, right);
            break;
        case TYPE_SCALE:
            evaluate_binop_add_scale(stack, left, right);
            break;
        case TYPE_KEY:
            evaluate_binop_add_key(stack, left, right);
            break;
        case TYPE_SCALED_KEY:
            evaluate_binop_add_scaled_key(stack, left, right);
            break;
        case TYPE_NUMBER:
            evaluate_binop_add_number(stack, left, right);
            break;
        case TYPE_MUSIC:
        {
            assert_that(false, "\n-CANNOT DO TYPE_MUSIC-\n");
            break;
        }
        case TYPE_MONOMORPH:
        {
            assert_that(false, "\n-CANNOT DO TYPE_MONOMORPH-\n");
            break;
        }
    }
}

void evaluate_binop_shift_left(Stack *stack, Expr *left, Expr *right)
{
    switch (left->def.constant.type)
    {
        case TYPE_IDENTIFIER:
        case TYPE_RHYTHM:
        case TYPE_MELODY:
        case TYPE_HARMONY:
        case TYPE_STEPS:
        case TYPE_SCALE:
        case TYPE_KEY:
        case TYPE_SCALED_KEY:
        case TYPE_MUSIC:
        case TYPE_MONOMORPH:
        case TYPE_NUMBER:
            break;
    }
}

void evaluate_binop_shift_right(Stack *stack, Expr *left, Expr *right)
{
    switch (left->def.constant.type)
    {
        case TYPE_IDENTIFIER:
            break;
        case TYPE_RHYTHM: {
            switch (right->def.constant.type)
            {
                case TYPE_NUMBER:
                {
                    int shiftVal = right->def.constant.value.number;
                    Expr *expr = prepare_binop_expr(E_CONST, TYPE_RHYTHM, left->pos, right->pos);
                    Rhythm *r = &left->def.constant.value.rhythm;
                    int length = r->length;
                    int duration = r->duration;
                    Rhythm *new_r = &expr->def.constant.value.rhythm;
                    for (int i = 0; i < length; i++) {
                        new_r->hits[i].start = (r->hits[i].start + shiftVal) % duration;
                        new_r->hits[i].duration = r->hits[i].duration;
                    }
                    qsort(new_r->hits, length, sizeof(Hit), compare_hits); //TODO: simplify sorting
                    new_r->length = length;
                    new_r->duration = duration;
                    stack_push(stack, expr);
                    break;
                }
                default:
                    assert_that(false, "WE FAILED SHIFT RIGHT TYPE_RHYTHM GENERATION");
                    break;
            }
            break;
        }
        case TYPE_MELODY:
        case TYPE_HARMONY:
            break;
        case TYPE_STEPS: {
            switch (right->def.constant.type)
            {
                case TYPE_NUMBER:
                {
                    int shiftVal = right->def.constant.value.number;
                    Expr *expr = prepare_binop_expr(E_CONST, TYPE_STEPS, left->pos, right->pos);
                    Steps *s = &left->def.constant.value.steps;
                    int length = s->length;
                    Steps *new_s = &expr->def.constant.value.steps;
                    for (int i = 0; i < length; i++) {
                        new_s->steps[i] = (s->steps[i] + shiftVal);
                    }
                    new_s->length = length;
                    stack_push(stack, expr);
                    break;
                }
                default:
                    assert_that(false, "WE FAILED SHIFT RIGHT TYPE_STEPS GENERATION");
                    break;
            }
            break;
        }
        case TYPE_SCALE:
        case TYPE_KEY:
        case TYPE_SCALED_KEY:
        case TYPE_MUSIC:
        case TYPE_MONOMORPH:
        case TYPE_NUMBER:
            break;
    }
}

void evaluate_binop(Environments *environments, int env_id, ExprLocation *loc, Stack *stack) {
    Expr *expr = environments_get_expr(environments, loc);
    //pushing params to stack in reverse
    evaluate(environments, env_id, expr->def.binop.expr_loc2, stack);
    evaluate(environments, env_id, expr->def.binop.expr_loc1, stack);

    Expr *left = stack_pop(stack);
    Expr *right = stack_pop(stack);

    switch (expr->def.binop.type) {
        case B_ADD:
            evaluate_binop_add(stack, left, right);
            break;
        case B_SHIFT_LEFT:
            evaluate_binop_shift_left(stack, left, right);
            break;
        case B_SHIFT_RIGHT:
            evaluate_binop_shift_right(stack, left, right);
            break;
    }
}