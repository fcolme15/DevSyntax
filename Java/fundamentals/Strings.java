public class Strings {
    public static void main(String[] args) {
        stringCreation();
        stringComparison();
        stringManipulation();
        stringSearching();
        stringBuilderUsage();
        stringFormatting();
    }

    //============================================================
    //STRING CREATION
    //============================================================
    public static void stringCreation() {
        //String literals - stored in string pool
        String s1 = "Hello";
        String s2 = "Hello";
        
        //Using new keyword - new object in heap
        String s3 = new String("Hello");
        
        //String pool vs heap
        boolean sameReference = (s1 == s2); //true - same object in pool
        boolean differentReference = (s1 == s3); //false - different objects
        boolean sameContent = s1.equals(s3); //true - same content
        
        //Empty string
        String empty = "";
        String emptyNew = new String();
        
        //From char array
        char[] chars = {'H', 'e', 'l', 'l', 'o'};
        String fromChars = new String(chars);
        
        //From byte array
        byte[] bytes = {72, 101, 108, 108, 111};
        String fromBytes = new String(bytes);
    }

    //============================================================
    //STRING COMPARISON
    //============================================================
    public static void stringComparison() {
        String s1 = "hello";
        String s2 = "Hello";
        String s3 = "hello";
        
        //Content comparison - case sensitive
        boolean equal = s1.equals(s3); //true
        boolean notEqual = s1.equals(s2); //false
        
        //Content comparison - case insensitive
        boolean equalIgnoreCase = s1.equalsIgnoreCase(s2); //true
        
        //Lexicographic comparison
        int compare1 = s1.compareTo(s3); //0 (equal)
        int compare2 = s1.compareTo(s2); //positive (s1 > s2 lexicographically)
        int compare3 = s2.compareTo(s1); //negative (s2 < s1)
        
        //Case insensitive lexicographic comparison
        int compareIgnoreCase = s1.compareToIgnoreCase(s2); //0
        
        //Check if string is empty
        boolean isEmpty = s1.isEmpty(); //false
        boolean isBlank = "   ".isBlank(); //true (Java 11+) - checks if only whitespace
        
        //Reference comparison - Checks if same object not for content equality
        boolean sameObject = (s1 == s3);
    }

    //============================================================
    //STRING MANIPULATION
    //============================================================
    public static void stringManipulation() {
        String str = "  Hello World  ";
        
        //Length
        int length = str.length(); //15
        
        //Character access
        char firstChar = str.charAt(2); //'H'
        
        //Substring
        String sub1 = str.substring(2, 7); //"Hello"
        String sub2 = str.substring(8); //"World  "
        
        //Trimming whitespace
        String trimmed = str.trim(); //"Hello World"
        String stripped = str.strip(); //"Hello World" (Java 11+, handles Unicode whitespace)
        
        //Case conversion
        String upper = str.toUpperCase(); //"  HELLO WORLD  "
        String lower = str.toLowerCase(); //"  hello world  "
        
        //Replace
        String replacedAll = str.replace("World", "Java"); //"  Hello Java  "
        String replaceFirst = str.replaceFirst("l", "L"); //"  HeLlo World  "
        
        //Split
        String csv = "apple,banana,cherry";
        String[] fruits = csv.split(","); //["apple", "banana", "cherry"]
        
        String sentence = "one two three";
        String[] words = sentence.split(" "); //["one", "two", "three"]
        
        //Join (Java 8+)
        String joined = String.join("-", "a", "b", "c"); //"a-b-c"
        String joinedArray = String.join(", ", fruits); //"apple, banana, cherry"
        
        //Repeat (Java 11+)
        String repeated = "ab".repeat(3); //"ababab"
        
        //Convert to char array
        char[] charArray = str.toCharArray();
    }

    //============================================================
    //STRING SEARCHING
    //============================================================
    public static void stringSearching() {
        String str = "Hello World Hello";
        
        //Check if contains substring
        boolean contains = str.contains("World"); //true
        
        //Index of substring
        int index1 = str.indexOf("Hello"); //0 (first occurrence)
        int index2 = str.indexOf("Hello", 1); //12 (search from index 1)
        int index3 = str.indexOf("Java"); //-1 (not found)
        
        //Last index of substring
        int lastIndex = str.lastIndexOf("Hello"); //12
        
        //Starts with / ends with
        boolean startsWith = str.startsWith("Hello"); //true
        boolean endsWith = str.endsWith("Hello"); //true
        boolean startsAt = str.startsWith("World", 6); //true (starts at index 6)
        
        //Match with regex
        boolean matches = "abc123".matches("[a-z]+[0-9]+"); //true
    }

    //============================================================
    //STRINGBUILDER - Mutable string operations
    //============================================================
    public static void stringBuilderUsage() {
        //StringBuilder is mutable and efficient for string concatenation
        StringBuilder sb = new StringBuilder();
        
        //Append
        sb.append("Hello");
        sb.append(" ");
        sb.append("World");
        
        //Insert
        sb.insert(6, "Beautiful "); //"Hello Beautiful World"
        
        //Delete
        sb.delete(6, 16); //"Hello World"
        
        //Replace
        sb.replace(6, 11, "Java"); //"Hello Java"
        
        //Reverse
        sb.reverse(); //"avaJ olleH"
        sb.reverse(); //"Hello Java" (reverse back)
        
        //Convert to String
        String result = sb.toString();
        
        //Capacity management
        int capacity = sb.capacity(); //Current capacity
        sb.ensureCapacity(50); //Ensure minimum capacity
        
        //StringBuffer - thread-safe version of StringBuilder (slower)
        StringBuffer sbf = new StringBuffer();
        sbf.append("Thread-safe");
        
        //Performance comparison - String concatenation vs StringBuilder
        //BAD - creates many intermediate String objects
        String slow = "";
        for (int i = 0; i < 1000; i++) {
            slow += i; //Creates new String object each iteration
        }
        
        //GOOD - uses mutable StringBuilder
        StringBuilder fast = new StringBuilder();
        for (int i = 0; i < 1000; i++) {
            fast.append(i);
        }
        String fastResult = fast.toString();
    }

    //============================================================
    //STRING FORMATTING
    //============================================================
    public static void stringFormatting() {
        String name = "Alice";
        int age = 25;
        double salary = 50000.50;
        
        //String.format() - similar to printf
        String formatted1 = String.format("Name: %s, Age: %d", name, age);
        String formatted2 = String.format("Salary: $%.2f", salary); //"Salary: $50000.50"
        
        //Common format specifiers:
        //%s - String
        //%d - integer (decimal)
        //%f - floating point
        //%b - boolean
        //%c - character
        //%x - hexadecimal
        //%o - octal
        
        //Width and precision
        String padded = String.format("%10s", "Hi"); //"        Hi" (right-aligned, width 10)
        String leftPadded = String.format("%-10s", "Hi"); //"Hi        " (left-aligned)
        String decimal = String.format("%.3f", 3.14159); //"3.142" (3 decimal places)
        
        //System.out.printf() - prints formatted string
        System.out.printf("Name: %s, Age: %d%n", name, age);
        
        //Text blocks (Java 15+) - multi-line strings
        String textBlock = """
                This is a
                multi-line
                string
                """;
        
        //String concatenation
        String concat1 = "Hello" + " " + "World"; //Using + operator
        String concat2 = "Value: " + 42; //Auto-converts int to String
        String concat3 = String.join(" ", "Hello", "World"); //Using join
        
        //Value conversion to String
        String fromInt = String.valueOf(42);
        String fromDouble = String.valueOf(3.14);
        String fromBoolean = String.valueOf(true);
        String fromObject = String.valueOf(new Object());
    }
}