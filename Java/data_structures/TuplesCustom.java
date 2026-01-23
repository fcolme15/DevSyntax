import java.util.*;

public class TuplesReference {
    public static void main(String[] args) {
        pairUsage();
        tripleUsage();
        mapEntryAsPairUsage();
    }

    //============================================================
    //PAIR (2 elements) - USAGE
    //============================================================
    public static void pairUsage() {
        //Java has no built-in Pair class, must create your own
        Pair<String, Integer> pair = new Pair<>("Alice", 25);
        
        //Access elements
        String name = pair.getFirst(); //"Alice"
        Integer age = pair.getSecond(); //25
        
        //Modify elements
        pair.setFirst("Bob");
        pair.setSecond(30);
        
        //Use in collections
        List<Pair<String, Integer>> people = new ArrayList<>();
        people.add(new Pair<>("Alice", 25));
        people.add(new Pair<>("Bob", 30));
        
        //Iterate
        for(Pair<String, Integer> p : people) {
            System.out.println(p.getFirst() + ": " + p.getSecond());
        }
        
        //Sort by first element
        people.sort(Comparator.comparing(Pair::getFirst));
        
        //Sort by second element
        people.sort(Comparator.comparing(Pair::getSecond));
    }

    //============================================================
    //TRIPLE (3 elements) - USAGE
    //============================================================
    public static void tripleUsage() {
        //Create custom Triple class for 3 elements
        Triple<String, Integer, String> person = new Triple<>("Alice", 25, "Engineer");
        
        //Access elements
        String name = person.getFirst();
        Integer age = person.getSecond();
        String job = person.getThird();
        
        //Modify elements
        person.setFirst("Bob");
        person.setSecond(30);
        person.setThird("Manager");
    }

    //============================================================
    //MAP.ENTRY AS PAIR - USAGE
    //============================================================
    public static void mapEntryAsPairUsage() {
        //Map.Entry can be used as an immutable pair
        Map.Entry<String, Integer> entry = Map.entry("Alice", 25);
        
        //Access elements
        String key = entry.getKey();
        Integer value = entry.getValue();
        
        //Cannot modify - immutable
        //entry.setValue(30); //UnsupportedOperationException
        
        //Use in collections
        List<Map.Entry<String, Integer>> entries = new ArrayList<>();
        entries.add(Map.entry("Alice", 25));
        entries.add(Map.entry("Bob", 30));
        
        //Create mutable entry
        Map.Entry<String, Integer> mutableEntry = new AbstractMap.SimpleEntry<>("Alice", 25);
        mutableEntry.setValue(30); //Can modify
    }
}

//============================================================
//PAIR CLASS DEFINITION
//============================================================
class Pair<T, U> {
    private T first;
    private U second;
    
    public Pair(T first, U second) {
        this.first = first;
        this.second = second;
    }
    
    public T getFirst() {
        return first;
    }
    
    public U getSecond() {
        return second;
    }
    
    public void setFirst(T first) {
        this.first = first;
    }
    
    public void setSecond(U second) {
        this.second = second;
    }
    
    @Override
    public String toString() {
        return "(" + first + ", " + second + ")";
    }
    
    @Override
    public boolean equals(Object obj) {
        if(this == obj) return true;
        if(obj == null || getClass() != obj.getClass()) return false;
        Pair<?, ?> pair = (Pair<?, ?>) obj;
        return Objects.equals(first, pair.first) && Objects.equals(second, pair.second);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(first, second);
    }
}

//============================================================
//TRIPLE CLASS DEFINITION
//============================================================
class Triple<T, U, V> {
    private T first;
    private U second;
    private V third;
    
    public Triple(T first, U second, V third) {
        this.first = first;
        this.second = second;
        this.third = third;
    }
    
    public T getFirst() {
        return first;
    }
    
    public U getSecond() {
        return second;
    }
    
    public V getThird() {
        return third;
    }
    
    public void setFirst(T first) {
        this.first = first;
    }
    
    public void setSecond(U second) {
        this.second = second;
    }
    
    public void setThird(V third) {
        this.third = third;
    }
    
    @Override
    public String toString() {
        return "(" + first + ", " + second + ", " + third + ")";
    }
}

//============================================================
//TUPLE ALTERNATIVES
//============================================================
//1. Custom classes (Pair, Triple above)
//- Most flexible
//- Type-safe
//- Can add methods

//2. Map.Entry<K, V>
//- Built-in, no custom class needed
//- Immutable version: Map.entry(k, v)
//- Mutable version: new AbstractMap.SimpleEntry<>(k, v)
//- Limited to 2 elements only

//3. Arrays or Lists
//Object[] tuple = {"Alice", 25, "Engineer"};
//- Not type-safe
//- Can hold any number of elements
//- Requires casting when retrieving

//4. Third-party libraries
//- Apache Commons Lang3: Pair, Triple
//- JavaTuples library: Pair, Triplet, Quartet, etc.