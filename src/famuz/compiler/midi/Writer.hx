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
import haxe.io.BytesOutput;
import sys.io.File;

abstract Writer(BytesOutput)
{
    public function new() : Void
    {
        this = new BytesOutput();
        this.bigEndian = true;
    }

    public inline function addBytes(bytes :Array<Byte>) : Void
    {
        for(byte in bytes) {
            this.writeByte(byte);
        }
    }

    public inline function addBuffer(buf :Bytes) : Void
    {
        this.writeBytes(buf, 0, buf.length);
    }

    public inline function addByte(byte :Byte) : Void
    {
        this.writeByte(byte);
    }

    public inline function addInt32(int :Int) : Void
    {
        this.writeInt32(int);
    }

    public inline function save(path :String) : Void
    {
        File.saveBytes(path, this.getBytes());
    }

    public inline function bytes() : Bytes
    {
        return this.getBytes();
    }
}