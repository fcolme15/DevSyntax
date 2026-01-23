import java.util.*;
import java.util.stream.*;

public class StreamsReference {
    public static void main(String[] args) {
        streamCreation();
        intermediateOperationsUsage();
        terminalOperationsUsage();
        collectorsUsage();
    }

    //============================================================
    //STREAM CREATION 
    //============================================================
    public static void streamCreation() {
        //From collection
        List<String> list = Arrays.asList("a", "b", "c");
        Stream<String> stream1 = list.stream();
        
        //From array
        String[] array = {"a", "b", "c"};
        Stream<String> stream2 = Arrays.stream(array);
        
        //From values
        Stream<String> stream3 = Stream.of("a", "b", "c");
        
        //Empty stream
        Stream<String> empty = Stream.empty();
        
        //Infinite streams
        Stream<Integer> infinite = Stream.iterate(0, n -> n + 1); //0, 1, 2, 3...
        Stream<Double> random = Stream.generate(Math::random);
        
        //Range (IntStream)
        IntStream range1 = IntStream.range(0, 5); //0, 1, 2, 3, 4
        IntStream range2 = IntStream.rangeClosed(0, 5); //0, 1, 2, 3, 4, 5
        
        //Parallel stream
        Stream<String> parallel = list.parallelStream();
    }

    //============================================================
    //INTERMEDIATE OPERATIONS - USAGE (Return Stream, lazy)
    //============================================================
    public static void intermediateOperationsUsage() {
        List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
        
        //filter - keep elements matching predicate
        Stream<Integer> evens = numbers.stream().filter(n -> n % 2 == 0);
        
        //map - transform each element
        Stream<Integer> squared = numbers.stream().map(n -> n * n);
        
        //flatMap - flatten nested structures
        List<List<Integer>> nested = Arrays.asList(
            Arrays.asList(1, 2),
            Arrays.asList(3, 4)
        );
        Stream<Integer> flattened = nested.stream().flatMap(List::stream); //1, 2, 3, 4
        
        //distinct - remove duplicates
        List<Integer> duplicates = Arrays.asList(1, 2, 2, 3, 3, 3);
        Stream<Integer> unique = duplicates.stream().distinct(); //1, 2, 3
        
        //sorted - sort elements
        Stream<Integer> sorted = numbers.stream().sorted();
        Stream<Integer> reversed = numbers.stream().sorted(Comparator.reverseOrder());
        
        //limit - take first N elements
        Stream<Integer> firstFive = numbers.stream().limit(5);
        
        //skip - skip first N elements
        Stream<Integer> afterFive = numbers.stream().skip(5);
        
        //peek - perform action without modifying stream (debugging)
        numbers.stream()
            .peek(n -> System.out.println("Processing: " + n))
            .filter(n -> n % 2 == 0)
            .forEach(System.out::println);
        
        //Chaining operations
        List<Integer> result = numbers.stream()
            .filter(n -> n % 2 == 0)
            .map(n -> n * 2)
            .sorted()
            .collect(Collectors.toList());
    }

    //============================================================
    //TERMINAL OPERATIONS - USAGE (Produce result, trigger execution)
    //============================================================
    public static void terminalOperationsUsage() {
        List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);
        
        //forEach - perform action on each element
        numbers.stream().forEach(System.out::println);
        
        //collect - accumulate into collection
        List<Integer> list = numbers.stream().collect(Collectors.toList());
        Set<Integer> set = numbers.stream().collect(Collectors.toSet());
        
        //toArray - convert to array
        Integer[] array = numbers.stream().toArray(Integer[]::new);
        
        //reduce - combine elements into single result
        int sum = numbers.stream().reduce(0, (a, b) -> a + b);
        int product = numbers.stream().reduce(1, (a, b) -> a * b);
        Optional<Integer> max = numbers.stream().reduce(Integer::max);
        
        //count - count elements
        long count = numbers.stream().count();
        
        //anyMatch - check if any element matches
        boolean hasEven = numbers.stream().anyMatch(n -> n % 2 == 0); //true
        
        //allMatch - check if all elements match
        boolean allPositive = numbers.stream().allMatch(n -> n > 0); //true
        
        //noneMatch - check if no elements match
        boolean noNegative = numbers.stream().noneMatch(n -> n < 0); //true
        
        //findFirst - get first element
        Optional<Integer> first = numbers.stream().findFirst();
        
        //findAny - get any element (useful in parallel streams)
        Optional<Integer> any = numbers.stream().findAny();
        
        //min/max
        Optional<Integer> min = numbers.stream().min(Integer::compareTo);
        Optional<Integer> maximum = numbers.stream().max(Integer::compareTo);
    }

    //============================================================
    //COLLECTORS - USAGE
    //============================================================
    public static void collectorsUsage() {
        List<String> words = Arrays.asList("apple", "banana", "cherry", "apple");
        
        //toList
        List<String> list = words.stream().collect(Collectors.toList());
        
        //toSet
        Set<String> set = words.stream().collect(Collectors.toSet());
        
        //toMap
        Map<String, Integer> lengthMap = words.stream()
            .distinct()
            .collect(Collectors.toMap(w -> w, String::length));
        
        //joining - concatenate strings
        String joined = words.stream().collect(Collectors.joining()); //"applebananacherryapple"
        String withDelimiter = words.stream().collect(Collectors.joining(", ")); //"apple, banana, cherry, apple"
        String withPrefixSuffix = words.stream().collect(Collectors.joining(", ", "[", "]")); //"[apple, banana, cherry, apple]"
        
        //groupingBy - group elements
        Map<Integer, List<String>> byLength = words.stream()
            .collect(Collectors.groupingBy(String::length));
        
        //partitioningBy - split into two groups (true/false)
        Map<Boolean, List<String>> partitioned = words.stream()
            .collect(Collectors.partitioningBy(w -> w.length() > 5));
        
        //counting
        long count = words.stream().collect(Collectors.counting());
        
        //summingInt/Double/Long
        int totalLength = words.stream().collect(Collectors.summingInt(String::length));
        
        //averagingInt/Double/Long
        double avgLength = words.stream().collect(Collectors.averagingInt(String::length));
        
        //summarizingInt/Double/Long - get statistics
        IntSummaryStatistics stats = words.stream()
            .collect(Collectors.summarizingInt(String::length));
        System.out.println(stats.getAverage());
        System.out.println(stats.getMax());
        System.out.println(stats.getMin());
        System.out.println(stats.getSum());
    }
}
