import java.util.*;

//HashMap:
//- Fastest performance for get, put, remove
//- No ordering guarantees
//- Allows one null key and multiple null values
//- Use when order doesn't matter

//LinkedHashMap:
//- Maintains insertion order (or access order with constructor param)
//- Slightly slower than HashMap
//- Good for LRU cache implementation
//- Use when you need predictable iteration order

//TreeMap:
//- Sorted by keys (natural or custom comparator)
//- Slower than HashMap (O(log n) operations)
//- Provides NavigableMap methods
//- Does not allow null keys
//- Use when you need sorted keys or range operations

public class MapReference {
    public static void main(String[] args) {
        hashMapUsage();
        linkedHashMapUsage();
        treeMapUsage();
        mapOperationsUsage();
    }

    //============================================================
    //HASHMAP - USAGE (No order, fastest)
    //============================================================
    public static void hashMapUsage() {
        //Creation
        HashMap<String, Integer> map = new HashMap<>();
        Map<String, Integer> map2 = new HashMap<>(); //Preferred - interface reference
        
        //Put key-value pairs
        map.put("apple", 5);
        map.put("banana", 3);
        map.put("apple", 10); //Overwrites previous value
        
        //Get value by key
        Integer apples = map.get("apple"); //10
        Integer oranges = map.get("orange"); //null (key doesn't exist)
        
        //Get with default value
        Integer defaultValue = map.getOrDefault("orange", 0); //0
        
        //Check if key exists
        boolean hasApple = map.containsKey("apple"); 
        
        //Check if value exists
        boolean hasThree = map.containsValue(3); 
        
        //Remove by key
        Integer removed = map.remove("banana"); //3 (returns removed value)
        
        //Size
        int size = map.size();
        
        //Check if empty
        boolean empty = map.isEmpty(); 
        
        //Clear all entries
        map.clear();
        
        //Put if absent - only adds if key doesn't exist
        map.putIfAbsent("apple", 5); //Adds
        map.putIfAbsent("apple", 10); //Doesn't add, key exists
        
        //Replace methods
        map.replace("apple", 7); //Replaces value if key exists
        map.replace("apple", 5, 8); //Replaces only if current value is 5
    }

    //============================================================
    //LINKEDHASHMAP - USAGE (Insertion order maintained)
    //============================================================
    public static void linkedHashMapUsage() {
        //Maintains insertion order
        LinkedHashMap<String, Integer> map = new LinkedHashMap<>();
        map.put("first", 1);
        map.put("second", 2);
        map.put("third", 3);
        
        //Iteration preserves insertion order
        for(Map.Entry<String, Integer> entry : map.entrySet()) {
            System.out.println(entry.getKey() + ": " + entry.getValue());
            //Prints: first: 1, second: 2, third: 3
        }
        
        //Access-order LinkedHashMap (LRU cache pattern)
        LinkedHashMap<String, Integer> lruCache = new LinkedHashMap<>(16, 0.75f, true);
        lruCache.put("a", 1);
        lruCache.put("b", 2);
        lruCache.put("c", 3);
        lruCache.get("a"); //Moves "a" to end (most recently used)
        //Order now: b, c, a
    }

    //============================================================
    //TREEMAP - USAGE (Sorted by keys, implements NavigableMap)
    //============================================================
    public static void treeMapUsage() {
        //Keys sorted in natural order
        TreeMap<Integer, String> map = new TreeMap<>();
        map.put(3, "three");
        map.put(1, "one");
        map.put(2, "two");
        
        //Iteration in sorted key order
        for(Map.Entry<Integer, String> entry : map.entrySet()) {
            System.out.println(entry.getKey() + ": " + entry.getValue());
            //Prints: 1: one, 2: two, 3: three
        }
        
        //NavigableMap methods
        Integer firstKey = map.firstKey(); //1
        Integer lastKey = map.lastKey(); //3
        Integer lowerKey = map.lowerKey(2); //1 (greatest key < 2)
        Integer higherKey = map.higherKey(2); //3 (smallest key > 2)
        Integer floorKey = map.floorKey(2); //2 (greatest key <= 2)
        Integer ceilingKey = map.ceilingKey(2); //2 (smallest key >= 2)
        
        //Get entries with keys
        Map.Entry<Integer, String> firstEntry = map.firstEntry();
        Map.Entry<Integer, String> lastEntry = map.lastEntry();
        
        //Poll methods - retrieve and remove
        Map.Entry<Integer, String> pollFirst = map.pollFirstEntry();
        Map.Entry<Integer, String> pollLast = map.pollLastEntry();
        
        //Subset views
        TreeMap<Integer, String> allNums = new TreeMap<>();
        allNums.put(1, "one");
        allNums.put(2, "two");
        allNums.put(3, "three");
        allNums.put(4, "four");
        allNums.put(5, "five");
        
        Map<Integer, String> subMap = allNums.subMap(2, 4); //{2=two, 3=three}
        Map<Integer, String> headMap = allNums.headMap(3); //{1=one, 2=two}
        Map<Integer, String> tailMap = allNums.tailMap(3); //{3=three, 4=four, 5=five}
        
        //Descending order
        NavigableMap<Integer, String> descending = allNums.descendingMap();
        
        //Custom comparator - reverse order
        TreeMap<String, Integer> words = new TreeMap<>(Comparator.reverseOrder());
        words.put("apple", 1);
        words.put("banana", 2);
        words.put("cherry", 3);
        //Keys order: cherry, banana, apple
    }

    //============================================================
    //MAP OPERATIONS - USAGE
    //============================================================
    public static void mapOperationsUsage() {
        Map<String, Integer> map = new HashMap<>();
        map.put("a", 1);
        map.put("b", 2);
        map.put("c", 3);
        
        //Iterate through keys
        for(String key : map.keySet()) {
            System.out.println(key);
        }
        
        //Iterate through values
        for(Integer value : map.values()) {
            System.out.println(value);
        }
        
        //Iterate through entries (most common)
        for(Map.Entry<String, Integer> entry : map.entrySet()) {
            System.out.println(entry.getKey() + ": " + entry.getValue());
        }
        
        //forEach with lambda
        map.forEach((key, value) -> System.out.println(key + ": " + value));
        
        //Compute methods
        map.compute("a", (key, value) -> value + 10); //"a" = 11
        map.computeIfAbsent("d", key -> 4); //Adds "d" = 4
        map.computeIfPresent("b", (key, value) -> value * 2); //"b" = 4
        
        //Merge - combines values if key exists
        map.merge("a", 5, (oldVal, newVal) -> oldVal + newVal); //"a" = 16
        map.merge("e", 5, (oldVal, newVal) -> oldVal + newVal); //Adds "e" = 5
        
        //Replace all values
        map.replaceAll((key, value) -> value * 2);
        
        //Convert to different collection types
        Set<String> keys = map.keySet();
        Collection<Integer> values = map.values();
        Set<Map.Entry<String, Integer>> entries = map.entrySet();
        
        //Create from arrays
        String[] keyArray = {"x", "y", "z"};
        Integer[] valueArray = {1, 2, 3};
        Map<String, Integer> fromArrays = new HashMap<>();
        for(int i = 0; i < keyArray.length; i++) {
            fromArrays.put(keyArray[i], valueArray[i]);
        }
        
        //Stream operations
        Map<String, Integer> filtered = map.entrySet().stream()
            .filter(entry -> entry.getValue() > 5)
            .collect(Collectors.toMap(
                Map.Entry::getKey,
                Map.Entry::getValue
            ));
    }
}

