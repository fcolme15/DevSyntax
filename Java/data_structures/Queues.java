import java.util.*;

//LinkedList as Queue:
//- Implements both Queue and Deque
//- Allows null elements
//- Good for simple queue operations
//- Slower than ArrayDeque

//ArrayDeque:
//- Faster than LinkedList for queue/stack operations
//- No capacity restrictions (grows dynamically)
//- Does not allow null elements
//- Recommended for Queue and Deque operations

//PriorityQueue:
//- Elements ordered by priority (natural order or comparator)
//- poll() always returns highest priority element
//- Not thread-safe
//- Does not allow null elements
//- Use when you need elements processed by priority

//============================================================
//TIME COMPLEXITY
//============================================================
//ArrayDeque:
//- offer/poll/peek: O(1)
//- contains/remove: O(n)

//LinkedList:
//- offer/poll/peek: O(1)
//- contains/remove: O(n)

//PriorityQueue:
//- offer: O(log n)
//- poll/peek: O(log n) / O(1)
//- contains: O(n)
//- remove: O(n)

public class QueueReference {
    public static void main(String[] args) {
        arrayDequeUsage();
        linkedListAsQueueUsage();
        dequeUsage();
        priorityQueueUsage();
    }
    
    //============================================================
    //ARRAYDEQUE - USAGE (Recommended for Queue, faster than LinkedList)
    //============================================================
    public static void arrayDequeUsage() {
        //ArrayDeque is faster than LinkedList for queue operations
        Queue<String> queue = new ArrayDeque<>();
        
        //Standard queue operations
        queue.offer("A");
        queue.offer("B");
        queue.offer("C");
        
        String front = queue.peek(); //"A"
        String removed = queue.poll(); //"A"
        
        //Iterate through queue
        for(String item : queue) {
            System.out.println(item); //B, C
        }
        
        //ArrayDeque does not allow null elements
        //queue.offer(null); //NullPointerException
    }

    //============================================================
    //LINKEDLIST QUEUE BASICS - USAGE
    //============================================================
    public static void linkedListAsQueueUsage() {
        //Queue is an interface, use LinkedList
        //Note: add/remove/element throw exceptions, offer/poll/peek return null
        Queue<String> queue = new LinkedList<>();
        
        //Add & Offer - adds to end 
        queue.add("first");
        queue.offer("second");
        queue.offer("third");

        //Process elements FIFO (First In First Out)
        while(!queue.isEmpty()) {
            System.out.println(queue.poll()); //1, 2, 3
        }

        //Peek - view front without removing
        String front = queue.peek(); //"first"
        
        //Poll & Remove - remove and return front
        String removed = queue.remove(); //"first"
        String removed2 = queue.poll(); //"second"
        System.out.println(queue.peek()); //"second"
        
        //Size and empty check
        int size = queue.size(); //2
        boolean hasFive = queue.contains(5); //true
        boolean empty = queue.isEmpty(); //false
    }

    //============================================================
    //DEQUE - USAGE (Double-ended queue)
    //============================================================
    public static void dequeUsage() {
        //Deque allows insertion/removal from both ends
        Deque<String> deque = new ArrayDeque<>();
        
        //Add to front
        deque.addFirst("B");
        deque.addFirst("A"); //Deque: [A, B]
        
        //Add to rear
        deque.addLast("C");
        deque.addLast("D"); //Deque: [A, B, C, D]
        
        //Offer methods (return false if fails, don't throw exception)
        deque.offerFirst("Z"); //Add to front
        deque.offerLast("Y"); //Add to rear
        
        //Peek methods
        String first = deque.peekFirst(); //"Z"
        String last = deque.peekLast(); //"Y"
        
        //Poll methods
        String removedFirst = deque.pollFirst(); //"Z"
        String removedLast = deque.pollLast(); //"Y"
        
        //Get methods (throw exception if empty)
        String getFirst = deque.getFirst(); //"A"
        String getLast = deque.getLast(); //"D"
        
        //Remove methods (throw exception if empty)
        deque.removeFirst(); //Removes "A"
        deque.removeLast(); //Removes "D"
        
        //Use as Stack (LIFO)
        deque.push("top"); //Same as addFirst
        String popped = deque.pop(); //Same as removeFirst
        
        //Use as Queue (FIFO)
        deque.offer("rear"); //Same as offerLast
        String polled = deque.poll(); //Same as pollFirst
        
        //Iterate forward
        for(String item : deque) {
            System.out.println(item);
        }
        
        //Iterate backward
        Iterator<String> descending = deque.descendingIterator();
        while(descending.hasNext()) {
            System.out.println(descending.next());
        }
    }
    
    //============================================================
    //PRIORITYQUEUE - USAGE (Elements ordered by priority)
    //============================================================
    public static void priorityQueueUsage() {
        //Natural ordering (min heap - smallest element first)
        PriorityQueue<Integer> pq = new PriorityQueue<>();
        pq.offer(5);
        pq.offer(1);
        pq.offer(3);
        
        //Poll returns smallest element
        System.out.println(pq.poll()); //1
        System.out.println(pq.poll()); //3
        System.out.println(pq.poll()); //5
        
        //Max heap - reverse order (largest first)
        PriorityQueue<Integer> maxHeap = new PriorityQueue<>(Comparator.reverseOrder());
        maxHeap.offer(5);
        maxHeap.offer(1);
        maxHeap.offer(3);
        System.out.println(maxHeap.poll()); //5
        
        //Custom comparator - by string length
        PriorityQueue<String> wordQueue = new PriorityQueue<>(Comparator.comparingInt(String::length));
        wordQueue.offer("apple");
        wordQueue.offer("pie");
        wordQueue.offer("banana");
        System.out.println(wordQueue.poll()); //"pie" (shortest)
        
        //Custom object with Comparable
        PriorityQueue<Task> tasks = new PriorityQueue<>();
        tasks.offer(new Task("Low", 3));
        tasks.offer(new Task("High", 1));
        tasks.offer(new Task("Medium", 2));
        System.out.println(tasks.poll().name); //"High" (priority 1)
        
        //Peek without removing
        Integer min = pq.peek(); //Gets minimum without removing
        
        //Size
        int size = pq.size();
        
        //Important: Iteration order is NOT guaranteed to be sorted
        //Only poll() is guaranteed to return in priority order
    }
}

//============================================================
//TASK CLASS DEFINITION - For PriorityQueue example
//============================================================
class Task implements Comparable<Task> {
    String name;
    int priority; //Lower number = higher priority
    
    public Task(String name, int priority) {
        this.name = name;
        this.priority = priority;
    }
    
    @Override
    public int compareTo(Task other) {
        return Integer.compare(this.priority, other.priority);
    }
}
