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

package famuz.compiler.evaluate;

import famuz.compiler.theory.NotedHit;
import famuz.compiler.theory.Octave;
import famuz.compiler.Expr.BinopType;
import famuz.compiler.Expr.ExprStack;
import famuz.compiler.theory.Note;
import famuz.compiler.theory.Step;
import famuz.compiler.theory.Hit;
import famuz.compiler.theory.SteppedHit;

using Lambda;
using famuz.util.MathTools;
using famuz.compiler.Expr.ExprTools;

class EvaluateBinop
{
    public static function evaluate(binop :BinopType, e1 :Expr, e2 :Expr, context :Context, stack :ExprStack) : Void
    {

        Evaluate.evaluate(e2, stack);
        Evaluate.evaluate(e1, stack);

        var left = stack.pop();
        var right = stack.pop();

        switch [binop, left.ret, right.ret] {
            case [ADD, TNumber, TNumber]: addNumbers(left, right, context, stack);
            case [ADD, TKey, TScale]: addKeyToScale(left, right, context, stack);
            case [ADD, TScale, TKey]: addKeyToScale(right, left, context, stack);
            case [ADD, TMelody, TScaledKey]: addMelodyToScaledKey(left, right, context, stack);
            case [ADD, TScaledKey, TMelody]: addMelodyToScaledKey(right, left, context, stack);
            case [ADD, TMelody, TMelody]: addMelody(left, right, context, stack);
            case [ADD, TMusic, TMusic]: addMusic(left, right, context, stack);
            case [SHIFT_RIGHT, TRhythm, TNumber]: shiftRhythm(left, right, context, stack, false);
            case [SHIFT_LEFT, TRhythm, TNumber]: shiftRhythm(left, right, context, stack, true);
            case _: throw "invalid";
        }
    }

    private static function addNumbers(left :Expr, right :Expr, context :Context, stack :ExprStack) : Void
    {
        stack.push({
            context: context,
            def: EConstant(CNumber(left.copyNumber() + right.copyNumber())),
            pos: Position.union(left.pos, right.pos),
            ret: TNumber
        });
    }

    private static function addMusic(left :Expr, right :Expr, context :Context, stack :ExprStack) : Void
    {
        var m1 = left.copyMusic();
        var m2 = right.copyMusic();
        var m2Offset = m1.length == 0
            ? 0
            : m1[m1.length-1].hit.start + m1[m1.length-1].hit.duration;
        var m3 = m1.map(n -> new NotedHit(n.note, new Hit(n.hit.start, n.hit.duration)));
        for(nh in m2) {
            var n = new NotedHit(nh.note, new Hit(nh.hit.start, nh.hit.duration));
            n.hit.start += m2Offset;
            m3.push(n);
        }

        stack.push({
            context: context,
            def: EConstant(CMusic(m3)),
            pos: Position.union(left.pos, right.pos),
            ret: TMusic
        });
    }

    private static function addMelody(left :Expr, right :Expr, context :Context, stack :ExprStack) : Void
    {
        var m1 = left.copyMelody();
        var m2 = right.copyMelody();

        var m3Hits = m1.steppedHits.map(n -> new SteppedHit(n.step, new Hit(n.hit.start, n.hit.duration)));
        for(nh in m2.steppedHits) {
            var n = new SteppedHit(nh.step, new Hit(nh.hit.start, nh.hit.duration));
            n.hit.start += m1.duration;
            m3Hits.push(n);
        }

        stack.push({
            context: context,
            def: EConstant(CMelody(m3Hits, m1.duration + m2.duration)),
            pos: Position.union(left.pos, right.pos),
            ret: TMelody
        });
    }

    private static function addMelodyToScaledKey(melody :Expr, scaledKey :Expr, context :Context, stack :ExprStack) : Void
    {
        var m = melody.copyMelody();
        var sk = scaledKey.copyScaledKey();
        var scale = sk.scale;
        var key = sk.key;

        var music = m.steppedHits.map(steppedHit -> {
            var n = Note.create(key, scale, steppedHit.step, new Octave(1));
            return new NotedHit(n, steppedHit.hit);
        });

        stack.push({
            context: context,
            def: EConstant(CMusic(music)),
            pos: Position.union(melody.pos, scaledKey.pos),
            ret: TMusic
        });
    }

    private static function addKeyToScale(key :Expr, scale :Expr, context :Context, stack :ExprStack) : Void
    {
        stack.push({
            context: context,
            def: EConstant(CScaledKey(scale.copyScale(), key.copyKey())),
            pos: Position.union(key.pos, scale.pos),
            ret: TScaledKey
        });
    }

    private static function addRhythmToSteps(rhythm :Expr, steps :Expr, context :Context, stack :ExprStack) : Void
    {
        var r = rhythm.copyRhythm();
        var m :Array<SteppedHit> = steps.copySteps().mapi((index, item) -> {
            return new SteppedHit(item, r.hits[index % r.hits.length]);
        });
        stack.push({
            context: context,
            def: EConstant(CMelody(m, r.duration)),
            pos: Position.union(rhythm.pos, steps.pos),
            ret: TMelody
        });
    }

    private static function shiftRhythm(rhythm :Expr, number :Expr, context :Context, stack :ExprStack, isLeft :Bool) : Void
    {
        var r = rhythm.copyRhythm();
        var duration = r.duration;
        var n = number.copyNumber() * (isLeft ? -1 : 1);
        r.hits.map(r -> r.start = (r.start + n).mod(duration));
        r.hits.sort((a,b) -> a.start - b.start);
        stack.push({
            context: context,
            def: EConstant(CRhythm(r.hits, r.duration)),
            pos: Position.union(rhythm.pos, number.pos),
            ret: TRhythm
        });
    }
}