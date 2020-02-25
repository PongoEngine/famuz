
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

package famuz.compiler.midi;

import famuz.compiler.theory.NotedHit;
import famuz.compiler.midi.Writer;

class Midi
{
    public static function create(music :Array<NotedHit>) : Void
    {
        var writer = new Writer();
        createHeader(writer);
        createTrack(writer);
        writer.save("robot.mid");
    }

    private static function createHeader(writer :Writer) : Void
    {
        writer.addBytes([0x4D,0x54,0x68,0x64]); //MThd
        writer.addBytes([0x00,0x00,0x00,0x06]); //length
        writer.addBytes([0x00,0x01]); //format
        writer.addBytes([0x00,0x01]); //tracks
        writer.addBytes([0x00,0x60]); //96 ppqn, metrical time
    }

    private static function createTrack(writer :Writer) : Void
    {
        writer.addBytes([0x4D,0x54,0x72,0x6B]); //MTrk
        writer.addBytes([0x00,0x00,0x00,0x19]); //length
        writer.addBytes([
            0x00, 0xFF, 0x58, 0x04, 0x04, 0x02, 0x18, 0x08,
            0x00, 0xFF, 0x59, 0x02, 0x02, 0x00,
            0x00, 0xFF, 0x51, 0x03, 0x0F, 0x42, 0x40,
            0x01, 0xFF, 0x2F, 0x00

        ]); //length
    }
}