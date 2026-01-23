import org.javatuples.*;

//Note: Add JavaTuples dependency to your project
//Maven: <dependency>
//         <groupId>org.javatuples</groupId>
//         <artifactId>javatuples</artifactId>
//         <version>1.2</version>
//       </dependency>

//============================================================
//KEY FEATURES
//============================================================
//- Type-safe
//- Immutable (setters return new tuple)
//- Iterable
//- Serializable
//- Comparable (if all elements are Comparable)
//- Implements equals() and hashCode()
//- getValue0() through getValue9() methods
//- setAt0() through setAt9() methods
//- Can convert to/from List and Array
//- Can add/remove elements (returns different size tuple)

public class JavaTuplesLibraryReference {
    public static void main(String[] args) {
        pairUsage();
        tripletUsage();
        quartetAndBeyondUsage();
        tupleOperationsUsage();
    }

    //============================================================
    //PAIR (2 elements) - USAGE
    //============================================================
    public static void pairUsage() {
        //Create Pair
        Pair<String, Integer> pair = new Pair<>("Alice", 25);
        Pair<String, Integer> pair2 = Pair.with("Bob", 30);
        
        //Access elements - type-safe getters
        String name = pair.getValue0(); //"Alice"
        Integer age = pair.getValue1(); //25
        
        //Set values (returns new Pair, immutable)
        Pair<String, Integer> modified = pair.setAt0("Charlie");
        Pair<String, Integer> modified2 = pair.setAt1(35);
        
        //Contains check
        boolean hasAlice = pair.contains("Alice"); //true
        boolean hasValue = pair.containsAll("Alice", 25); //true
        
        //Size
        int size = pair.getSize(); //2
        
        //Convert to List
        List<Object> list = pair.toList(); //["Alice", 25]
        
        //Convert to Array
        Object[] array = pair.toArray(); //["Alice", 25]
    }

    //============================================================
    //TRIPLET (3 elements) - USAGE
    //============================================================
    public static void tripletUsage() {
        //Create Triplet
        Triplet<String, Integer, String> person = new Triplet<>("Alice", 25, "Engineer");
        Triplet<String, Integer, String> person2 = Triplet.with("Bob", 30, "Manager");
        
        //Access elements
        String name = person.getValue0(); //"Alice"
        Integer age = person.getValue1(); //25
        String job = person.getValue2(); //"Engineer"
        
        //Set values (returns new Triplet)
        Triplet<String, Integer, String> modified = person.setAt0("Charlie");
        Triplet<String, Integer, String> modified2 = person.setAt1(35);
        Triplet<String, Integer, String> modified3 = person.setAt2("Developer");
        
        //Contains
        boolean hasAlice = person.contains("Alice"); //true
    }

    //============================================================
    //QUARTET AND BEYOND - USAGE
    //============================================================
    public static void quartetAndBeyondUsage() {
        //Quartet (4 elements)
        Quartet<String, Integer, String, Boolean> quartet = 
            Quartet.with("Alice", 25, "Engineer", true);
        String val0 = quartet.getValue0();
        Integer val1 = quartet.getValue1();
        String val2 = quartet.getValue2();
        Boolean val3 = quartet.getValue3();
        
        //Quintet (5 elements)
        Quintet<String, Integer, String, Boolean, Double> quintet = 
            Quintet.with("Alice", 25, "Engineer", true, 50000.0);
        
        //Unit - 1 element
        //Pair - 2 elements
        //Triplet - 3 elements
        //Quartet - 4 elements
        //Quintet - 5 elements
        //Sextet - 6 elements
        //Septet - 7 elements
        //Octet - 8 elements
        //Ennead - 9 elements
        //Decade - 10 elements

        //All follow same pattern: getValue0() through getValue[N-1]()
    }
}

