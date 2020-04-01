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

@:using(famuz.compiler.expr.Type.TypeTools)
enum Type
{
    TNumber;
    TBool;
    TScale;
    TKey;
    TMono;
    TAnonymous(a :Ref<AnonType>);
    TArray(type :Ref<Type>);
}

typedef AnonType = {fields :Array<{name :String, type :Type}>};

class TypeTools
{
    public static function resolveType(fields :Map<String, Expr>) : Type
    {
        var anon = {
            fields: []
        };

        for(kv in fields.keyValueIterator()) {
            anon.fields.push({name:kv.key, type:kv.value.t});
        }

        return TAnonymous({ref:anon});
    }

    public static function equals(a :Type, b :Type) : Bool
    {
        return switch [a, b] {
            case [TNumber, TNumber]: 
                true;
            case [TBool, TBool]: 
                true;
            case [TScale, TScale]: 
                true;
            case [TKey, TKey]: 
                true;
            case [TMono, TMono]: 
                true;
            case [TAnonymous(a1), TAnonymous(a2)]: {
                if(a1.ref.fields.length != a2.ref.fields.length) {
                    throw "eer";
                }
                else {
                    // throw "err";
                    return true;
                }
            };
            case [TArray(type1), TArray(type2)]: 
                TypeTools.equals(type1.ref, type2.ref);
            case _: 
                false;
        }
    }
}