import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class ArrayListReference {
    public static void main(String[] args) {
        arrayListCreation();
        arrayListAccess();
        arrayListModification();
        arrayListIteration();
        arrayListSearching();
        arrayListSorting();
        arrayListConversion();
        arrayListUtilityMethods();
    }

    //============================================================
    //ARRAYLIST CREATION
    //============================================================
    public static void arrayListCreation() {
        
        ArrayList<Integer> numbers = new ArrayList<>(); //Empty list
        ArrayList<String> words = new ArrayList<String>(); //Explicit type (redundant after Java 7)
        
        //Create with initial capacity (optimization, not size)
        ArrayList<Integer> optimized = new ArrayList<>(100); //Still size 0, but capacity 100
        
        //Create from another collection
        ArrayList<Integer> copy = new ArrayList<>(numbers);
        
        //Using Arrays.asList() - creates fixed-size list
        List<String> fixedList = Arrays.asList("a", "b", "c"); //Cannot add/remove elements
        ArrayList<String> mutableList = new ArrayList<>(Arrays.asList("a", "b", "c")); //Can modify
        
        //Using List.of() - creates immutable list (Java 9+)
        List<String> immutable = List.of("x", "y", "z"); //Cannot modify at all
        ArrayList<String> fromImmutable = new ArrayList<>(List.of("x", "y", "z")); //Can modify
        
        //Interface reference (recommended for flexibility)
        List<Integer> numbers2 = new ArrayList<>(); //ArrayList implements List
    }

    //============================================================
    //ARRAYLIST ACCESS
    //============================================================
    public static void arrayListAccess() {
        ArrayList<String> fruits = new ArrayList<>(Arrays.asList("apple", "banana", "cherry"));
        
        //Get element by index
        String first = fruits.get(0); //"apple"
        String last = fruits.get(fruits.size() - 1); //"cherry"
        
        //Size of list
        int size = fruits.size(); //3
        
        //Check if empty
        boolean empty = fruits.isEmpty(); //false
        
        //Check if contains element
        boolean hasOrange = fruits.contains("orange"); //false
        
        //Get index of element
        int notFound = fruits.indexOf("orange"); //-1 if not found
        
        //Last index of element (useful for duplicates)
        ArrayList<Integer> nums = new ArrayList<>(Arrays.asList(1, 2, 3, 2, 4));
        int lastTwo = nums.lastIndexOf(2); //3
        
        //Access throws IndexOutOfBoundsException if index invalid
    }

    //============================================================
    //ARRAYLIST MODIFICATION
    //============================================================
    public static void arrayListModification() {
        ArrayList<String> list = new ArrayList<>();
        
        //Add elements
        list.add("first"); //Adds to end
        list.add("second");
        list.add(0, "zero"); //Insert at specific index, shifts others right
        
        //Add multiple elements
        list.addAll(Arrays.asList("a", "b", "c")); //Add collection to end
        list.addAll(1, Arrays.asList("x", "y")); //Insert collection at index
        
        //Set/replace element at index
        list.set(0, "ZERO"); //Returns old value
        
        //Remove elements
        list.remove(0); //Remove by index, returns removed element
        list.remove("second"); //Remove by value, returns true if found and removed
        
        //Remove multiple elements
        list.removeAll(Arrays.asList("a", "b")); //Remove all occurrences of specified elements
        
        //Remove if condition met (Java 8+)
        list.removeIf(s -> s.length() > 3); //Removes elements where condition is true
        
        //Retain only specified elements
        list.retainAll(Arrays.asList("x", "y", "z")); //Keeps only these, removes everything else
        
        //Clear all elements
        list.clear(); //Size becomes 0
        
        //Replace all elements (Java 8+)
        ArrayList<String> words = new ArrayList<>(Arrays.asList("a", "b", "c"));
        words.replaceAll(String::toUpperCase); //["A", "B", "C"]
    }

    //============================================================
    //ARRAYLIST ITERATION
    //============================================================
    public static void arrayListIteration() {
        ArrayList<String> items = new ArrayList<>(Arrays.asList("a", "b", "c", "d"));
        
        
        //forEach with lambda (Java 8+)
        items.forEach(item -> System.out.println(item));
        items.forEach(System.out::println); //Method reference
        
        //Iterator
        var iterator = items.iterator();
        while(iterator.hasNext()) {
            String item = iterator.next();
            System.out.println(item);
            //Can safely remove during iteration
            if(item.equals("b")) {
                iterator.remove();
            }
        }
        
        //ListIterator (bidirectional)
        var listIterator = items.listIterator();
        while(listIterator.hasNext()) {
            System.out.println(listIterator.next());
        }
        while(listIterator.hasPrevious()) {
            System.out.println(listIterator.previous());
        }
        
        //Stream operations (Java 8+)
        items.stream().filter(s -> s.length() > 1).forEach(System.out::println);
    }

    //============================================================
    //ARRAYLIST SEARCHING
    //============================================================
    public static void arrayListSearching() {
        ArrayList<Integer> numbers = new ArrayList<>(Arrays.asList(5, 2, 8, 1, 9, 3));
        
        //Linear search using contains
        boolean hasValue = numbers.contains(8); //true
        
        //Find index
        int index = numbers.indexOf(8); //2
        
        //Binary search (must be sorted first)
        Collections.sort(numbers); //[1, 2, 3, 5, 8, 9]
        int binaryIndex = Collections.binarySearch(numbers, 5); //Returns index if found
        int notFound = Collections.binarySearch(numbers, 7); //Negative value if not found
        
        //Find first match using stream (Java 8+)
        Integer firstEven = numbers.stream().filter(n -> n % 2 == 0).findFirst().orElse(null);
        
        //Check if any element matches condition
        boolean hasEven = numbers.stream().anyMatch(n -> n % 2 == 0); //true
        
        //Check if all elements match condition
        boolean allPositive = numbers.stream().allMatch(n -> n > 0); //true
        
        //Count elements matching condition
        long evenCount = numbers.stream().filter(n -> n % 2 == 0).count();
    }

    //============================================================
    //ARRAYLIST SORTING
    //============================================================
    public static void arrayListSorting() {
        ArrayList<Integer> numbers = new ArrayList<>(Arrays.asList(5, 2, 8, 1, 9, 3));
        
        //Sort natural order (modifies original)
        Collections.sort(numbers); //[1, 2, 3, 5, 8, 9]
        
        //Sort reverse order
        Collections.sort(numbers, Collections.reverseOrder()); //[9, 8, 5, 3, 2, 1]
        
        //Reverse list
        Collections.reverse(numbers); //Reverses current order
        
        //Sort using list method (Java 8+)
        numbers.sort(null); //Natural order
        numbers.sort(Collections.reverseOrder()); //Reverse order
        
        //Custom comparator
        ArrayList<String> words = new ArrayList<>(Arrays.asList("apple", "pie", "banana"));
        words.sort((a, b) -> a.length() - b.length()); //Sort by length
        words.sort((a, b) -> b.compareTo(a)); //Reverse alphabetical
        
        //Shuffle randomly
        Collections.shuffle(numbers);
        
        //Rotate elements
        Collections.rotate(numbers, 2); //Rotate right by 2 positions
        
        //Min and max
        int min = Collections.min(numbers);
        int max = Collections.max(numbers);
        
        //Frequency count
        int freq = Collections.frequency(numbers, 5); //Count occurrences of 5
    }

    //============================================================
    //ARRAYLIST CONVERSION
    //============================================================
    public static void arrayListConversion() {
        //ArrayList to Array
        ArrayList<String> list = new ArrayList<>(Arrays.asList("a", "b", "c"));
        
        //Method 1: toArray() returns Object[]
        Object[] objArray = list.toArray();
        
        //Method 2: toArray(T[]) returns typed array
        String[] strArray = list.toArray(new String[0]); //Preferred, size 0 is convention
        String[] strArray2 = list.toArray(new String[list.size()]); //Also works
        
        //Array to ArrayList
        String[] array = {"x", "y", "z"};
        ArrayList<String> fromArray = new ArrayList<>(Arrays.asList(array));
        
        //Primitive array to ArrayList (requires boxing)
        int[] primitives = {1, 2, 3, 4, 5};
        ArrayList<Integer> fromPrimitives = new ArrayList<>();
        for(int num : primitives) {
            fromPrimitives.add(num); //Autoboxing
        }
        
        //Using streams (Java 8+)
        ArrayList<Integer> fromPrimStream = new ArrayList<>();
        Arrays.stream(primitives).forEach(fromPrimStream::add);
        
        //ArrayList to String
        String joined = String.join(", ", list); //"a, b, c"
        
        //Convert to different collection type
        ArrayList<String> arrayList = new ArrayList<>(Arrays.asList("a", "b", "c"));
        List<String> unmodifiable = Collections.unmodifiableList(arrayList);
    }

    //============================================================
    //ARRAYLIST UTILITY METHODS
    //============================================================
    public static void arrayListUtilityMethods() {
        ArrayList<Integer> numbers = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));
        
        //Clone (shallow copy)
        ArrayList<Integer> clone = (ArrayList<Integer>) numbers.clone();
        
        //SubList (view, not independent copy)
        List<Integer> subList = numbers.subList(1, 4); //[2, 3, 4], changes affect original
        
        //Fill with specific value
        Collections.fill(numbers, 0); //All elements become 0
        
        //Replace all occurrences
        Collections.replaceAll(numbers, 0, 99); //Replace all 0s with 99
        
        //Swap elements
        Collections.swap(numbers, 0, 4); //Swap elements at index 0 and 4
        
        //Copy one list to another (sizes must match)
        ArrayList<Integer> dest = new ArrayList<>(Arrays.asList(0, 0, 0, 0, 0));
        Collections.copy(dest, numbers); //Copies numbers into dest, overwrites elements
        
        //Add single element multiple times
        ArrayList<String> repeated = new ArrayList<>(Collections.nCopies(5, "x")); //["x", "x", "x", "x", "x"]
        
        //Disjoint check (no common elements)
        ArrayList<Integer> list1 = new ArrayList<>(Arrays.asList(1, 2, 3));
        ArrayList<Integer> list2 = new ArrayList<>(Arrays.asList(4, 5, 6));
        boolean disjoint = Collections.disjoint(list1, list2); //true
        
        //Get as stream and perform operations (Java 8+)
        int sum = numbers.stream().mapToInt(Integer::intValue).sum();
        List<Integer> doubled = numbers.stream().map(n -> n * 2).toList();
        
        //Ensure capacity (optimization)
        numbers.ensureCapacity(1000); //Ensures internal array can hold at least 1000 elements
        
        //Trim to size (free unused capacity)
        numbers.trimToSize(); //Reduces capacity to current size
    }
}