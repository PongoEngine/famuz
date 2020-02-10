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

#include "evaluate.h"
#include "../expr/expr.h"
#include "../position.h"
#include "../environment.h"
#include "../stack.h"
#include "../../util/assert.h"
#include "../../util/printer.h"

Expr *prepare_binop_expr(Stack *stack, ExprDefType def_type, Type constant_type, Position *p1, Position *p2)
{
    generate_temp_expr.def_type = def_type;
    generate_temp_expr.ret_type = constant_type;
    generate_temp_expr.def.constant.type = constant_type;
//    position_union(p1, p2, generate_temp_expr.pos);
    generate_temp_expr.pos = p1;
    return &generate_temp_expr;
}

Expr *prepare_expr(Stack *stack, ExprDefType def_type, Type constant_type, Position *pos)
{
    generate_temp_expr.def_type = def_type;
    generate_temp_expr.ret_type = constant_type;
    generate_temp_expr.def.constant.type = constant_type;
    generate_temp_expr.pos = pos;
    return &generate_temp_expr;
}

Expr *evaluate_binop_add_harmony(Stack *stack, Expr *harmony, Expr *right)
{
    switch (right->def.constant.type)
    {
    case TYPE_SCALED_KEY:
    {
        Harmony *h = &(harmony->def.constant.value.harmony);
        ScaledKey *s_k = &(right->def.constant.value.scaled_key);
        Expr *expr = prepare_binop_expr(stack, E_CONST, TYPE_MUSIC, harmony->pos, right->pos);
        return expr;
    }
    default:
        assert_that(false, "WE FAILED HARMONY GENERATION");
        return harmony;
    }
}

Expr *evaluate_binop_add_melody(Stack *stack, Expr *melody, Expr *right)
{
    switch (right->def.constant.type)
    {
    case TYPE_SCALED_KEY:
    {
        Melody *m = &(melody->def.constant.value.melody);
        Expr *harmony = prepare_expr(stack, E_CONST, TYPE_HARMONY, melody->pos);
        harmony->def.constant.value.harmony.Melody[0] = m;
        harmony->def.constant.value.harmony.length = 1;
        return evaluate_binop_add_harmony(stack, harmony, right);
    }
    default:
        assert_that(false, "WE FAILED MELODY GENERATION");
        return melody;
    }
}

Expr *evaluate_binop_add_rhythm(Stack *stack, Expr *rhythm, Expr *right)
{
    switch (right->def.constant.type)
    {
    case TYPE_STEPS:
    {
        Rhythm *r = &(rhythm->def.constant.value.rhythm);
        Steps *s = &(right->def.constant.value.steps);
        Expr *expr_melody = prepare_binop_expr(stack, E_CONST, TYPE_MELODY, rhythm->pos, right->pos);
        expr_melody->def.constant.value.melody.length = r->length;
        for (size_t i = 0; i < r->length; i++)
        {
            size_t i_wrapped = i % s->length;
            expr_melody->def.constant.value.melody.notes[i].hit = &(r->hits[i]);
            expr_melody->def.constant.value.melody.notes[i].step = s->steps[i_wrapped];
        }

        return expr_melody;
    }
    default:
        assert_that(false, "WE FAILED RHYTHM GENERATION");
        return rhythm;
    }
}

Expr *evaluate_binop_add_scale(Stack *stack, Expr *scale, Expr *right)
{
    switch (right->def.constant.type)
    {
        case TYPE_KEY:
        {
            Scale *s = &(scale->def.constant.value.scale);
            Key *k = &(right->def.constant.value.key);
            Expr *expr = prepare_binop_expr(stack, E_CONST, TYPE_SCALED_KEY, scale->pos, right->pos);
            expr->def.constant.value.scaled_key.scale = s;
            expr->def.constant.value.scaled_key.key = k;
            return expr;
        }
        default:
            assert_that(false, "WE FAILED SCALE GENERATION");
            return scale;
    }
}

Expr *evaluate_binop_add_number(Stack *stack, Expr *number, Expr *right)
{
    switch (right->def.constant.type)
    {
        case TYPE_NUMBER:
        {
            Expr *expr = prepare_binop_expr(stack, E_CONST, TYPE_NUMBER, number->pos, right->pos);
            int a = number->def.constant.value.number;
            int b = right->def.constant.value.number;
            expr->def.constant.value.number = a + b;
            return expr;
        }
        default:
            assert_that(false, "WE FAILED NUMBER GENERATION");
            return number;
    }
}

