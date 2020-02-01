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
Expr *get_binop_expr(Exprs *exprs, ExprDefType def_type, Type constant_type, Position *p1, Position *p2);
Expr *create_expr(Exprs *exprs, ExprDefType def_type, Type constant_type, Position *pos);

Expr *generate_call(Expr *expr, Exprs *exprs)
{
    if (strcmp(expr->def.call.identifier, "arp") == 0)
    {
        Expr *param = &(expr->def.call.params[0]);
        if (assert_that(param->ret_type == TYPE_HARMONY, "WRONG PARAMS"))
        {
            Expr *harmony = generate(param, exprs);
            return harmony;
        }
        else
        {
            return NULL;
        }
    }
    else if (strcmp(expr->def.call.identifier, "chord") == 0)
    {
        Expr *chord = generate(&(expr->def.call.params[0]), exprs);
        Expr *m1 = generate(&(expr->def.call.params[1]), exprs);

        if (assert_that(chord->ret_type == TYPE_CHORD && m1->ret_type == TYPE_MELODY, "WRONG PARAMS"))
        {
            switch (chord->def.constant.value.chord)
            {
            case CHORD_TRIAD:
            {
                Expr *harmony = get_binop_expr(exprs, E_CONST, TYPE_HARMONY, chord->pos, m1->pos);
                harmony->def.constant.value.harmony.length = 3;
                harmony->def.constant.value.harmony.Melody[0] = &(m1->def.constant.value.melody);
                harmony->def.constant.value.harmony.Melody[1] = &(m1->def.constant.value.melody);
                harmony->def.constant.value.harmony.Melody[2] = &(m1->def.constant.value.melody);
                return harmony;
            }
            }
        }
        else
        {
            return NULL;
        }
    }
    else if (strcmp(expr->def.call.identifier, "main") == 0)
    {
        Expr *param = &(expr->def.call.params[0]);
        if (assert_that(param->ret_type == TYPE_MUSIC, "WRONG PARAMS"))
        {
            return generate(param, exprs);
        }
        else
        {
            return NULL;
        }
    }
    else
    {
        printf("INVALID");
        return expr;
    }
}