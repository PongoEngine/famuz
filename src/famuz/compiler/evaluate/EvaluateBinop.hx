package famuz.compiler.evaluate;

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

import famuz.compiler.Expr.Hit;
import famuz.compiler.Expr.Note;
import famuz.compiler.Expr.BinopType;

using Lambda;

class EvaluateBinop
{
    public static function evaluate(binop :BinopType, e1 :Expr, e2 :Expr, context :Context, stack :Stack) : Void
    {

        Evaluate.evaluate(e2, stack);
        Evaluate.evaluate(e1, stack);

        var left = stack.pop();
        var right = stack.pop();

        switch [binop, left.ret, right.ret] {
            case [B_ADD, TNumber, TNumber]: addNumbers(left, right, context, stack);
            case [B_ADD, TRhythm, TSteps]: addRhythmSteps(left, right, context, stack);
            case [B_ADD, TSteps, TRhythm]: addRhythmSteps(right, left, context, stack);
            case [B_SHIFT_RIGHT, TRhythm, TNumber]: shiftRightRhythm(left, right, context, stack);
            case [B_SHIFT_RIGHT, TSteps, TNumber]: shiftRightSteps(left, right, context, stack);
            case _: throw "invalid";
        }
    }

    private static function addNumbers(left :Expr, right :Expr, context :Context, stack :Stack) : Void
    {
        stack.push({
            context: context,
            def: EConstant(CNumber(copyNumber(left, stack) + copyNumber(right, stack))),
            pos: Position.union(left.pos, right.pos),
            ret: TNumber
        });
    }

    private static function addRhythmSteps(rhythm :Expr, steps :Expr, context :Context, stack :Stack) : Void
    {
        var r = copyRhythm(rhythm, stack);
        var m :Array<Note> = copySteps(steps, stack).mapi((index, item) -> {
            return {step: item, hit: r.hits[index % r.hits.length]};
        });
        stack.push({
            context: context,
            def: EConstant(CMelody(m)),
            pos: Position.union(rhythm.pos, steps.pos),
            ret: TSteps
        });
    }

    private static function shiftRightRhythm(rhythm :Expr, number :Expr, context :Context, stack :Stack) : Void
    {
        var r = copyRhythm(rhythm, stack);
        var duration = r.duration;
        var n = copyNumber(number, stack);
        r.hits.map(r -> r.start = (r.start + n) % duration);
        r.hits.sort((a,b) -> a.start - b.start);
        stack.push({
            context: context,
            def: EConstant(CRhythm(r.hits, r.duration)),
            pos: Position.union(rhythm.pos, number.pos),
            ret: TSteps
        });
    }

    private static function shiftRightSteps(steps :Expr, number :Expr, context :Context, stack :Stack) : Void
    {
        var shiftedSteps = copySteps(steps, stack).map(s -> s + copyNumber(number, stack));
        stack.push({
            context: context,
            def: EConstant(CSteps(shiftedSteps)),
            pos: Position.union(steps.pos, number.pos),
            ret: TSteps
        });
    }

    private static function copyNumber(e :Expr, stack :Stack) : Int
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CNumber(value): value;
                case _: throw "invalid";
            }
            case _: throw "invalid";
        }
    }

    private static function copySteps(e :Expr, stack :Stack) : Array<Int>
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CSteps(steps): steps.copy();
                case _: throw "Expected Steps.";
            }
            case _: throw "Expected Steps.";
        }
    }

    private static function copyRhythm(e :Expr, stack :Stack) : {hits: Array<Hit>, duration :Int}
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CRhythm(hits, duration): {
                    hits: hits.copy(),
                    duration: duration
                };
                case _: throw "Expected Rhythm.";
            }
            case _: throw "Expected Rhythm";
        }
    }
}