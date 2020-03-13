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

package famuz.ds;

class ImmutableList<T>
{
    public function new() : Void
    {
        
    }
    
    public function length() : Int
    {
        return 0;
    }

    public function get(index :Int) : T
    {
        return null;
    }

    public function first() : T
    {
        return null;
    }

    public function last() : T
    {
        return null;
    }

    public function indexOf(v :T) : Int
    {
        return -1;
    }

    public function set(index :Int, v :T) : ImmutableList<T>
    {
        return null;
    }

    public function remove(index :Int, length :Int) : ImmutableList<T>
    {
        return null;
    }

    public function unshift(v :T) : ImmutableList<T>
    {
        return null;
    }

    public function pop() : ImmutableList<T>
    {
        return null;
    }

    public function shift() : ImmutableList<T>
    {
        return null;
    }

    public function push(v :T) : ImmutableList<T>
    {
        return null;
    }

    public function concat(list :ImmutableList<T>) : ImmutableList<T>
    {
        return null;
    }

    public function toString() : String
    {
        return null;
    }

    public function equals(list :ImmutableList<T>) : Bool
    {
        return true;
    }

    public function every(fn :T -> T) : ImmutableList<T>
    {
        return null;
    }

    public function filter(fn :T -> Bool) : ImmutableList<T>
    {
        return null;
    }

    public function map<Q>(fn :T -> Q) : ImmutableList<Q>
    {
        return null;
    }
}