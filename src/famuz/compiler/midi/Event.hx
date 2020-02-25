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

@:using(famuz.compiler.midi.Event.EventTools)
enum Event
{
    Midi(m :MidiEvent);
    SysEx(s :SysExEvent);
    Meta(m :MetaEvent);
}

enum MidiEvent
{
    NoteOff(channel :Int, note :Int, velocity :Int);
    NoteOn(channel :Int, note :Int, velocity :Int);
    PolyphonicPressure(channel :Int, note :Int, pressure :Int);
    Controller(channel :Int, controller :Int, value :Int);
    ProgramChange(channel :Int, program:Int);
    ChannelPressure(channel :Int, pressure :Int);
    PitchBend(channel :Int, lsb :Int, msb :Int);
}

enum SysExEvent
{
}

enum MetaEvent
{
    SequenceNumber(num :Int); //16bit
    Text(str :String);
    Copyright(str :String);
    TrackName(str :String);
    InstrumentName(str :String);
    Lyric(str :String);
    Marker(str :String);
    CuePoint(str :String);
    ProgramName(str :String);
    DeviceName(str :String);
    MIDIChannelPrefix(channel :Int);
    MIDIPort(port :Int);
    EndOfTrack;
    Tempo(val :Int); //24bit
    SMPTEOffset(hr :Int, mn :Int, se :Int, fr :Int, ff :Int);
    TimeSignature(nn :Int, dd :Int, cc :Int, bb :Int);
    KeySignature(sf :Int, mi :Int);
}

class EventTools
{
    public static function length(e :Event) : Int
    {
        return switch e {
            case Midi(m): switch m {
                case NoteOff(channel, note, velocity): 3;
                case NoteOn(channel, note, velocity): 3;
                case PolyphonicPressure(channel, note, pressure): 3;
                case Controller(channel, controller, value): 3;
                case ProgramChange(channel, program): 2;
                case ChannelPressure(channel, pressure): 2;
                case PitchBend(channel, lsb, msb): 3;
            }
            case SysEx(s): -1;
            case Meta(m): switch m {
                case SequenceNumber(num): -1;
                case Text(str): -1;
                case Copyright(str): -1;
                case TrackName(str): -1;
                case InstrumentName(str): -1;
                case Lyric(str): -1;
                case Marker(str): -1;
                case CuePoint(str): -1;
                case ProgramName(str): -1;
                case DeviceName(str): -1;
                case MIDIChannelPrefix(channel): -1;
                case MIDIPort(port): -1;
                case EndOfTrack: -1;
                case Tempo(val): -1;
                case SMPTEOffset(hr, mn, se, fr, ff): -1;
                case TimeSignature(nn, dd, cc, bb): -1;
                case KeySignature(sf, mi): -1;
            }
        }
    }
}