import java.io.*;

public class ExceptionHandlingReference {
    public static void main(String[] args) {
        tryCatchUsage();
        multipleCatchUsage();
        tryWithResourcesUsage();
        throwUsage();
        throwsUsage();
        customExceptionUsage();
    }

    //============================================================
    //TRY-CATCH - USAGE
    //============================================================
    public static void tryCatchUsage() {
        //Basic try-catch
        try {
            int result = 10 / 0; //ArithmeticException
        } catch(ArithmeticException e) {
            System.out.println("Cannot divide by zero");
        }
        
        //Access exception details
        try {
            String str = null;
            str.length(); //NullPointerException
        } catch(NullPointerException e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
        
        //Finally always executes (cleanup code)
        try {
            int result = 10 / 2;
            System.out.println(result);
        } catch(Exception e) {
            System.out.println("Exception occurred");
        } finally {
            System.out.println("Always executes"); //Cleanup, close resources
        }
        
        //Finally executes even with return
        try {
            return;
        } finally {
            System.out.println("Executes before return");
        }
    }

    //============================================================
    //MULTIPLE CATCH - USAGE
    //============================================================
    public static void multipleCatchUsage() {
        //Multiple catch blocks - order matters (specific to general)
        try {
            int[] arr = {1, 2, 3};
            System.out.println(arr[5]); //ArrayIndexOutOfBoundsException
        } catch(ArrayIndexOutOfBoundsException e) {
            System.out.println("Index out of bounds");
        } catch(Exception e) {
            System.out.println("General exception");
        }
        
        //Multi-catch (Java 7+) - same handling for multiple exceptions
        try {
            String str = null;
            str.length();
        } catch(NullPointerException | ArithmeticException e) {
            System.out.println("Null or arithmetic error");
        }
        
        //Nested try-catch
        try {
            try {
                int result = 10 / 0;
            } catch(ArithmeticException e) {
                System.out.println("Inner catch");
                throw e; //Re-throw to outer catch
            }
        } catch(ArithmeticException e) {
            System.out.println("Outer catch");
        }
    }

    //============================================================
    //TRY-WITH-RESOURCES - USAGE (Auto-close resources)
    //============================================================
    public static void tryWithResourcesUsage() {
        //Single resource
        try(BufferedReader br = new BufferedReader(new FileReader("file.txt"))) {
            String line = br.readLine();
        } catch(IOException e) {
            System.out.println("File error");
        }
        
        //Multiple resources
        try(FileReader fr = new FileReader("input.txt");
            BufferedReader br = new BufferedReader(fr);
            FileWriter fw = new FileWriter("output.txt")) {
            String line = br.readLine();
            fw.write(line);
        } catch(IOException e) {
            System.out.println("IO error");
        }
    }

    //============================================================
    //THROW - USAGE (Throw exception explicitly)
    //============================================================
    public static void throwUsage() {
        //Throw built-in exception
        int age = -5;
        if(age < 0) {
            throw new IllegalArgumentException("Age cannot be negative");
        }
        
        //Re-throw exception to be caught again later
        try {
            int result = 10 / 0;
        } catch(ArithmeticException e) {
            System.out.println("Logging error");
            throw e; //Re-throw to caller
        }
    }
    
    //Single custom throw, definition is class below that extends Exception
    public static void checkBalance(double amount) throws InsufficientFundsException {
        double balance = 100;
        if(amount > balance) {
            throw new InsufficientFundsException(amount - balance);
        }
    }
    
    //Multiple throws
    public static void processData() throws IOException, ClassNotFoundException {
        //Method may throw either exception
    }
}

//============================================================
//CUSTOM EXCEPTION DEFINITION - Checked
//============================================================
class InsufficientFundsException extends Exception {
    private double deficit;
    
    public InsufficientFundsException(double deficit) {
        super("Insufficient funds");
        this.deficit = deficit;
    }
    
    public double getDeficit() {
        return deficit;
    }
}

//============================================================
//CUSTOM EXCEPTION DEFINITION - Unchecked
//============================================================
class InvalidInputException extends RuntimeException {
    public InvalidInputException(String message) {
        super(message);
    }
}

//============================================================
//EXCEPTION HIERARCHY
//============================================================
//Throwable
//├── Error (unchecked - system errors, don't catch)
//│   └── OutOfMemoryError, StackOverflowError, etc.
//└── Exception
//    ├── RuntimeException (unchecked - programming errors)
//    │   ├── NullPointerException
//    │   ├── ArrayIndexOutOfBoundsException
//    │   ├── ArithmeticException
//    │   ├── IllegalArgumentException
//    │   ├── ClassCastException
//    │   └── NumberFormatException
//    └── Checked Exceptions (must handle or declare)
//        ├── IOException
//        ├── SQLException
//        ├── ClassNotFoundException
//        └── FileNotFoundException