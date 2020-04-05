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
import haxe.ds.Option;

using Lambda;

@:using(famuz.compiler.expr.Type.TypeTools)
enum Type
{
    TAnonymous(a:Ref<AnonType>);
    TNumber;
    TBool;
    TScale;
    TKey;
    TMono(t:Ref<Option<Type>>);
    TArray(t:Ref<Type>);
    TFun(args:Array<Arg>, ret:Type);
}

class Arg
{
    public var name :String;
    public var type :Type;

    public function new(name :String, type :Type) : Void
    {
        this.name = name;
        this.type = type;
    }
}

typedef AnonType = {fields :Map<String, Type>};

class TypeTools
{
    public static function toString(t :Type) : String
    {
        return switch t {
            case TAnonymous(a):
                // "{" + a.ref.fields.(f -> {
                //     return '${f.name}: ${f.type.toString()}';
                // }).join(", ") + "}";
                var fields = [];
                for(kv in a.ref.fields.keyValueIterator()) {
                    fields.push('${kv.key}: ${kv.value.toString()}');
                }
                '{${fields.join(", ")}}';
            case TArray(t):
                'Array<${TypeTools.toString(t.ref)}>';
            case TNumber: 
                "Number";
            case TBool: 
                "Bool";
            case TScale: 
                "Scale";
            case TKey: 
                "Key";
            case TMono(t): 
                switch t.ref {
                    case Some(v): 
                        TypeTools.toString(v);
                    case None: 
                        "?";
                }
            case TFun(args, ret): {
                var argsStr = args.length > 0
                    ? args.mapi((i, a) -> {
                        return '${a.name}:${a.type.toString()}';
                    }).join(" -> ")
                    : "()";
                '(${argsStr} -> ${ret.toString()})';
            }
        }    
    }
}