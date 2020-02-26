
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

import haxe.io.Bytes;
import famuz.compiler.theory.NotedHit;
import famuz.compiler.midi.Writer;

class Midi
{
    public static function create(music :Array<NotedHit>) : Void
    {
        var writer = new Writer();
        writer.addBuffer(createHeader());
        writer.addBuffer(createTrack(info()));
        writer.save("robot2.mid");
    }

    private static function createHeader() : Bytes
    {
        var w = new Writer();
        w.addBytes([0x4D,0x54,0x68,0x64]); //MThd
        w.addBytes([0x00,0x00,0x00,0x06]); //length
        w.addBytes([0x00,0x01]); //format
        w.addBytes([0x00,0x01]); //tracks
        w.addBytes([0x00,0x60]); //96 ppqn, metrical time
        return w.bytes();
    }

    private static function info() : Bytes
    {
        var ti = new Writer();
        createEvent(ti, 0x00, Meta(TimeSignature(0x04,0x02,0x18,0x08)));
        createEvent(ti, 0x00, Meta(KeySignature(0x02, 0x00)));
        createEvent(ti, 0x00, Meta(Tempo(0x0F, 0x42, 0x40)));
        createEvent(ti, 0x01, Meta(Copyright("Famuz 2020")));
        createEvent(ti, 0x01, Meta(EndOfTrack));
        return ti.bytes();
    }

    private static function createTrack(data :Bytes) : Bytes
    {
        var w = new Writer();
        w.addBytes([0x4D,0x54,0x72,0x6B]); //MTrk
        w.addInt32(data.length);
        w.addBuffer(data);
        return w.bytes();
    }

    public static function createEvent(w :Writer, delta :Byte, event :Event) : Void
    {
        w.addByte(delta);
        switch event {
            case Midi(m): switch m {
                case NoteOff(c, noteNumber, velocity):
                    w.addBytes([0x80 + c, noteNumber, velocity]);
                case NoteOn(c, noteNumber, velocity):
                    w.addBytes([0x90 + c, noteNumber, velocity]);
                case NoteAfterTouch(c, noteNumber, amount):
                    w.addBytes([0xA0 + c, noteNumber, amount]);
                case Controller(c, controllernumber, value):
                    w.addBytes([0xB0 + c, controllernumber, value]);
                case ProgramChange(c, programNumber):
                    w.addBytes([0xC0 + c, programNumber]);
                case ChannelAfterTouch(c, amount):
                    w.addBytes([0xD0 + c, amount]);
                case PitchBend(c, lsb, msb):
                    w.addBytes([0xE0 + c, lsb, msb]);
            }
            case Meta(m): switch m {
                case TrackName(text):
                    w.addBytes([0xFF, 0x03]);
                    var b = Bytes.ofString(text);
                    w.addByte(b.length);
                    w.addBuffer(b);
                case Copyright(text):
                    w.addBytes([0xFF, 0x02]);
                    var b = Bytes.ofString(text);
                    w.addByte(b.length);
                    w.addBuffer(b);
                case InstrumentName(text):
                    w.addBytes([0xFF, 0x04]);
                    var b = Bytes.ofString(text);
                    w.addByte(b.length);
                    w.addBuffer(b);
                case Lyric(text):
                    w.addBytes([0xFF, 0x05]);
                    var b = Bytes.ofString(text);
                    w.addByte(b.length);
                    w.addBuffer(b);
                case Marker(text):
                    w.addBytes([0xFF, 0x06]);
                    var b = Bytes.ofString(text);
                    w.addByte(b.length);
                    w.addBuffer(b);
                case CuePoint(text):
                    w.addBytes([0xFF, 0x07]);
                    var b = Bytes.ofString(text);
                    w.addByte(b.length);
                    w.addBuffer(b);
                case Text(text):
                    w.addBytes([0xFF, 0x01]);
                    var b = Bytes.ofString(text);
                    w.addByte(b.length);
                    w.addBuffer(b);
                case SequenceNumber1(ss1, ss2):
                    w.addBytes([0xFF, 0x00, 0x02, ss1, ss2]);
                case SequenceNumber2:
                    w.addBytes([0xFF, 0x00, 0x00]);
                case Tempo(tt1, tt2, tt3):
                    w.addBytes([0xFF, 0x51, 0x03, tt1, tt2, tt3]);
                case SmpteOffset(hr, mn, se, fr, ff):
                    w.addBytes([0xFF, 0x54, 0x05, hr, mn, se, fr, ff]);
                case TimeSignature(nn, dd, cc, bb):
                    w.addBytes([0xFF, 0x58, 0x04, nn, dd, cc, bb]);
                case KeySignature(sf, mi):
                    w.addBytes([0xFF, 0x59, 0x02, sf, mi]);
                case ProgramName(text):
                    w.addBytes([0xFF, 0x08]);
                    var b = Bytes.ofString(text);
                    w.addByte(b.length);
                    w.addBuffer(b);
                case DeviceName(text):
                    w.addBytes([0xFF, 0x09]);
                    var b = Bytes.ofString(text);
                    w.addByte(b.length);
                    w.addBuffer(b);
                case EndOfTrack:
                    w.addBytes([0xFF, 0x2F, 0x00]);
            }
        }
    }
}