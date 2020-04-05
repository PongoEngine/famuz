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

import famuz.compiler.expr.Type;

class TypeMap
{
    public function new() : Void
    {
        _map = new Map<String, Type>();
        _keys = [];
    }

    public function set(key :String, value :Type) : Void
    {
        _map.set(key, value);
        if(_map.exists(key)) {
            _keys.push(key);
        }
    }

    public inline function get(key :String) : Type
    {
        return _map.get(key);
    }

    public inline function exists(key :String) : Bool
    {
        return _map.exists(key);
    }

    public function equalsKeys(other :TypeMap) : Bool
    {
        if(this._keys.length == other._keys.length) {
            for(key in this._keys) {
                if(!other.exists(key)) {
                    return false;
                }
            }
            return true;
        }

        return false;
    }

    public function keys() : Iterator<String>
    {
        return _keys.iterator();
    }

    public function toString() : String
    {
        var fields = [];
        for(kv in _map.keyValueIterator()) {
            fields.push('${kv.key}: ${kv.value.toString()}');
        }
        return '{${fields.join(", ")}}';
        return "";
    }

    private var _map :Map<String, Type>;
    private var _keys :Array<String>;
}