public class Loops {
    public static void main(String[] args) {
        forLoop();
        whileLoop();
        enhancedForLoop();
        nestedLoops();
        loopControl();
        labeledLoops();
    }

    //============================================================
    //FOR LOOP
    //============================================================
    public static void forLoop() {
        System.out.println("=== For Loop ===");
        
        for (int i = 0; i < 5; i++) {
            System.out.println("i = " + i);
        }
        
        //Multiple variables in initialization
        for (int i = 0, j = 10; i < j; i++, j--) {
            System.out.println("i = " + i + ", j = " + j);
        }
        
        //Infinite loop (break needed to exit)
        for (;;) {
            System.out.println("Infinite loop - breaking immediately");
            break;
        }
    }

    //============================================================
    //WHILE LOOP
    //============================================================
    public static void whileLoop() {
        System.out.println("=== While Loop ===");
        
        //Basic while loop - condition checked before execution
        int i = 0;
        while (i < 5) {
            System.out.println("i = " + i);
            i++;
        }
        
        //Infinite loop (break needed to exit)
        while (true) {
            System.out.println("Infinite while loop - breaking immediately");
            break;
        }
        
        System.out.println();
        
        //Executes at least once then condition checked
        int i = 0;
        do {
            System.out.println("i = " + i);
            i++;
        } while (i >= 0);
    }

    //============================================================
    //ENHANCED FOR LOOP (FOR-EACH)
    //============================================================
    public static void enhancedForLoop() {
        System.out.println("=== Enhanced For Loop (For-Each) ===");
        
        //For-each loop with arrays
        int[] numbers = {1, 2, 3, 4, 5};
        for (int num : numbers) {
            System.out.println("Number: " + num);
        }
        
        //For-each with String array
        String[] names = {"Alice", "Bob", "Charlie"};
        for (String name : names) {
            System.out.println("Name: " + name);
        }
        
        //For-each with 2D array
        int[][] matrix = {{1, 2}, {3, 4}, {5, 6}};
        for (int[] row : matrix) {
            for (int value : row) {
                System.out.print(value + " ");
            }
            System.out.println();
        }
        
        //Note: Cannot modify array elements directly or access index
        int[] values = {10, 20, 30};
        for (int val : values) {
            val = val * 2; //This does NOT modify the array
        }
        System.out.println("Original array unchanged: " + values[0]); //Still 10
        
        System.out.println();
    }

    //============================================================
    //BREAK & CONTINUE
    //============================================================
    public static void loopControl() {
        System.out.println("=== Loop Control ===");
        
        //break - exits the loop immediately
        System.out.println("Break example:");
        for (int i = 0; i < 10; i++) {
            if (i == 5) {
                break; //Exit loop when i is 5
            }
            System.out.println("i = " + i);
        }
        
        //continue - skips current iteration, goes to next
        System.out.println("\nContinue example (skip odd numbers):");
        for (int i = 0; i < 10; i++) {
            if (i % 2 != 0) {
                continue; //Skip odd numbers
            }
            System.out.println("Even: " + i);
        }
        
        System.out.println();
    }

    //============================================================
    //LABELED LOOPS
    //============================================================
    public static void labeledLoops() {
        System.out.println("=== Labeled Loops ===");
        
        //Label allows breaking/continuing outer loops from inner loops
        //Syntax: labelName: for (...) { }
        
        //Breaking outer loop from inner loop
        System.out.println("Break outer loop:");
        outerLoop:
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (i == 1 && j == 1) {
                    continue outer; //Skips to next iteration of outer loop
                }
                if (i == 2 && j == 2) {
                    break outerLoop; //Breaks out of outer loop completely
                }
                System.out.println("i=" + i + ", j=" + j);
            }
        }
        
        System.out.println();
    }
}