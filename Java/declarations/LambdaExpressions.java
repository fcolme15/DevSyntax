import java.util.*;
import java.util.function.*;

//============================================================
//LAMBDA BEST PRACTICES
//============================================================
//1. Keep lambdas short (1-3 lines ideally)
//2. Use method references when possible for clarity
//3. Don't modify variables from outer scope
//4. Use built-in functional interfaces when available
//5. Add @FunctionalInterface annotation to custom interfaces
//6. Prefer lambdas over anonymous classes for single method interfaces
//7. Be careful with exception handling in lambdas
//8. Use descriptive parameter names for clarity

//Examples of good vs bad:
//Good: list.forEach(System.out::println);
//Bad: list.forEach(item -> System.out.println(item));

//Good: numbers.stream().filter(n -> n > 0)
//Bad: numbers.stream().filter(n -> { return n > 0; })

//Good: Function<String, Integer> length = String::length;
//Bad: Function<String, Integer> length = s -> s.length();


public class LambdaExpressionsReference {
    public static void main(String[] args) {
        lambdaBasics();
        functionalInterfaces();
        builtInFunctionalInterfaces();
        methodReferences();
        lambdaWithCollections();
        lambdaScopes();
    }

    //============================================================
    //LAMBDA BASICS
    //============================================================
    public static void lambdaBasics() {
        //Traditional anonymous inner class -> replaced by lambda
        Runnable r1 = new Runnable() {
            @Override
            public void run() {
                System.out.println("Running with anonymous class");
            }
        };
        
        //Lambda expression - much more concise than above
        Runnable r2 = () -> System.out.println("Running with lambda");
        
        //Lambda with parameters
        Calculator add = (a, b) -> a + b;
        System.out.println(add.calculate(5, 3)); //8
        
        //Lambda with multiple statements - needs curly braces and return
        Calculator multiply = (a, b) -> {
            int result = a * b;
            System.out.println("Multiplying " + a + " and " + b);
            return result;
        };
        
        //Lambda with single parameter - parentheses optional
        StringProcessor upper = s -> s.toUpperCase();
        System.out.println(upper.process("hello")); //"HELLO"
        
        //Lambda with explicit types
        Calculator subtract = (int a, int b) -> a - b;
        
        //Lambda with no parameters
        Supplier greet = () -> "Hello World";
        System.out.println(greet.get());
    }

    //============================================================
    //FUNCTIONAL INTERFACES
    //============================================================
    public static void functionalInterfaces() {
        //Functional interface has exactly one abstract method
        //Can be represented by lambda
        
        //Custom functional interface
        Validator<String> notEmpty = s -> s != null && !s.isEmpty();
        System.out.println(notEmpty.validate("test")); //true
        System.out.println(notEmpty.validate("")); //false
        
        //Multiple parameters
        BiFunction<Integer, Integer, Integer> max = (a, b) -> a > b ? a : b;
        System.out.println(max.apply(5, 3)); //5
        
        //Complex lambda with multiple lines
        Transformer<String> formatter = input -> {
            String trimmed = input.trim();
            String capitalized = trimmed.substring(0, 1).toUpperCase() + trimmed.substring(1);
            return capitalized + "!";
        };
        System.out.println(formatter.transform("  hello")); //"Hello!"
    }

    //============================================================
    //BUILT-IN FUNCTIONAL INTERFACES (java.util.function)
    //============================================================
    public static void builtInFunctionalInterfaces() {
        //Predicate<T> - takes T, returns boolean
        Predicate<Integer> isEven = n -> n % 2 == 0;
        System.out.println(isEven.test(4)); //true
        System.out.println(isEven.test(5)); //false
        
        //Function<T, R> - takes T, returns R
        Function<String, Integer> stringLength = s -> s.length();
        System.out.println(stringLength.apply("hello")); //5
        
        //Consumer<T> - takes T, returns nothing
        Consumer<String> printer = s -> System.out.println("Value: " + s);
        printer.accept("test"); //"Value: test"
        
        //Supplier<T> - takes nothing, returns T
        Supplier<Double> randomValue = () -> Math.random();
        System.out.println(randomValue.get()); //Random number
        
        //BiPredicate<T, U> - takes T and U, returns boolean
        BiPredicate<String, Integer> hasLength = (s, len) -> s.length() == len;
        System.out.println(hasLength.test("hello", 5)); //true
        
        //BiFunction<T, U, R> - takes T and U, returns R
        BiFunction<Integer, Integer, String> format = (a, b) -> a + " + " + b + " = " + (a + b);
        System.out.println(format.apply(2, 3)); //"2 + 3 = 5"
        
        //BiConsumer<T, U> - takes T and U, returns nothing
        BiConsumer<String, Integer> print = (s, n) -> System.out.println(s + ": " + n);
        print.accept("Count", 42); //"Count: 42"
        
        //UnaryOperator<T> - takes T, returns T
        UnaryOperator<Integer> square = n -> n * n;
        System.out.println(square.apply(5)); //25
        
        //BinaryOperator<T> - takes two T, returns T
        BinaryOperator<Integer> sum = (a, b) -> a + b;
        System.out.println(sum.apply(10, 20)); //30
        
        //Combining predicates
        Predicate<Integer> isPositive = n -> n > 0;
        Predicate<Integer> isSmall = n -> n < 100;
        Predicate<Integer> isPositiveAndSmall = isPositive.and(isSmall);
        System.out.println(isPositiveAndSmall.test(50)); //true
        
        //Chaining functions
        Function<String, String> addExclamation = s -> s + "!";
        Function<String, String> makeUpper = s -> s.toUpperCase();
        Function<String, String> combined = addExclamation.andThen(makeUpper);
        System.out.println(combined.apply("hello")); //"HELLO!"
    }

