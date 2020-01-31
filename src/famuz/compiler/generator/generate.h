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
#include "../../util/expr-printer.h"

Expr *generate(Expr *expr, Exprs *exprs);
Expr *create_expr(Exprs *exprs, ExprDefType def_type, ConstantType constant_type, Position *pos);

#include "./generator_binop.h"
#include "./generator_call.h"

Expr *generate_parentheses(Expr *expr, Exprs *exprs)
{
    return generate(expr->def.parentheses.e, exprs);
}

Expr *generate_var(Expr *expr, Exprs *exprs)
{
    return generate(expr->def.var.e, exprs);
}

Expr *generate_block(Expr *expr, Exprs *exprs)
{
    return expr;
}

Expr *generate_const(Expr *expr, Exprs *exprs)
{
    switch (expr->def.constant.type)
    {
    case C_IDENTIFIER:
    {
        char *name = expr->def.constant.value.identifier;
        Expr *expr = expr_from_name(exprs, name);
        return generate(expr, exprs);
    }
    case C_RHYTHM:
        return expr;
    case C_MELODY:
        return expr;
    case C_HARMONY:
        return expr;
    case C_STEPS:
        return expr;
    case C_SCALE:
        return expr;
    case C_KEY:
        return expr;
    case C_SCALED_KEY:
        return expr;
    case C_MUSIC:
        return expr;
    case C_CHORD:
        return expr;
    }
}

Expr *generate(Expr *expr, Exprs *exprs)
{
    switch (expr->def_type)
    {
    case E_CONST:
        return generate_const(expr, exprs);
    case E_VAR:
        return generate_var(expr, exprs);
    case E_CALL:
        return generate_call(expr, exprs);
    case E_BINOP:
        return generate_binop(expr, exprs);
    case E_PAREN:
        return generate_parentheses(expr, exprs);
    case E_BLOCK:
        return generate_block(expr, exprs);
    }
}

Expr *create_expr(Exprs *exprs, ExprDefType def_type, ConstantType constant_type, Position *pos)
{
    Expr *expr = &(exprs->exprs[exprs->cur_index++]);
    expr->def_type = def_type;
    expr->ret_type = constant_type;
    expr->def.constant.type = constant_type;
    expr->pos = pos;
    return expr;
}

Expr *get_binop_expr(Exprs *exprs, ExprDefType def_type, ConstantType constant_type, Position *p1, Position *p2)
{
    Expr *expr = &(exprs->exprs[exprs->cur_index++]);
    expr->def_type = def_type;
    expr->ret_type = constant_type;
    expr->def.constant.type = constant_type;
    // position_union(p1, p2, expr->pos);
    return expr;
}
