package famuz.compiler.parser;

/*
 * Copyright (c) 2020 Jeremy Meltingtallow
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

import famuz.compiler.Token;
import famuz.util.Assert;
using famuz.compiler.parser.Precedence;

class Parser
{
    public static function parseExpression(precedence :Int, scanner :TokenScanner, environment :Environment) : Expr
    {
        if (scanner.hasNext()) {
            var left = parse_expression_prefix(scanner, environment);
            if (!Assert.that(left != null, "IN PARSE EXPRESSION LEFT IS NULL")) {
                if (scanner.hasNext()) {
                    scanner.next();
                }
                return null;
            }

            while (scanner.hasNext() && precedence < scanner.getPrecedence())
            {
                left = parseExpressionInfix(left, scanner, environment);
            }
            return left;
        }
        else
        {
            return null;
        }
    }

    public static function parse_expression_prefix(scanner :TokenScanner, environment :Environment) : Expr
    {
        // Token *token = token_scanner_peek(scanner);
    
    //     switch (token.type) {
    //         case IDENTIFIER:
    //             return parse_identifier(scanner, environments, env_id);
    //         case NUMBER:
    //             return parse_number(scanner, environments, env_id);
    //         case SCALE:
    //             return parse_scale(scanner, environments, env_id);
    //         case KEY:
    //             return parse_key(scanner, environments, env_id);
    //     case STEPS:
    //         return parse_steps(scanner, environments, env_id);
    //     case RHYTHM:
    //         return parse_rhythm(scanner, environments, env_id);
    //     case LEFT_PARAM:
    //         return parse_parentheses(scanner, environments, env_id, stack);
    //     case LEFT_BRACKET:
    //         return parse_block(scanner, environments, env_id, stack);
    //     case FUNC:
    //         return parse_func(scanner, environments, env_id, stack);
    //     case PRINT:
    //         return parse_print(scanner, environments, env_id, stack);
    //     case RIGHT_PARAM:
    //     case RIGHT_BRACKET:
    //     case COMMA:
    //     case SLASH:
    //     case COMMENT:
    //     case WHITESPACE:
    //     case ADD:
    //     case ASSIGNMENT:
    //     case COLON:
    //     case SHIFT_LEFT:
    //     case SHIFT_RIGHT:
    //     {
    //         token_scanner_next(scanner);
    //         return NULL;
    //     }
    //     }
        return null;
    }
    
    public static function parseExpressionInfix(left :Expr, scanner :TokenScanner, environment :Environment) : Expr
    {
        var token = scanner.peek();
    
        return switch (token.type) {
            case ADD:
                null;
                // return parse_binop(left, scanner, environments, env_id, stack);
            case ASSIGNMENT:
                null;
                // return parse_var(left, scanner, environments, env_id, stack);
            case LEFT_PARAM:
                null;
                // return parse_call(left, scanner, environments, env_id, stack);
            case COLON:
                null;
                // return parse_typing(left, scanner, env_id);
            case SHIFT_LEFT:
                null;
                // return parse_binop(left, scanner, environments, env_id, stack);
            case SHIFT_RIGHT:
                null;
                // return parse_binop(left, scanner, environments, env_id, stack);
            case RIGHT_PARAM, LEFT_BRACKET, RIGHT_BRACKET, COMMA, 
                SLASH, IDENTIFIER, SCALE, KEY, WHITESPACE, STEPS, 
                COMMENT, RHYTHM, FUNC, PRINT, NUMBER:
                null;
        }
    }
}