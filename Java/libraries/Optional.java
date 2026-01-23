import java.util.*;

public class OptionalReference {
    public static void main(String[] args) {
        optionalCreationUsage();
        optionalAccessUsage();
        optionalTransformationUsage();
        optionalFilteringUsage();
        optionalChainingUsage();
    }

    //============================================================
    //OPTIONAL CREATION - USAGE
    //============================================================
    public static void optionalCreationUsage() {
        //Create Optional with value
        Optional<String> withValue = Optional.of("Hello");
        
        //Create Optional that may be null
        String nullableValue = null;
        Optional<String> maybeValue = Optional.ofNullable(nullableValue); //Empty Optional
        Optional<String> maybeValue2 = Optional.ofNullable("World"); //Optional with value
        
        //Create empty Optional
        Optional<String> empty = Optional.empty();
        
        //Optional.of() with null throws NullPointerException
        //Optional<String> invalid = Optional.of(null); //NullPointerException
    }

    //============================================================
    //OPTIONAL ACCESS - USAGE
    //============================================================
    public static void optionalAccessUsage() {
        Optional<String> optional = Optional.of("Hello");
        Optional<String> empty = Optional.empty();
        
        //Check if value is present
        boolean hasValue = optional.isPresent(); //true
        boolean isEmpty = empty.isEmpty(); //true (Java 11+)
        
        //Get value (throws NoSuchElementException if empty)
        String value = optional.get(); //"Hello"
        //String invalid = empty.get(); //NoSuchElementException
        
        //Get value or default
        String result1 = optional.orElse("Default"); //"Hello"
        String result2 = empty.orElse("Default"); //"Default"
        
        //Get value or compute default (lazy evaluation)
        String result3 = empty.orElseGet(() -> "Computed Default");
        String result4 = empty.orElseGet(() -> expensiveOperation()); //Only called if empty
        
        //Get value or throw exception
        String result5 = optional.orElseThrow(); //"Hello"
        //String invalid = empty.orElseThrow(); //NoSuchElementException
        
        //Get value or throw custom exception
        String result6 = optional.orElseThrow(() -> new IllegalStateException("No value"));
        //empty.orElseThrow(() -> new IllegalStateException("Missing")); //Throws custom exception
    }

    //============================================================
    //OPTIONAL TRANSFORMATION - USAGE
    //============================================================
    public static void optionalTransformationUsage() {
        Optional<String> optional = Optional.of("hello");
        
        //map - transform value if present
        Optional<String> upperCase = optional.map(String::toUpperCase); //"HELLO"
        Optional<Integer> length = optional.map(String::length); //5
        
        //map on empty Optional returns empty
        Optional<String> empty = Optional.empty();
        Optional<Integer> noLength = empty.map(String::length); //Empty Optional
        
        //flatMap - transform to Optional (avoid Optional<Optional<T>>)
        Optional<String> name = Optional.of("Alice");
        Optional<String> email = name.flatMap(n -> findEmail(n)); //Returns Optional<String>
        
        //Without flatMap - nested Optional
        //Optional<Optional<String>> nested = name.map(n -> findEmail(n)); //Wrong

        //Fitering
        Optional<Integer> number = Optional.of(42);
        
        //filter - keep value if predicate matches
        Optional<Integer> even = number.filter(n -> n % 2 == 0); //Optional with 42
        Optional<Integer> odd = number.filter(n -> n % 2 == 1); //Empty Optional
        
        //Chaining filter
        Optional<Integer> result = number
            .filter(n -> n > 0)
            .filter(n -> n < 100)
            .filter(n -> n % 2 == 0); //Optional with 42
        
        //filter on empty Optional returns empty
        Optional<Integer> empty = Optional.empty();
        Optional<Integer> filtered = empty.filter(n -> n > 0); //Empty Optional

    }

    //============================================================
    //OPTIONAL CHAINING - USAGE
    //============================================================
    public static void optionalChainingUsage() {
        Optional<String> name = Optional.of("alice");
        
        //Chain operations
        String result = name
            .map(String::toUpperCase)
            .map(s -> s + "!")
            .filter(s -> s.length() > 5)
            .orElse("Default"); //"ALICE!"
        
        //ifPresent - perform action if value exists
        name.ifPresent(n -> System.out.println("Name: " + n));
        
        //ifPresentOrElse - perform action or else action (Java 9+)
        name.ifPresentOrElse(
            n -> System.out.println("Found: " + n),
            () -> System.out.println("Not found")
        );
        
        //or - provide alternative Optional (Java 9+)
        Optional<String> empty = Optional.empty();
        Optional<String> alternative = empty.or(() -> Optional.of("Fallback"));
        
        //stream - convert to Stream (Java 9+)
        List<String> names = name.stream().toList(); //["alice"]
        List<String> emptyList = Optional.<String>empty().stream().toList(); //[]
    }
    
    //Helper method for examples
    private static String expensiveOperation() {
        return "Expensive result";
    }
    
    private static Optional<String> findEmail(String name) {
        return Optional.of(name + "@email.com");
    }
}
