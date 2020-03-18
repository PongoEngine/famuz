package famuz.util;

class FStringTools
{
    public static function mapToString<T>(map :Map<String, T>) : String
    {
        var str = "{\n";
        for(kv in map.keyValueIterator()) {
            str += '  ${kv.key}: ${kv.value}\n';
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