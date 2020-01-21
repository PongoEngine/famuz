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

#include "./position.h"
#include "./settings.h"

typedef struct Expr Expr;

typedef enum
{
    C_IDENTIFIER = 1,
    C_RHYTHM,
    C_STEPS,
    C_SCALE,
    C_KEY,
} ConstantType;

typedef struct
{
    union {
        char identifier[SETTINGS_LEXEME_LENGTH];
        char rhythm[SETTINGS_LEXEME_LENGTH];
        char steps[SETTINGS_LEXEME_LENGTH];
        char scale[SETTINGS_LEXEME_LENGTH];
        char key[SETTINGS_LEXEME_LENGTH];
    } value;
    ConstantType type;
} Constant;

typedef enum
{
    E_CONST = 1,
    E_VAR,
    E_CALL,
    E_SCALE,
    E_KEY,
    E_SONG,
    E_BINOP,
} ExprDefType;

typedef enum
{
    B_ADD = 1,
} BinopType;

typedef struct
{
    Expr *e1;
    Expr *e2;
    BinopType type;
} Binop;

typedef struct
{
    Expr *e;
    char name[SETTINGS_LEXEME_LENGTH];
} Var;

typedef struct
{
    Expr *e;
    Expr *params;
    int params_length;
} Call;

typedef enum
{
    Cool
} Type;

typedef struct Expr
{
    union ExprDef {
        //A constant.
        Constant constant;
        //Variable declaration.
        Var var;
        //A call e(params).
        Call call;
        //Binary operator e1 op e2.
        Binop binop;

    } expr;
    Position *pos;
    ExprDefType def_type;
    Type type;
} Expr;

typedef struct
{
    Expr exprs[SETTINGS_EXPRS_LENGTH];
    Expr *main;
    int cur_index;
} Exprs;