Expr *evaluate_binop_add_key(Stack *stack, Expr *key, Expr *right)
{
    switch (right->def.constant.type)
    {
    case TYPE_SCALE:
    {
        return evaluate_binop_add_scale(stack, right, key);
    }
    default:
        assert_that(false, "WE FAILED KEY GENERATION");
        return key;
    }
}

Expr *evaluate_binop_add_steps(Stack *stack, Expr *steps, Expr *right)
{
    switch (right->def.constant.type)
    {
    case TYPE_RHYTHM:
    {
        return evaluate_binop_add_rhythm(stack, right, steps);
    }
    default:
        assert_that(false, "WE FAILED STEPS GENERATION");
        return steps;
    }
}

Expr *evaluate_binop_add_scaled_key(Stack *stack, Expr *scaled_key, Expr *right)
{
    switch (right->def.constant.type)
    {
    case TYPE_MELODY:
    {
        return evaluate_binop_add_melody(stack, right, scaled_key);
    }
    case TYPE_HARMONY:
    {
        return evaluate_binop_add_harmony(stack, right, scaled_key);
    }
    default:
        assert_that(false, "WE FAILED SCALED_KEY GENERATION");
        return scaled_key;
    }
}

Expr *evaluate_binop_add(Stack *stack, Expr *left, Expr *right)
{
    switch (left->def.constant.type)
    {
    case TYPE_IDENTIFIER:
    {
        assert_that(false, "\n-CANNOT DO TYPE_IDENTIFIER-\n");
        return left;
    }
    case TYPE_RHYTHM:
        return evaluate_binop_add_rhythm(stack, left, right);
    case TYPE_MELODY:
        return evaluate_binop_add_melody(stack, left, right);
    case TYPE_HARMONY:
        return evaluate_binop_add_harmony(stack, left, right);
    case TYPE_STEPS:
        return evaluate_binop_add_steps(stack, left, right);
    case TYPE_SCALE:
        return evaluate_binop_add_scale(stack, left, right);
    case TYPE_KEY:
        return evaluate_binop_add_key(stack, left, right);
    case TYPE_SCALED_KEY:
        return evaluate_binop_add_scaled_key(stack, left, right);
    case TYPE_NUMBER:
        return evaluate_binop_add_number(stack, left, right);
    case TYPE_MUSIC:
    {
        assert_that(false, "\n-CANNOT DO TYPE_MUSIC-\n");
        return left;
    }
    case TYPE_MONOMORPH:
    {
        assert_that(false, "\n-CANNOT DO TYPE_MONOMORPH-\n");
        return left;
    }
    }
}

Expr *evaluate_binop_shift_left(Expr *left, Expr *right)
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
            return left;
    }
}

int compare_hits(const void * a, const void * b)
{
    int l = ((Hit *)a)->start;
    int r = ((Hit *)b)->start;
    return (l - r);
}

Expr *evaluate_binop_shift_right(Stack *stack, Expr *left, Expr *right)
{
    switch (left->def.constant.type)
    {
        case TYPE_IDENTIFIER:
        case TYPE_RHYTHM: {
            switch (right->def.constant.type)
            {
                case TYPE_NUMBER:
                {
                    int shiftVal = right->def.constant.value.number;
                    Expr *expr = prepare_binop_expr(stack, E_CONST, TYPE_RHYTHM, left->pos, right->pos);
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
                    return expr;
                }
                default:
                    assert_that(false, "WE FAILED SHIFT RIGHT GENERATION");
                    return left;
            }
        }
        case TYPE_MELODY:
        case TYPE_HARMONY:
        case TYPE_STEPS:
        case TYPE_SCALE:
        case TYPE_KEY:
        case TYPE_SCALED_KEY:
        case TYPE_MUSIC:
        case TYPE_MONOMORPH:
        case TYPE_NUMBER:
            return left;
    }
}

Expr *evaluate_binop(Expr *expr, Environment *environment, Stack *stack)
{
    Expr *e1 = expr->def.binop.e1;
    Expr *e2 = expr->def.binop.e2;

    Expr *left = evaluate(e1, environment, stack);
    Expr *right = evaluate(e2, environment, stack);

    switch (expr->def.binop.type) {
        case B_ADD: return evaluate_binop_add(stack, left, right);
        case B_SHIFT_LEFT: return evaluate_binop_shift_left(left, right);
        case B_SHIFT_RIGHT: return evaluate_binop_shift_right(stack, left, right);
    }
}