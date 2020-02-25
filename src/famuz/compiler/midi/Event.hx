//https://www.mixagesoftware.com/en/midikit/help/HTML/midi_events.html

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
    Meta(m :MetaEvent);
}

/**
 * Musical control information such as playing a note or adjusting a MIDI 
 * channel's modulation value are defined by MIDI Channel Events. Each MIDI 
 * Channel Event consists of a variable-length delta time (like all track 
 * events) and a two or three byte description which determines the MIDI 
 * channel it corresponds to, the type of event it is and one or two event type 
 * specific values. Below is a detailed description of each type of MIDI event 
 * and how it is used.
 */
enum MidiEvent
{
    /**
     * Note Off Event
     * 
     * 0x8c noteNumber, velocity
     * 
     * The Note Off Event is used to signal when a MIDI key is released. These 
     * events have two parameters identical to a Note On event. The note number 
     * specifies which of the 128 MIDI keys is being played and the velocity 
     * determines how fast/hard the key was released. The note number is 
     * normally used to specify which previously pressed key is being released 
     * and the velocity is usually ignored, but is sometimes used to adjust the 
     * slope of an instrument's release phase.
     */
    NoteOff(channel :Byte, note :Byte, velocity :Byte);

    /**
     * Note On Event
     * 
     * 0x9c noteNumber, velocity
     * 
     * The Note On Event is used to signal when a MIDI key is pressed. This type 
     * of event has two parameters. The note number that specifies which of the 
     * 128 MIDI keys is being played and the velocity determines how fast/hard 
     * the key is pressed. The note number is normally used to specify the 
     * instruments musical pitch and the velocity is usually used to specify the 
     * instruments playback volume and intensity.
     */
    NoteOn(channel :Byte, note :Byte, velocity :Byte);

    /**
     * 
     */
    PolyphonicPressure(channel :Byte, note :Byte, pressure :Byte);

    /**
     * Controller Event
     * 
     * 0xBc controllernumber, value
     * 
     * The Controller Event signals the change in a MIDI channels state. There 
     * are 128 controllers which define different attributes of the channel 
     * including volume, pan, modulation, effects, and more. This event type has 
     * two parameters. The controller number specifies which control is changing 
     * and the controller value defines it's new setting.
     * 
     * https://www.mixagesoftware.com/en/midikit/help/HTML/controllers.html
     */
    Controller(channel :Byte, controller :Byte, value :Byte);

    /**
     * Program Change Event
     * 
     * 0xCc programNumber
     * 
     * The Program Change Event is used to change which program 
     * (instrument/patch) should be played on the MIDI channel. This type of 
     * event takes only one parameter, the program number of the new 
     * instrument/patch.
     */
    ProgramChange(channel :Byte, program:Byte);

    /**
     * 
     */
    ChannelPressure(channel :Byte, pressure :Byte);

    /**
     * Pitch Bend Event
     * 
     * 0XEc value LSB, value MSB
     * 
     * The Pitch Bend Event is similar to a controller event, except that it is 
     * a unique MIDI Channel Event that has two bytes to describe it's value. 
     * The pitch value is defined by both parameters of the MIDI Channel Event 
     * by joining them in the format of yyyyyyyxxxxxxx where the y characters 
     * represent the last 7 bits of the second parameter and the x characters 
     * represent the last 7 bits of the first parameter. The combining of both 
     * parameters enables high accuracy values (0 - 16383). The pitch value 
     * affects all playing notes on the current channel. Values below 8192 
     * decrease the pitch, while values above 8192 increase the pitch. The pitch 
     * range may vary from instrument to instrument, but is usually +/-2 
     * semi-tones.
     */
    PitchBend(channel :Byte, lsb :Byte, msb :Byte);
}

enum MetaEvent
{
    /**
     * Track name
     * 
     * FF 03 len text
     * 
     * The Text specifies the title of the track or sequence. The first Title 
     * meta-event in a type 0 MIDI file, or in the first track of a type 1 file 
     * gives the name of the work. Subsequent Title meta-events in other tracks 
     * give the names of those tracks.
     */
    TrackName(text :String);

    /**
     * Copyright
     * 
     * FF 02 len text
     * 
     * The Text specifies copyright information for the sequence. This is 
     * usually placed at time 0 of the first track in the sequence.
     */
    Copyright(text :String);