    //============================================================
    //METHOD REFERENCES -> Shorter form to do some lambda functions
    //============================================================
    public static void methodReferences() {
        //Reference to static method - ClassName::methodName
        //Lambda form:
        Function<String, Integer> parseInt1 = s -> Integer.parseInt(s);
        //Method reference form:
        Function<String, Integer> parseInt2 = Integer::parseInt;
        System.out.println(parseInt2.apply("42")); //42
        
        //Reference to instance method of particular object - instance::methodName
        String str = "hello";
        //Lambda form:
        Supplier<String> upperCase1 = () -> str.toUpperCase();
        //Method reference form:
        Supplier<String> upperCase2 = str::toUpperCase;
        System.out.println(upperCase2.get()); //"HELLO"
        
        //Reference to instance method of arbitrary object - ClassName::methodName
        //Lambda form:
        Function<String, Integer> length1 = s -> s.length();
        //Method reference form:
        Function<String, Integer> length2 = String::length;
        System.out.println(length2.apply("test")); //4
        
        //Reference to constructor - ClassName::new
        //Lambda form:
        Supplier<List<String>> listSupplier1 = () -> new ArrayList<>();
        //Method reference form:
        Supplier<List<String>> listSupplier2 = ArrayList::new;
        List<String> list = listSupplier2.get();
        
        //Lambda form:
        Function<Integer, int[]> arrayCreator1 = size -> new int[size];
        //Method reference form:
        Function<Integer, int[]> arrayCreator2 = int[]::new;
        int[] array = arrayCreator2.apply(5); //Creates int[5]
        
        //Using method references with collections
        List<String> words = Arrays.asList("apple", "banana", "cherry");
        //Lambda form:
        words.forEach(word -> System.out.println(word));
        //Method reference form:
        words.forEach(System.out::println);
        
        //Method reference for comparator
        List<String> names = Arrays.asList("John", "Alice", "Bob");
        //Lambda form:
        names.sort((a, b) -> a.compareToIgnoreCase(b));
        //Method reference form:
        names.sort(String::compareToIgnoreCase);
        
        //Method reference for mapping
        //Lambda form:
        List<Integer> lengths1 = words.stream().map(s -> s.length()).toList();
        //Method reference form:
        List<Integer> lengths2 = words.stream().map(String::length).toList();
    }

    //============================================================
    //LAMBDAS WITH COLLECTIONS
    //============================================================
    public static void lambdaWithCollections() {
        List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
        
        //forEach with lambda
        numbers.forEach(n -> System.out.println(n));
        numbers.forEach(System.out::println); //Method reference
        
        //removeIf with lambda
        List<Integer> mutable = new ArrayList<>(numbers);
        mutable.removeIf(n -> n % 2 == 0); //Remove even numbers
        
        //sort with lambda
        List<String> words = new ArrayList<>(Arrays.asList("banana", "apple", "cherry"));
        words.sort((a, b) -> a.compareTo(b)); //Ascending
        words.sort((a, b) -> b.compareTo(a)); //Descending
        words.sort(Comparator.comparingInt(String::length)); //By length
        
        //replaceAll with lambda
        List<String> items = new ArrayList<>(Arrays.asList("a", "b", "c"));
        items.replaceAll(s -> s.toUpperCase()); //["A", "B", "C"]
        
        //Stream operations with lambdas
        List<Integer> evenSquares = numbers.stream()
            .filter(n -> n % 2 == 0)
            .map(n -> n * n)
            .toList();
        
        //Map operations with lambdas
        Map<String, Integer> map = new HashMap<>();
        map.put("a", 1);
        map.put("b", 2);
        
        map.forEach((key, value) -> System.out.println(key + ": " + value));
        
        //computeIfAbsent with lambda
        map.computeIfAbsent("c", k -> 3);
        
        //merge with lambda
        map.merge("a", 10, (oldVal, newVal) -> oldVal + newVal);
    }

    //============================================================
    //LAMBDA SCOPES AND CLOSURES
    //============================================================
    public static void lambdaScopes() {
        //Lambda can access local variables -> becomes final or causes compilation error
        String prefix = "Hello";
        Function<String, String> greeter = name -> prefix + " " + name;
        System.out.println(greeter.apply("World")); //"Hello World"
        
        //prefix = "Hi"; //Compilation error - cannot modify variable used in lambda
        
        //Lambda can access instance variables
        int multiplier = 2;
        UnaryOperator<Integer> multiply = n -> n * multiplier;
        System.out.println(multiply.apply(5)); //10
        
        //Lambda can access and modify instance variables
        final List<String> results = new ArrayList<>();
        Consumer<String> addResult = s -> results.add(s); //Can modify list contents
        addResult.accept("test");
        
        //this keyword in lambda refers to enclosing class
        //Unlike anonymous class where this refers to the anonymous class itself
        
        //Effectively final variables
        int value = 10;
        Runnable r = () -> System.out.println(value); //OK - value is effectively final
        //value = 20; //Would cause compilation error in lambda above
    }
    
    //Static method for method reference examples
    public static String convertToUpper(String str) {
        return str.toUpperCase();
    }
    
    //Instance method for method reference examples
    public void printMessage(String msg) {
        System.out.println("Message: " + msg);
    }
}

//============================================================
//CUSTOM FUNCTIONAL INTERFACES
//============================================================
@FunctionalInterface
interface Calculator {
    int calculate(int a, int b);
}

@FunctionalInterface
interface StringProcessor {
    String process(String input);
}

@FunctionalInterface
interface Supplier {
    String get();
}

@FunctionalInterface
interface Validator<T> {
    boolean validate(T value);
}

@FunctionalInterface
interface Transformer<T> {
    T transform(T input);
}