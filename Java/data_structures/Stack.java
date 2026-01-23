import java.util.*;

//============================================================
//STACK VS ARRAYDEQUE AS STACK
//============================================================
//Stack (java.util.Stack):
//- Legacy class from Java 1.0
//- Extends Vector (synchronized, thread-safe but slower)
//- Has search() method
//- Use only for legacy code

//ArrayDeque as Stack:
//- Modern, recommended approach
//- Not synchronized (faster)
//- No search() method (use contains() instead)
//- More consistent API with other collections
//- Better performance for single-threaded use

public class StackReference {
    public static void main(String[] args) {
        stackUsage();
        arrayDequeAsStackUsage();
    }

    //============================================================
    //STACK - USAGE (Legacy class)
    //============================================================
    public static void stackUsage() {
        //Creation - extends Vector (synchronized, slower)
        Stack<Integer> stack = new Stack<>();
        
        //Push - add to top
        stack.push(1);
        stack.push(2);
        stack.push(3);
        
        //Peek - view top without removing
        Integer top = stack.peek(); //3
        
        //Pop - remove and return top
        Integer removed = stack.pop(); //3
        System.out.println(stack.peek()); //2
        
        //Check if empty
        boolean empty = stack.isEmpty(); //false
        
        //Size
        int size = stack.size(); //2
        
        //Search - returns 1-based position from top (1 = top)
        stack.push(5);
        stack.push(7);
        int position = stack.search(5); //2 (second from top)
        int notFound = stack.search(10); //-1 (not in stack)
        
        //Clear
        stack.clear();
    }

    //============================================================
    //ARRAYDEQUE AS STACK - USAGE
    //ArrayDeque is preferred over Stack (not synchronized, faster)
    //============================================================
    public static void arrayDequeAsStackUsage() {
        Deque<String> stack = new ArrayDeque<>();
        
        //Push - add to top
        stack.push("first");
        stack.push("second");
        stack.push("third");
        
        //Peek - view top without removing
        String top = stack.peek(); //"third"
        
        //Pop - remove and return top
        String removed = stack.pop(); //"third"
        
        //Check if empty
        boolean empty = stack.isEmpty(); //false
        
        //Size
        int size = stack.size(); //2
        
        //Iterate from top to bottom
        for(String item : stack) {
            System.out.println(item); //second, first
        }
        
        //Alternative methods (same as push/pop/peek)
        stack.addFirst("top"); //Same as push
        stack.removeFirst(); //Same as pop
        stack.peekFirst(); //Same as peek
    }
}

