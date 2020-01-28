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

#include "../expr/expr.h"
#include "../position.h"
#include "../../util/expr-printer.h"
#include "../../util/assert.h"

Expr *generate(Expr *expr, Exprs *exprs);

Expr *get_binop_expr(Exprs *exprs, ExprDefType def_type, Position *p1, Position *p2)
{
    Expr *expr = &(exprs->exprs[exprs->cur_index++]);
    expr->def_type = def_type;
    // position_union(p1, p2, expr->pos);
    return expr;
}

Expr *generate_binop_add_rhythm(Expr *rhythm, Expr *right, Exprs *exprs)
{
    switch (right->def.constant.type)
    {
    default:
        break;
    }
    return rhythm;
}

Expr *generate_binop_add_melody(Expr *melody, Expr *right, Exprs *exprs)
{
    switch (right->def.constant.type)
    {
    default:
        break;
    }
    return melody;
}

Expr *generate_binop_add_harmony(Expr *harmony, Expr *right, Exprs *exprs)
{
    switch (right->def.constant.type)
    {
    default:
        break;
    }
    return harmony;
}

Expr *generate_binop_add_steps(Expr *steps, Expr *right, Exprs *exprs)
{
    switch (right->def.constant.type)
    {
    case C_RHYTHM:
    {
        Rhythm *rhythm = &(right->def.constant.value.rhythm);
        Expr *expr = get_binop_expr(exprs, E_CONST, steps->pos, right->pos);
        expr->ret_type = C_MELODY;
        expr->def.constant.type = C_MELODY;
        Melody *melody = &(expr->def.constant.value.melody);
        melody->length = rhythm->length;
        return expr;
    }
    default:
        break;
    }
    return steps;
}

Expr *generate_binop_add_scale(Expr *scale, Expr *right, Exprs *exprs)
{
    switch (right->def.constant.type)
    {
    default:
        break;
    }
    return scale;
}

Expr *generate_binop_add_key(Expr *key, Expr *right, Exprs *exprs)
{
    switch (right->def.constant.type)
    {
    default:
        break;
    }
    return key;
}

Expr *generate_binop_add(Expr *left, Expr *right, Exprs *exprs)
{
    if (assert_that(left->def_type == E_CONST && right->def_type == E_CONST, "CAN ONLY DO ARITHMETIC ON CONSTANTS"))
    {
        switch (left->def.constant.type)
        {
        case C_IDENTIFIER:
        {
            printf("\n-CANNOT DO C_IDENTIFIER-\n");
            return left;
        }
        case C_RHYTHM:
            return generate_binop_add_rhythm(left, right, exprs);
        case C_MELODY:
            return generate_binop_add_melody(left, right, exprs);
        case C_HARMONY:
            return generate_binop_add_harmony(left, right, exprs);
        case C_STEPS:
            return generate_binop_add_steps(left, right, exprs);
        case C_SCALE:
            return generate_binop_add_scale(left, right, exprs);
        case C_KEY:
            return generate_binop_add_key(left, right, exprs);
        case C_SCALED_KEY:
        {
            printf("\n-CANNOT DO C_SCALED_KEY-\n");
            return left;
        }
        case C_MUSIC:
        {
            printf("\n-CANNOT DO C_MUSIC-\n");
            return left;
        }
        case C_CHORD:
        {
            printf("\n-CANNOT DO C_CHORD-\n");
            return left;
        }
        }
    }
    else
    {
        return left;
    }
}

Expr *generate_binop(Expr *expr, Exprs *exprs)
{
    Expr *e1 = expr->def.binop.e1;
    Expr *e2 = expr->def.binop.e2;
    BinopType type = expr->def.binop.type;

    Expr *left = generate(e1, exprs);
    Expr *right = generate(e2, exprs);

    return generate_binop_add(left, right, exprs);
}