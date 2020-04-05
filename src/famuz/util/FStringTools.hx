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