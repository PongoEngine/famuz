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

import famuz.compiler.Expr.BinopType;
import famuz.compiler.Expr.ExprStack;
import famuz.compiler.theory.Scale;
import famuz.compiler.theory.Key;
import famuz.compiler.theory.Step;
import famuz.compiler.theory.Hit;
import famuz.compiler.theory.SteppedHit;

using Lambda;
using famuz.compiler.evaluate.EvaluateBinop.NumberTools;

class EvaluateBinop
{
    public static function evaluate(binop :BinopType, e1 :Expr, e2 :Expr, context :Context, stack :ExprStack) : Void
    {

        Evaluate.evaluate(e2, stack);
        Evaluate.evaluate(e1, stack);

        var left = stack.pop();
        var right = stack.pop();

        switch [binop, left.ret, right.ret] {
            case [B_ADD, TNumber, TNumber]: addNumbers(left, right, context, stack);
            case [B_ADD, TRhythm, TSteps]: addRhythmToSteps(left, right, context, stack);
            case [B_ADD, TSteps, TRhythm]: addRhythmToSteps(right, left, context, stack);
            case [B_ADD, TKey, TScale]: addKeyToScale(left, right, context, stack);
            case [B_ADD, TScale, TKey]: addKeyToScale(right, left, context, stack);
            case [B_ADD, TMelody, TScaledKey]: addMelodyToScaledKey(left, right, context, stack);
            case [B_ADD, TScaledKey, TMelody]: addMelodyToScaledKey(right, left, context, stack);
            case [B_SHIFT_RIGHT, TRhythm, TNumber]: shiftRhythm(left, right, context, stack, false);
            case [B_SHIFT_LEFT, TRhythm, TNumber]: shiftRhythm(left, right, context, stack, true);
            case [B_SHIFT_RIGHT, TSteps, TNumber]: shiftRightSteps(left, right, context, stack);
            case _: throw "invalid";
        }
    }

    private static function addNumbers(left :Expr, right :Expr, context :Context, stack :ExprStack) : Void
    {
        stack.push({
            context: context,
            def: EConstant(CNumber(copyNumber(left) + copyNumber(right))),
            pos: Position.union(left.pos, right.pos),
            ret: TNumber
        });
    }

    private static function addMelodyToScaledKey(melody :Expr, scaledKey :Expr, context :Context, stack :ExprStack) : Void
    {
        stack.push({
            context: context,
            def: EConstant(CMusic(-1)),
            pos: Position.union(melody.pos, scaledKey.pos),
            ret: TMusic
        });
    }

    private static function addKeyToScale(key :Expr, scale :Expr, context :Context, stack :ExprStack) : Void
    {
        stack.push({
            context: context,
            def: EConstant(CScaledKey(copyScale(scale), copyKey(key))),
            pos: Position.union(key.pos, scale.pos),
            ret: TScaledKey
        });
    }

    private static function addRhythmToSteps(rhythm :Expr, steps :Expr, context :Context, stack :ExprStack) : Void
    {
        var r = copyRhythm(rhythm);
        var m :Array<SteppedHit> = copySteps(steps).mapi((index, item) -> {
            return new SteppedHit(item, r.hits[index % r.hits.length]);
        });
        stack.push({
            context: context,
            def: EConstant(CMelody(m)),
            pos: Position.union(rhythm.pos, steps.pos),
            ret: TMelody
        });
    }

    private static function shiftRhythm(rhythm :Expr, number :Expr, context :Context, stack :ExprStack, isLeft :Bool) : Void
        {
            var r = copyRhythm(rhythm);
            var duration = r.duration;
            var n = copyNumber(number) * (isLeft ? -1 : 1);
            r.hits.map(r -> r.start = (r.start + n).mod(duration));
            r.hits.sort((a,b) -> a.start - b.start);
            stack.push({
                context: context,
                def: EConstant(CRhythm(r.hits, r.duration)),
                pos: Position.union(rhythm.pos, number.pos),
                ret: TSteps
            });
        }

    private static function shiftRightSteps(steps :Expr, number :Expr, context :Context, stack :ExprStack) : Void
    {
        var shiftedSteps = copySteps(steps).map(s -> s + Step.step(copyNumber(number)));
        stack.push({
            context: context,
            def: EConstant(CSteps(shiftedSteps)),
            pos: Position.union(steps.pos, number.pos),
            ret: TSteps
        });
    }

    private static function copyNumber(e :Expr) : Int
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CNumber(value): value;
                case _: throw "Expected Number";
            }
            case _: throw "Expected Number";
        }
    }

    private static function copySteps(e :Expr) : Array<Step>
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CSteps(steps): steps.copy();
                case _: throw "Expected Steps.";
            }
            case _: throw "Expected Steps.";
        }
    }

    private static function copyKey(e :Expr) : Key
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CKey(key): key;
                case _: throw "Expected Key.";
            }
            case _: throw "Expected Key.";
        }
    }

    private static function copyScale(e :Expr) : ScaleType
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CScale(scale): scale;
                case _: throw "Expected Scale.";
            }
            case _: throw "Expected Scale.";
        }
    }

    private static function copyMelody(e :Expr) : Array<SteppedHit>
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CMelody(melody): melody.copy();
                case _: throw "Expected Melody.";
            }
            case _: throw "Expected Steps.";
        }
    }

    private static function copyRhythm(e :Expr) : {hits: Array<Hit>, duration :Int}
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

class NumberTools
{
    public static function mod(number :Int, amount :Int) : Int 
    {
        return ((number % amount) + amount) % amount;
    };
}