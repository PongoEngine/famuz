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

import famuz.compiler.Expr;
import famuz.compiler.Expr.BinopType;
import famuz.compiler.Token;
import famuz.compiler.parser.Precedence.*;
import famuz.compiler.parser.Parser;
using famuz.compiler.Type;

class ParserBinop
{
    public static function parse(parser :Parser, left :Expr, scanner :TokenScanner, context :Context) : Expr
    {
        var token = scanner.next();

        var op :BinopType = switch token.lexeme {
            case "+": B_ADD;
            case "<<": B_SHIFT_LEFT;
            case ">>": B_SHIFT_RIGHT;
            case _: throw "Invalid operation";
        }
        
        var right = parser.parse(PRECEDENCE_SUM, scanner, context);
        return parser.assert(right != null, () -> {
            context: context,
            def: EBinop(op, left, right),
            pos: Position.union(left.pos, right.pos),
            ret: left.ret.add(right.ret)
        }, () -> {
            context: context,
            def: EBinop(op, left, null),
            pos: Position.union(left.pos, token.pos),
            ret: TInvalid
        }, "Missing right expression.", 
        Position.union(left.pos, token.pos));
    }
}