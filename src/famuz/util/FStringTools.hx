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

package famuz.util;

class FStringTools
{
    public static function mapToStringSmall<T>(map :Map<String, T>) : String
    {
        var str = "{";
        var itr = map.keyValueIterator();
        for(kv in itr) {
            str += '${kv.key}:${kv.value}';
            if(itr.hasNext()) {
                str += ",";
            }
        }
        return str + "}";
    }

    public static function isNumber(str :String) : Bool
    {
        return str == '0' ||
            str == '1' ||
            str == '2' ||
            str == '3' ||
            str == '4' ||
            str == '5' ||
            str == '6' ||
            str == '7' ||
            str == '8' ||
            str == '9';
    }
}