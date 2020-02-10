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
#include "../type/type.h"
#include "../environment.h"

static Expr generate_temp_expr;

Expr *generate(Expr *expr, Environment *environment);

#include "evaluate_binop.h"
#include "evaluate_call.h"

Expr *generate_parentheses(Expr *expr, Environment *environment)
{
    return generate(expr->def.parentheses.e, environment);
}

Expr *generate_var(Expr *expr, Environment *environment)
{
    return generate(expr->def.var.e, environment);
}

Expr *generate_block(Expr *expr)
{
    return expr;
}

Expr *generate_function(Expr *expr)
{
    return expr;
}

Expr *generate_const(Expr *expr, Environment *environment)
{
    switch (expr->def.constant.type)
    {
    case TYPE_IDENTIFIER:
    {
        char *name = expr->def.constant.value.identifier;
        Expr *ref = environment_expr_from_name(environment, name);
        return generate(ref, environment);
    }
    case TYPE_NUMBER:
    case TYPE_RHYTHM:
    case TYPE_MELODY:
    case TYPE_HARMONY:
    case TYPE_STEPS:
    case TYPE_SCALE:
    case TYPE_KEY:
    case TYPE_SCALED_KEY:
    case TYPE_MUSIC:
    case TYPE_MONOMORPH:
        return expr;
    }
}

Expr *generate(Expr *expr, Environment *environment)
{
    switch (expr->def_type)
    {
    case E_CONST:
        return generate_const(expr, environment);
    case E_VAR:
        return generate_var(expr, environment);
    case E_CALL:
        return generate_call(expr);
    case E_BINOP:
        return generate_binop(expr, environment);
    case E_PAREN:
        return generate_parentheses(expr, environment);
    case E_BLOCK:
        return generate_block(expr);
    case E_FUNC:
        return generate_function(expr);
    }
}
