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

package famuz;

import famuz.compiler.Error;
import sys.io.File;
import haxe.ds.Option;
import famuz.compiler.parser.Precedence;
import famuz.compiler.Position;
import famuz.compiler.Context;
import famuz.compiler.Token.TokenScanner;
import famuz.compiler.lexer.Lexer;
import famuz.compiler.parser.Parser;
import famuz.compiler.theory.NotedHit;

class Famuz
{
    public static function compile(filePath :String) : Evaluation
    {
        var content = File.getContent(filePath);
        var tokens = Lexer.lex(filePath, content);
        var tokenScanner = new TokenScanner(tokens);
        var env = new Context();
        var error = new Error();
        ContextTools.addArrayExprs(env);

        while(tokenScanner.hasNext()) {
            Parser.parse(new Precedence(0), tokenScanner, env, error, false);
        }

        var main = env.getExpr("main");

        var music = switch main.def {
            case EFunction(_, _, body): {
                body.evaluate();
                None;
            }
            case _: 
                None;
        }

        return {
            music: music,
            errors: []
        };
    }
}

typedef Evaluation = {
    music: Option<Array<NotedHit>>,
    errors: Array<{msg :String, pos :Position}>
}