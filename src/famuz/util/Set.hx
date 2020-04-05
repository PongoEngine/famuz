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

import haxe.Constraints.IMap;
import haxe.ds.StringMap;
import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
import haxe.ds.EnumValueMap;

@:multiType(@:followWithAbstracts K)
abstract Set<T>(IMap<T,T>)
{
    public function new() : Void;

    public inline function set(val :T) : Void
    {
        this.set(val, val);
    }

    public inline function get(val :T) : T
    {
        return this.get(val);
    }

    public inline function exists(val :T) : Bool
    {
        return this.exists(val);
    }

    public inline function copy() : Set<T>
    {
        return cast this.copy();
    }

    @:to static inline function toStringMap<K:String>(t:IMap<K, K>):StringMap<K> {
		return new StringMap<K>();
	}

	@:to static inline function toIntMap<K:Int>(t:IMap<K, K>):IntMap<K> {
		return new IntMap<K>();
	}

	@:to static inline function toEnumValueMapMap<K:EnumValue>(t:IMap<K, K>):EnumValueMap<K, K> {
		return new EnumValueMap<K, K>();
	}

	@:to static inline function toObjectMap<K:{}>(t:IMap<K, K>):ObjectMap<K, K> {
		return new ObjectMap<K, K>();
	}
}