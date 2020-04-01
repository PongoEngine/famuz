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

package famuz.compiler.expr;

import famuz.compiler.expr.Ref;

using Lambda;

@:using(famuz.compiler.expr.Type.TypeTools)
enum Type
{
    TNumber;
    TBool;
    TScale;
    TKey;
    TMono(t:Ref<Null<Type>>);
    TFun(args:Array<{t:Type, name:String}>, ret:Type);
}

typedef AnonType = {fields :Array<{name :String, type :Type}>};

class TypeTools
{
    public static function toString(t :Type, ?letter :String) : String
    {
        return switch t {
            case TNumber: 
                "Number";
            case TBool: 
                "Bool";
            case TScale: 
                "Scale";
            case TKey: 
                "Key";
            case TMono(t): 
                t.ref != null
                    ? TypeTools.toString(t.ref)
                    : letter == null ? "'a" : letter;
            case TFun(args, ret): {
                args.mapi((i, a) -> {
                    var letter = String.fromCharCode("a".charCodeAt(0) + i);
                    return a.t.toString(letter);
                }).join(" -> ") + " -> " + ret.toString();
            }
        }    
    }
}