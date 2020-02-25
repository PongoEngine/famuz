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

import haxe.io.BytesOutput;
import sys.io.File;

abstract Writer(BytesOutput)
{
    public function new() : Void
    {
        this = new BytesOutput();
        this.bigEndian = true;
    }

    public inline function addBytes(bytes :Array<Int>) : Void
    {
        for(byte in bytes) {
            this.writeByte(byte);
        }
    }

    public inline function addByte(byte :Int) : Void
    {
        this.writeByte(byte);
    }

    public function addEvent(event :Event) : Void
    {
        switch event {
            case Midi(m): switch m {
                case NoteOff(channel, note, velocity):
                case NoteOn(channel, note, velocity):
                case PolyphonicPressure(channel, note, pressure):
                case Controller(channel, controller, value):
                case ProgramChange(channel, program):
                case ChannelPressure(channel, pressure):
                case PitchBend(channel, lsb, msb):
            }
            case SysEx(s):
            case Meta(m): switch m {
                case SequenceNumber(num):
                case Text(str):
                case Copyright(str):
                case TrackName(str):
                case InstrumentName(str):
                case Lyric(str):
                case Marker(str):
                case CuePoint(str):
                case ProgramName(str):
                case DeviceName(str):
                case MIDIChannelPrefix(channel):
                case MIDIPort(port):
                case EndOfTrack:
                case Tempo(val):
                case SMPTEOffset(hr, mn, se, fr, ff):
                case TimeSignature(nn, dd, cc, bb):
                case KeySignature(sf, mi):
            }
        }
    }

    public inline function save(path :String) : Void
    {
        File.saveBytes(path, this.getBytes());
    }
}