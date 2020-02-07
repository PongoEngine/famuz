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

#include "./generate.h"
#include "../expr/expr.h"
#include "../position.h"
#include "../environment.h"
#include "../../util/assert.h"

Expr *generate(Expr *expr, Environment *exprs);

Expr *prepare_binop_expr(ExprDefType def_type, Type constant_type, Position *p1, Position *p2)
{
    generate_temp_expr.def_type = def_type;
    generate_temp_expr.ret_type = constant_type;
    generate_temp_expr.def.constant.type = constant_type;
    position_union(p1, p2, generate_temp_expr.pos);
    return &generate_temp_expr;
}

Expr *prepare_expr(ExprDefType def_type, Type constant_type, Position *pos)
{
    generate_temp_expr.def_type = def_type;
    generate_temp_expr.ret_type = constant_type;
    generate_temp_expr.def.constant.type = constant_type;
    generate_temp_expr.pos = pos;
    return &generate_temp_expr;
}

Expr *generate_binop_add_harmony(Expr *harmony, Expr *right, Environment *exprs)
{
    switch (right->def.constant.type)
    {
    case TYPE_SCALED_KEY:
    {
        Harmony *h = &(harmony->def.constant.value.harmony);
        ScaledKey *s_k = &(right->def.constant.value.scaled_key);
        Expr *expr = prepare_binop_expr(E_CONST, TYPE_MUSIC, harmony->pos, right->pos);
        return expr;
    }
    default:
        assert_that(false, "WE FAILED HARMONY GENERATION");
        return harmony;
    }
}

Expr *generate_binop_add_melody(Expr *melody, Expr *right, Environment *exprs)
{
    switch (right->def.constant.type)
    {
    case TYPE_SCALED_KEY:
    {
        Melody *m = &(melody->def.constant.value.melody);
        Expr *harmony = prepare_expr(E_CONST, TYPE_HARMONY, melody->pos);
        harmony->def.constant.value.harmony.Melody[0] = m;
        harmony->def.constant.value.harmony.length = 1;
        return generate_binop_add_harmony(harmony, right, exprs);
    }
    default:
        assert_that(false, "WE FAILED MELODY GENERATION");
        return melody;
    }
}

Expr *generate_binop_add_rhythm(Expr *rhythm, Expr *right, Environment *exprs)
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

        return expr_melody;
    }
    default:
        assert_that(false, "WE FAILED RHYTHM GENERATION");
        return rhythm;
    }
}

Expr *generate_binop_add_scale(Expr *scale, Expr *right, Environment *exprs)
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
        return expr;
    }
    default:
        assert_that(false, "WE FAILED SCALE GENERATION");
        return scale;
    }
}

Expr *generate_binop_add_key(Expr *key, Expr *right, Environment *exprs)
{
    switch (right->def.constant.type)
    {
    case TYPE_SCALE:
    {
        return generate_binop_add_scale(right, key, exprs);
    }
    default:
        assert_that(false, "WE FAILED KEY GENERATION");
        return key;
    }
}

Expr *generate_binop_add_steps(Expr *steps, Expr *right, Environment *exprs)
{
    switch (right->def.constant.type)
    {
    case TYPE_RHYTHM:
    {
        return generate_binop_add_rhythm(right, steps, exprs);
    }
    default:
        assert_that(false, "WE FAILED STEPS GENERATION");
        return steps;
    }
}

Expr *generate_binop_add_scaled_key(Expr *scaled_key, Expr *right, Environment *exprs)
{
    switch (right->def.constant.type)
    {
    case TYPE_MELODY:
    {
        return generate_binop_add_melody(right, scaled_key, exprs);
    }
    case TYPE_HARMONY:
    {
        return generate_binop_add_harmony(right, scaled_key, exprs);
    }
    default:
        assert_that(false, "WE FAILED SCALED_KEY GENERATION");
        return scaled_key;
    }
}

Expr *generate_binop_add(Expr *left, Expr *right, Environment *exprs)
{
    if (assert_that(left->def_type == E_CONST && right->def_type == E_CONST, "CAN ONLY DO ARITHMETIC ON CONSTANTS"))
    {
        switch (left->def.constant.type)
        {
        case TYPE_IDENTIFIER:
        {
            assert_that(false, "\n-CANNOT DO TYPE_IDENTIFIER-\n");
            return left;
        }
        case TYPE_RHYTHM:
            return generate_binop_add_rhythm(left, right, exprs);
        case TYPE_MELODY:
            return generate_binop_add_melody(left, right, exprs);
        case TYPE_HARMONY:
            return generate_binop_add_harmony(left, right, exprs);
        case TYPE_STEPS:
            return generate_binop_add_steps(left, right, exprs);
        case TYPE_SCALE:
            return generate_binop_add_scale(left, right, exprs);
        case TYPE_KEY:
            return generate_binop_add_key(left, right, exprs);
        case TYPE_SCALED_KEY:
            return generate_binop_add_scaled_key(left, right, exprs);
        case TYPE_MUSIC:
        {
            assert_that(false, "\n-CANNOT DO TYPE_MUSIC-\n");
            return left;
        }
        case TYPE_CHORD:
        {
            assert_that(false, "\n-CANNOT DO C_CHORD-\n");
            return left;
        }
        }
    }
    else
    {
        return left;
    }
}

Expr *generate_binop(Expr *expr, Environment *exprs)
{
    Expr *e1 = expr->def.binop.e1;
    Expr *e2 = expr->def.binop.e2;
    BinopType type = expr->def.binop.type;

    Expr *left = generate(e1, exprs);
    Expr *right = generate(e2, exprs);

    return generate_binop_add(left, right, exprs);
}