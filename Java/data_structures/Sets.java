import java.util.*;

//HashSet:
//- Fastest performance for add, remove, contains
//- No ordering guarantees
//- Use when order doesn't matter

//LinkedHashSet:
//- Maintains insertion order
//- Slightly slower than HashSet
//- Use when you need predictable iteration order

//TreeSet:
//- Sorted order (natural or custom comparator)
//- Slower than HashSet (O(log n) operations)
//- Provides NavigableSet methods (first, last, higher, lower, etc.)
//- Use when you need sorted elements or range operations

public class SetReference {
    public static void main(String[] args) {
        hashSetUsage();
        linkedHashSetUsage();
        treeSetUsage();
        setOperationsUsage();
    }

    //============================================================
    //HASHSET - USAGE (No order, fastest)
    //============================================================
    public static void hashSetUsage() {
        //Creation
        HashSet<String> set = new HashSet<>();
        Set<String> set2 = new HashSet<>(); //Preferred - interface reference
        
        //Add elements
        set.add("apple");
        set.add("banana");
        set.add("apple"); //Duplicate - not added
        System.out.println(set.size()); //2
        
        //Check if contains
        boolean hasApple = set.contains("apple"); //true
        
        //Remove element
        set.remove("banana");
        
        //Check if empty
        boolean empty = set.isEmpty(); //false
        
        //Clear all elements
        set.clear();
        
        //Create from collection
        List<Integer> list = Arrays.asList(1, 2, 3, 2, 1);
        Set<Integer> fromList = new HashSet<>(list); //[1, 2, 3]
        
        //Iterate - order not guaranteed
        for(String item : set) {
            System.out.println(item);
        }
    }

    //============================================================
    //LINKEDHASHSET - USAGE (Insertion order maintained)
    //Same operations as the HashSet
    //============================================================
    public static void linkedHashSetUsage() {
        //Maintains insertion order
        LinkedHashSet<String> set = new LinkedHashSet<>();
        set.add("first");
        set.add("second");
        set.add("third");
        
        //Iteration preserves insertion order
        for(String item : set) {
            System.out.println(item); //Prints: first, second, third
        }
    }

    //============================================================
    //TREESET - USAGE (Sorted order, implements NavigableSet)
    //============================================================
    public static void treeSetUsage() {
        //Elements sorted in natural order
        TreeSet<Integer> numbers = new TreeSet<>();
        numbers.add(5);
        numbers.add(1);
        numbers.add(3);
        
        //Iteration in sorted order
        for(int num : numbers) {
            System.out.println(num); //Prints: 1, 3, 5
        }
        
        //NavigableSet methods
        Integer first = numbers.first(); //1
        Integer last = numbers.last(); //5
        Integer lower = numbers.lower(3); //1 (greatest element < 3)
        Integer higher = numbers.higher(3); //5 (smallest element > 3)
        Integer floor = numbers.floor(4); //3 (greatest element <= 4)
        Integer ceiling = numbers.ceiling(2); //3 (smallest element >= 2)
        
        //Poll methods - retrieve and remove
        Integer pollFirst = numbers.pollFirst(); //Removes and returns 1
        Integer pollLast = numbers.pollLast(); //Removes and returns 5
        
        //Subset views
        TreeSet<Integer> allNums = new TreeSet<>(Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9));
        Set<Integer> subset = allNums.subSet(3, 7); //[3, 4, 5, 6] - excludes 7
        Set<Integer> headSet = allNums.headSet(5); //[1, 2, 3, 4] - less than 5
        Set<Integer> tailSet = allNums.tailSet(5); //[5, 6, 7, 8, 9] - >= 5
        
        //Descending order
        NavigableSet<Integer> descending = allNums.descendingSet();
        
        //Custom comparator
        TreeSet<String> words = new TreeSet<>(Comparator.reverseOrder());
        words.add("apple");
        words.add("banana");
        words.add("cherry");
        //Iteration: cherry, banana, apple
    }

    //============================================================
    //SET OPERATIONS - USAGE
    //============================================================
    public static void setOperationsUsage() {
        Set<Integer> set1 = new HashSet<>(Arrays.asList(1, 2, 3, 4, 5));
        Set<Integer> set2 = new HashSet<>(Arrays.asList(4, 5, 6, 7, 8));
        
        //Union - all elements from both sets
        Set<Integer> union = new HashSet<>(set1);
        union.addAll(set2); //[1, 2, 3, 4, 5, 6, 7, 8]
        
        //Intersection - common elements
        Set<Integer> intersection = new HashSet<>(set1);
        intersection.retainAll(set2); //[4, 5]
        
        //Difference - elements in set1 but not in set2
        Set<Integer> difference = new HashSet<>(set1);
        difference.removeAll(set2); //[1, 2, 3]
        
        //Check if subset
        Set<Integer> subset = new HashSet<>(Arrays.asList(1, 2));
        boolean isSubset = set1.containsAll(subset); //true
        
        //Check if disjoint (no common elements)
        Set<Integer> set3 = new HashSet<>(Arrays.asList(10, 11));
        boolean disjoint = Collections.disjoint(set1, set3); //true
        
        //Convert to array
        Integer[] array = set1.toArray(new Integer[0]);
        
        //Convert to list
        List<Integer> list = new ArrayList<>(set1);
        
        //Stream operations
        Set<Integer> evens = set1.stream()
            .filter(n -> n % 2 == 0)
            .collect(Collectors.toSet());
    }
}
