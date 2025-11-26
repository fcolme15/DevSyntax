import java.util.Arrays;

public class ArraysReference {
    public static void main(String[] args) {
        arrayCreation();
        arrayAccess();
        multiDimensionalArrays();
        arraysCopyAndCompare();
        arraysUtilityMethods();
    }

    //============================================================
    //ARRAY CREATION
    //============================================================
    public static void arrayCreation() {
        //Declaration and initialization
        //Array length is fixed after creation
        int[] numbers1 = {1, 2, 3, 4, 5}; //Array literal
        int[] numbers2 = new int[]{1, 2, 3, 4, 5}; //Explicit array creation
        int[][] matrix1 = { //Multidimensional Array
            {1, 2, 3},
            {4, 5, 6},
            {7, 8, 9}
        };
        
        //Declare then initialize
        int[] numbers3;
        numbers3 = new int[5]; //Creates array of size 5, default values are 0
        
        //Different syntax styles (both valid)
        int[] arr1;
        int arr2[]; //C-style
        
        //Default values when using new keyword:
        //Numeric types: 0
        //boolean: false
        //Object references: null
        int[] zeros = new int[5]; //[0, 0, 0, 0, 0]
        boolean[] falses = new boolean[3]; //[false, false, false]
        String[] nulls = new String[3]; //[null, null, null]
        
        //Can check array length at any moment, its a property
        int length = numbers1.length;
    }

    //============================================================
    //ARRAY ACCESS AND MODIFICATION
    //============================================================
    public static void arrayAccess() {
        int[] arr = {10, 20, 30, 40, 50};
        
        //Access by index 
        //Out of bounds access throws ArrayIndexOutOfBoundsException - Runtime Error
        int first = arr[0];
        int last = arr[arr.length - 1];
        
        //Modify elements
        arr[0] = 100; 
        arr[2] = arr[1] + arr[3]; 
        
        //Arrays are reference types
        int[] original = {1, 2, 3};
        int[] reference = original; //Same array, not a copy
        reference[0] = 100;
        //original[0] is now also 100
        
        //Check if arrays are same object
        boolean sameReference = (original == reference); //true
    }

    //============================================================
    //ARRAYS COPY AND COMPARE
    //============================================================
    public static void arraysCopyAndCompare() {
        int[] original = {1, 2, 3, 4, 5};
        
        //Copy array - method 1: Arrays.copyOf()
        int[] copy1 = Arrays.copyOf(original, original.length);
        
        //Copy with different length
        int[] longer = Arrays.copyOf(original, 10); //Pads with zeros
        int[] shorter = Arrays.copyOf(original, 3); //[1, 2, 3]
        
        //Copy array - method 2: System.arraycopy()
        int[] copy2 = new int[original.length]; 
        //Parameters: src, srcPos, dest, destPos, length
        System.arraycopy(original, 0, copy2, 0, original.length);
        
        //Copy array - method 3: clone()
        int[] copy3 = original.clone();
        
        //Copy range
        int[] range = Arrays.copyOfRange(original, 1, 4); //[2, 3, 4]
        
        //Compare arrays
        boolean sameReference = (copy1 == copy2); //Checks for the same reference
        boolean sameContent = Arrays.equals(arr1, arr2); //Checks contents
        
        //Deep equals for value comparison of multi-dimensional arrays
        int[][] matrix1 = {{1, 2}, {3, 4}};
        int[][] matrix2 = {{1, 2}, {3, 4}};
        boolean equal2D = Arrays.deepEquals(matrix1, matrix2);
    }

    //============================================================
    //ARRAYS UTILITY METHODS
    //============================================================
    public static void arraysUtilityMethods() {
        int[] numbers = {5, 2, 8, 1, 9};
        
        //Sort array (modifies original)
        Arrays.sort(numbers); //[1, 2, 5, 8, 9]
        
        //Sort range
        int[] arr = {5, 2, 8, 1, 9, 3};
        Arrays.sort(arr, 1, 4); //Sort indices 1-3: [5, 1, 2, 8, 9, 3]
        
        //Binary search (array must be sorted first)
        int[] sorted = {1, 2, 5, 8, 9};
        int index = Arrays.binarySearch(sorted, 5); 
        int notFound = Arrays.binarySearch(sorted, 7); //Negative value if not found
        
        //Fill array with value
        int[] filled = new int[5];
        Arrays.fill(filled, 10); //[10, 10, 10, 10, 10]
        
        //Fill range, outer value is not included
        Arrays.fill(filled, 1, 3, 20); //[10, 20, 20, 10, 10]
        
        //Convert to string
        String str = Arrays.toString(numbers);
        
        //Deep toString for multi-dimensional arrays
        int[][] matrix = {{1, 2}, {3, 4}};
        String matrixStr = Arrays.deepToString(matrix); //"[[1, 2], [3, 4]]"
        
        //Compare arrays - Pos >, 0 equal, Neg < 
        int compare = Arrays.compare(new int[]{1, 2}, new int[]{1, 3}); //Negative (first is less)
        
        //Mismatch - find first index where arrays differ (Java 9+)
        int[] a1 = {1, 2, 3, 4};
        int[] a2 = {1, 2, 5, 4};
        int mismatch = Arrays.mismatch(a1, a2); //Returns 2, index where they differ
        
        //Convert array to stream (Java 8+)
        int sum = Arrays.stream(numbers).sum(); //25
        int max = Arrays.stream(numbers).max().getAsInt(); //9
    }
}