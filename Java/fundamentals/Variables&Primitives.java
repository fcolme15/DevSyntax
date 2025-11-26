public class VariablesAndPrimitives {
    public static void main(String[] args) {
        primitiveTypes();
        variableDeclarations();
        wrapperClasses();
    }

    //============================================================
    //PRIMITIVE TYPES
    //============================================================
    public static void primitiveTypes() {
        
        //Integers
        byte byteVar = 127; //8-bit, -128 to 127
        short shortVar = 32767; //16-bit, -32,768 to 32,767
        int intVar = 2147483647; //32-bit, -2^31 to 2^31-1
        long longVar = 9223372036854775807L; //64-bit, -2^63 to 2^63-1, note the L suffix
        
        //Floating point
        float floatVar = 3.14f; //32-bit, note the f suffix
        double doubleVar = 3.14159265359; //64-bit, default for decimals
        
        //Character and boolean
        char charVar = 'A'; //16-bit Unicode character, single quotes
        boolean boolVar = true; //true or false
    }

    //============================================================
    //VARIABLE DECLARATIONS
    //============================================================
    public static void variableDeclarations() { 

        //Declaration & initialization together
        int x; 
        x = 10;
        int y = 20; 
        
        
        int a, b, c; 
        int d = 1, e = 2, f = 3; 
        
        //Type inference with var (Java 10+)
        var inferredInt = 100;
        var inferredString = "Hello";
        var inferredDouble = 3.14;
    }

    //============================================================
    //WRAPPER CLASSES
    //============================================================
    public static void wrapperClasses() {
        
        //Wrapper classes for primitives: Byte, Short, Integer, Long, Float, Double, Character, Boolean
        //Used when you need objects instead of primitives (collections, generics, null values)
        
        //Autoboxing - automatic primitive to wrapper conversion
        Integer wrappedInt = 42; //Automatic boxing from int to Integer
        Double wrappedDouble = 3.14; //Automatic boxing from double to Double
        
        //Unboxing - automatic wrapper to primitive conversion
        int primitiveInt = wrappedInt; //Automatic unboxing from Integer to int
        double primitiveDouble = wrappedDouble; //Automatic unboxing from Double to double
        
        //Explicit wrapper creation
        Integer obj1 = Integer.valueOf(100);
        Integer obj2 = new Integer(100); //Deprecated in Java 9+
        
        //Useful wrapper class methods
        int max = Integer.MAX_VALUE; //2147483647
        int min = Integer.MIN_VALUE; //-2147483648
        String binary = Integer.toBinaryString(10); //"1010"
        String hex = Integer.toHexString(255); //"ff"
        
        //Parsing strings
        int parsed = Integer.parseInt("123");
        double parsedDouble = Double.parseDouble("3.14");
        
        //Null values with wrappers
        Integer nullableInt = null; 
        //int primitiveNull = null; //Compilation error
    }

}