    /**
     * Instrument name
     * 
     * FF 04 len text
     * 
     * The Text names the instrument intended to play the contents of this 
     * track, This is usually placed at time 0 of the track. Note that this to 
     * it. This meta-event is particularly useful in sequences prepared for 
     * synthesisers which do not conform to the General MIDI patch set, as it 
     * documents the intended instrument for the track when the sequence is 
     * used on a synthesiser with a different patch set.
     */
    InstrumentName(text :String);

    /**
     * Lyric
     * 
     * FF 05 len text
     * 
     * The Text gives a lyric intended to be sung at the given Time. Lyrics are 
     * often broken down into separate syllables to time-align them more 
     * precisely with the sequence. See karoke formats.
     */
    Lyric(text :String);

    /**
     * Marker
     * 
     * FF 06 len text
     * 
     * The Text marks a point in the sequence which occurs at the given Time, 
     * for example "Third Movement".
     */
    Marker(text :String);

    /**
     * Cue point
     * 
     * FF 07 len text
     * 
     * The Text identifies synchronisation point which occurs at the specified 
     * Time, for example, "Door slams".
     */
    CuePoint(text :String);

    /**
     * Text
     * 
     * FF 01 len text
     * 
     * This meta-event supplies an arbitrary Text string tagged to the Track 
     * and Time. It can be used for textual information which doesn't fall into 
     * one of the more specific categories given above.
     */
    Text(text :String);

    /**
     * Sequence number
     * 
     * FF 00 02 ss ss
     * FF 00 00
     * 
     * This optional event must occur at the beginning of a track (ie, before 
     * any non-zero time and before any midi events). It specifies the sequence 
     * number. The two data bytes ss ss, are that number which corresponds to 
     * the MIDI Cue message. In a format 2 MIDI file, this number identifies 
     * each "pattern" (ie, track) so that a "song" sequence can use the MIDI 
     * Cue message to refer to patterns.
     * 
     * If the ss ss numbers are omitted (ie, the second form shown above), then 
     * the track's location in the file is used. (ie, The first track chunk is 
     * sequence number 0. The second track is sequence number 1. Etc). In format 
     * 0 or 1, which contain only one "pattern" (even though format 1 contains 
     * several tracks), this event is placed in only the track. So, a group of 
     * format 0 or 1 files with different sequence numbers can comprise a "song 
     * collection". There can be only one of these events per track chunk in a 
     * Format 2. There can be only one of these events in a Format 0 or 1, and 
     * it must be in the first track.
     */
    SequenceNumber1(ss1 :Byte, ss2 :Byte);
    SequenceNumber2;

    /**
     * Tempo
     * 
     * FF 51 03 tt tt tt
     * 
     * The tempo is specified as the Number of microseconds per quarter note, 
     * between 1 and 16777215. A value of 500000 (07 A1 20) corresponds to 120 
     * quarter notes ("beats") per minute. To convert beats per minute to a 
     * Tempo value, take the quotient from dividing 60,000,000 by the beats per 
     * minute.
     * 
     * NOTE: If there are no tempo events in a MIDI file, then the tempo is 
     * assumed to be 120 BPM.
     * 
     * In a format 0 file, the tempo changes are scattered throughout the one 
     * track. In format 1, the very first track should consist of only the 
     * tempo (and time signature) events so that it could be read by some device 
     * capable of generating a "tempo map". It is best not to place MIDI events 
     * in this track. In format 2, each track should begin with at least one 
     * initial tempo (and time signature) event.
     */
    Tempo(tt1 :Byte, tt2 :Byte, tt3 :Byte);

    /**
     * SMPTE offset
     * 
     * FF 54 05 hr mn se fr ff
     * 
     * This meta event is used to specify the SMPTE starting point offset from 
     * the beginning of the track. It is defined in terms of hours, minutes, 
     * seconds, frames and sub-frames (always 100 sub-frames per frame, no 
     * matter what sub-division is specified in the MIDI header chunk). In a 
     * format 1 file, the SMPTE OFFSET must be stored with the tempo map (ie, 
     * the first track), and has no meaning in any other track.
     * 
     * The hr hour byte used to specify the hour offset also specifies the 
     * frame rate in the following format: 0rrhhhhh where rr is two bits for 
     * the frame rate where 00=24 fps, 01=25 fps, 10=30 fps (drop frame), 11=30 
     * fps and hhhhh is five bits for the hour (0-23). The hour byte's top bit 
     * is always 0.
     * 
     * The fr frame byte's possible range depends on the encoded frame rate in 
     * the hour byte. A 25 fps frame rate means that a maximum value of 24 may 
     * be set for the frame byte.
     * 
     * The ff field contains fractional frames in 100ths of a frame.
     */
    SmpteOffset(hr :Byte, mn :Byte, se :Byte, fr :Byte, ff:Byte);

