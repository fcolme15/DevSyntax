import java.util.*;

//============================================================
//GENERIC RESTRICTIONS
//============================================================
//Cannot do:
//1. Create instances of type parameters: new T()
//2. Create arrays of parameterized types: new T[10]
//3. Use primitives as type parameters: Box<int>
//4. Create static fields of type parameter: static T value;
//5. Use instanceof with parameterized types: obj instanceof Box<Integer>
//6. Create generic exception classes
//7. Overload methods where types erase to same signature

//============================================================
//GENERIC CLASS DEFINITIONS
//============================================================
class Box<T> {
    private T value;
    
    public Box(T value) { //Contructor
        this.value = value;
    }
    
    public T get() {
        return value;
    }
    
    public void set(T value) {
        this.value = value;
    }
}

//Multiple type parameters
class Pair<K, V> {
    private K first;
    private V second;
    
    public Pair(K first, V second) { //Contructor
        this.first = first;
        this.second = second;
    }
    
    public K getFirst() {
        return first;
    }
    
    public V getSecond() {
        return second;
    }
}

//============================================================
//BOUNDED TYPE PARAMETER DEFINITIONS
//============================================================
//Upper bound - T must extend Number
class NumberBox<T extends Number> {
    private T value;
    
    public NumberBox(T value) {
        this.value = value;
    }
    
    public double doubleValue() {
        return value.doubleValue(); //Can call Number methods
    }
}

//Multiple bounds - must implement both interfaces
class ComparableBox<T extends Comparable<T> & java.io.Serializable> {
    private T value;
    
    public ComparableBox(T value) {
        this.value = value;
    }
    
    public boolean isGreaterThan(T other) {
        return value.compareTo(other) > 0;
    }
}

//============================================================
//USING GENERIC CLASSES
//============================================================
public class GenericsReference {
    public static void main(String[] args) {
        genericClassesUsage();
        genericMethodsUsage();
        boundedTypeParametersUsage();
        wildcardsUsage();
        typeErasureUsage();
    }

    //============================================================
    //GENERIC CLASSES - USAGE
    //============================================================
    public static void genericClassesUsage() {
        //Single type parameter
        Box<Integer> intBox = new Box<>(42);
        Box<String> strBox = new Box<>("Hello");
        
        //Multiple type parameters
        Pair<String, Integer> pair = new Pair<>("Age", 25);
        
        //Cannot use primitives - must use wrapper classes
        //Box<int> invalid = new Box<>(5); //Compilation error
        Box<Integer> valid = new Box<>(5); //Correct
    }

    //============================================================
    //GENERIC METHODS - USAGE
    //============================================================
    public static void genericMethodsUsage() {
        Integer[] intArray = {1, 2, 3, 4, 5};
        String[] strArray = {"a", "b", "c"};
        
        //Type inferred automatically
        printArray(intArray);
        printArray(strArray);
        
        //Explicit type specification (rarely needed)
        GenericsReference.<Integer>printArray(intArray);
        
        
        Integer firstInt = getFirst(intArray); //Generic method with return value
        boolean same = areEqual(5, 5); //Multiple type parameters
    }

    //============================================================
    //BOUNDED TYPE PARAMETERS - USAGE
    //============================================================
    public static void boundedTypeParametersUsage() {
        //Upper bound - T must extend Number
        NumberBox<Integer> intBox = new NumberBox<>(42);
        NumberBox<Double> doubleBox = new NumberBox<>(3.14);
        //NumberBox<String> invalid = new NumberBox<>("text"); //Compilation error
        
        //Multiple bounds - T must implement Comparable AND Serializable
        ComparableBox<Integer> compBox = new ComparableBox<>(5);
        
        //Bounded generic method
        Integer[] numbers = {1, 5, 3, 9, 2};
        Integer max = findMax(numbers); //9
    }

    //============================================================
    //WILDCARDS - USAGE
    //============================================================
    //Used when we want to use the value of a variable which we don't care about
    //the exact type but we dont need to declare variables of that type
    public static void wildcardsUsage() {
        List<Integer> intList = Arrays.asList(1, 2, 3);
        List<Double> doubleList = Arrays.asList(1.1, 2.2, 3.3);
        
        //Unbounded wildcard <?> - accepts any type
        printList(intList);
        printList(doubleList);
        
        //Upper bounded wildcard <? extends Number> - Number or subtypes
        sumNumbers(intList); //Works
        sumNumbers(doubleList); //Works
        
        //Lower bounded wildcard <? super Integer> - Integer or supertypes
        List<Number> numbers = new ArrayList<>();
        addIntegers(numbers); //Works
    }

    //============================================================
    //TYPE ERASURE - USAGE
    //============================================================
    public static void typeErasureUsage() {
        //Generic type info is erased at runtime
        Box<Integer> intBox = new Box<>(5);
        Box<String> strBox = new Box<>("text");
        
        //Both have same class at runtime
        System.out.println(intBox.getClass() == strBox.getClass()); //true
        
        //Cannot check generic type at runtime
        //if(intBox instanceof Box<Integer>) {} //Compilation error
        if(intBox instanceof Box<?>) {} //Works with wildcard
        
        //Cannot create generic array
        //Box<Integer>[] array = new Box<Integer>[10]; //Compilation error
        Box<?>[] array = new Box<?>[10]; //Works with wildcard
    }
    
    //============================================================
    //GENERIC METHOD DEFINITIONS
    //============================================================
    public static <T> void printArray(T[] array) {
        for(T element : array) {
            System.out.print(element + " ");
        }
        System.out.println();
    }
    
    public static <T> T getFirst(T[] array) {
        return (array.length > 0) ? array[0] : null;
    }
    
    public static <T, U> boolean areEqual(T first, U second) {
        return first.equals(second);
    }
    
    public static <T extends Comparable<T>> T findMax(T[] array) {
        if(array.length == 0) return null;
        T max = array[0];
        for(int i = 1; i < array.length; i++) {
            if(array[i].compareTo(max) > 0) {
                max = array[i];
            }
        }
        return max;
    }
    
    //============================================================
    //WILDCARD METHOD DEFINITIONS
    //============================================================
    public static void printList(List<?> list) {
        for(Object obj : list) {
            System.out.println(obj);
        }
        //Cannot add elements except null
        //list.add("item"); //Compilation error
    }
    
    public static double sumNumbers(List<? extends Number> list) {
        double sum = 0;
        for(Number num : list) {
            sum += num.doubleValue();
        }
        return sum;
    }
    
    public static void addIntegers(List<? super Integer> list) {
        list.add(1);
        list.add(2);
        list.add(3);
    }
}