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
}