    /**
     * Time signature
     * 
     * FF 58 04 nn dd cc bb
     * 
     * Time signature is expressed as 4 numbers. nn and dd represent the 
     * "numerator" and "denominator" of the signature as notated on sheet music. 
     * The denominator is a negative power of 2: 2 = quarter note, 3 = eighth, 
     * etc.
     * 
     * The cc expresses the number of MIDI clocks in a metronome click.
     * 
     * The bb parameter expresses the number of notated 32nd notes in a MIDI 
     * quarter note (24 MIDI clocks). This event allows a program to relate 
     * what MIDI thinks of as a quarter, to something entirely different.
     * 
     * For example, 6/8 time with a metronome click every 3 eighth notes and 24 
     * clocks per quarter note would be the following event:
     * 
     * FF 58 04 06 03 18 08
     * 
     * NOTE: If there are no time signature events in a MIDI file, then the time 
     * signature is assumed to be 4/4.
     * 
     * In a format 0 file, the time signatures changes are scattered throughout 
     * the one track. In format 1, the very first track should consist of only 
     * the time signature (and tempo) events so that it could be read by some 
     * device capable of generating a "tempo map". It is best not to place MIDI 
     * events in this track. In format 2, each track should begin with at least 
     * one initial time signature (and tempo) event.
     */
    TimeSignature(nn :Byte, dd :Byte, cc :Byte, bb:Byte);

    /**
     * Key signature
     * 
     * FF 59 02 sf mi
     * 
     * The key signature is specified by the numeric sf Key value, which is 0 
     * for the key of C, a positive value for each sharp above C, or a negative 
     * value for each flat below C, thus in the inclusive range -7 to 7. The 
     * Major/Minor mi field is a number value which will be 0 for a major key 
     * and 1 for a minor key.
     */
    KeySignature(sf :Byte, mi :Byte);

    /**
     * Program Name
     * 
     * FF 08 len text
     * 
     * The name of the program (ie, patch) used to play the track. This may be 
     * different than the Sequence/Track Name. For example, maybe the name of 
     * your sequence (ie, track) is "Butterfly", but since the track is played 
     * upon an electric piano patch, you may also include a Program Name of 
     * "ELECTRIC PIANO".
     */
    ProgramName(text :String);

    /**
     * Device (port) name
     * 
     * FF 09 len text
     * 
     * The name of the MIDI device (port) where the track is routed. This 
     * replaces the "MIDI Port" Meta-Event which some sequencers formally used 
     * to route MIDI tracks to various MIDI ports (in order to support more 
     * than 16 MIDI channels).
     * 
     * For example, assume that you have a MIDI interface that has 4 MIDI output 
     * ports. They are listed as "MIDI Out 1", "MIDI Out 2", "MIDI Out 3", and 
     * "MIDI Out 4". If you wished a particular track to use "MIDI Out 1" then 
     * you would put a Port Name Meta-event at the beginning of the track, with 
     * "MIDI Out 1" as the text.
     * 
     * All MIDI events that occur in the track, after a given Port Name event, 
     * will be routed to that port.
     * 
     * In a format 0 MIDI file, it would be permissible to have numerous Port 
     * Name events intermixed with MIDI events, so that the one track could 
     * address numerous ports. But that would likely make the MIDI file much 
     * larger than it need be. The Port Name event is useful primarily in format 
     * 1 MIDI files, where each track gets routed to one particular port.
     */
    DeviceName(text :String);

    /**
     * End of Track
     * 
     * FF 2F 00
     * 
     * This event is not optional. It must be the last event in every track. 
     * It's used as a definitive marking of the end of a track. Only 1 per 
     * track.
     */
    EndOfTrack;
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
            case Meta(m): -1;
        }
    }
}