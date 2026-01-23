public class MultithreadingReference {
    public static void main(String[] args) {
        threadCreationUsage();
        threadMethodsUsage();
        synchronizationUsage();
        volatileUsage();
    }

    //============================================================
    //THREAD CREATION - USAGE
    //============================================================
    public static void threadCreationUsage() {
        //Method 1: Extend Thread class
        MyThread thread1 = new MyThread();
        thread1.start(); //Starts new thread, calls run()
        
        //Method 2: Implement Runnable interface (preferred)
        MyRunnable runnable = new MyRunnable();
        Thread thread2 = new Thread(runnable);
        thread2.start();
        
        //Method 3: Anonymous Runnable
        Thread thread3 = new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("Thread 3 running");
            }
        });
        thread3.start();
        
        //Method 4: Lambda expression (Java 8+)
        Thread thread4 = new Thread(() -> {
            System.out.println("Thread 4 running");
        });
        thread4.start();
        
        //Thread with name
        Thread namedThread = new Thread(() -> {
            System.out.println("Named thread");
        }, "MyThread");
        namedThread.start();
    }

    //============================================================
    //THREAD METHODS - USAGE
    //============================================================
    public static void threadMethodsUsage() {
        Thread thread = new Thread(() -> {
            for(int i = 0; i < 5; i++) {
                System.out.println("Running: " + i);
                try {
                    Thread.sleep(1000); //Sleep 1 second
                } catch(InterruptedException e) {
                    System.out.println("Thread interrupted");
                }
            }
        });
        
        //Start thread
        thread.start();
        
        //Wait for thread to finish
        try {
            thread.join(); //Current thread waits for 'thread' to complete
        } catch(InterruptedException e) {
            e.printStackTrace();
        }
        
        //Get current thread
        Thread current = Thread.currentThread();
        System.out.println("Current thread: " + current.getName());
        
        //Check if thread is alive
        boolean alive = thread.isAlive();
        
        //Thread priority (1-10, default 5)
        thread.setPriority(Thread.MAX_PRIORITY); //10
        thread.setPriority(Thread.MIN_PRIORITY); //1
        thread.setPriority(Thread.NORM_PRIORITY); //5
        int priority = thread.getPriority();
        
        //Interrupt thread
        thread.interrupt(); //Sets interrupt flag
        boolean interrupted = thread.isInterrupted();
    }

    //============================================================
    //SYNCHRONIZATION - USAGE
    //============================================================
    public static void synchronizationUsage() {
        Counter counter = new Counter();
        
        //Create multiple threads accessing same resource
        Thread t1 = new Thread(() -> {
            for(int i = 0; i < 1000; i++) {
                counter.increment();
            }
        });
        
        Thread t2 = new Thread(() -> {
            for(int i = 0; i < 1000; i++) {
                counter.increment();
            }
        });
        
        t1.start();
        t2.start();
        
        try {
            t1.join();
            t2.join();
        } catch(InterruptedException e) {
            e.printStackTrace();
        }
        
        System.out.println("Count: " + counter.getCount()); //Should be 2000
    }

    //============================================================
    //VOLATILE - USAGE
    //============================================================
    public static void volatileUsage() {
        VolatileExample example = new VolatileExample();
        
        //Thread 1: Writer
        Thread writer = new Thread(() -> {
            try {
                Thread.sleep(1000);
                example.setFlag(true);
                System.out.println("Flag set to true");
            } catch(InterruptedException e) {
                e.printStackTrace();
            }
        });
        
        //Thread 2: Reader
        Thread reader = new Thread(() -> {
            while(!example.isFlag()) {
                //Wait for flag to be true
            }
            System.out.println("Flag is true, exiting");
        });
        
        writer.start();
        reader.start();
    }
}

//============================================================
//THREAD CLASS - Extending Thread
//============================================================
class MyThread extends Thread {
    @Override
    public void run() {
        System.out.println("MyThread running");
        for(int i = 0; i < 5; i++) {
            System.out.println("Count: " + i);
        }
    }
}

//============================================================
//RUNNABLE INTERFACE - Implementing Runnable (Preferred)
//============================================================
class MyRunnable implements Runnable {
    @Override
    public void run() {
        System.out.println("MyRunnable running");
        for(int i = 0; i < 5; i++) {
            System.out.println("Count: " + i);
        }
    }
}

//============================================================
//SYNCHRONIZED METHOD - Thread-safe counter
//============================================================
class Counter {
    private int count = 0;
    
    //Synchronized method - only one thread can execute at a time
    public synchronized void increment() {
        count++;
    }
    
    public synchronized int getCount() {
        return count;
    }
}

//============================================================
//SYNCHRONIZED BLOCK - Fine-grained locking
//============================================================
class SynchronizedBlockExample {
    private int count = 0;
    private Object lock = new Object();
    
    public void increment() {
        //Synchronized block - lock on specific object
        synchronized(lock) {
            count++;
        }
    }
    
    public void decrement() {
        synchronized(this) { //Lock on current object
            count--;
        }
    }
}

//============================================================
//VOLATILE - Ensures visibility across threads
//============================================================
class VolatileExample {
    private volatile boolean flag = false; //volatile ensures visibility
    
    public void setFlag(boolean value) {
        flag = value;
    }
    
    public boolean isFlag() {
        return flag;
    }
}

//============================================================
//WAIT AND NOTIFY - Thread communication
//============================================================
class WaitNotifyExample {
    private final Object lock = new Object();
    
    public void waitMethod() {
        synchronized(lock) {
            try {
                lock.wait(); //Release lock and wait
            } catch(InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
    
    public void notifyMethod() {
        synchronized(lock) {
            lock.notify(); //Wake up one waiting thread
            //lock.notifyAll(); //Wake up all waiting threads
        }
    }
}

//============================================================
//THREAD STATES
//============================================================
//NEW - Thread created but not started
//RUNNABLE - Thread running or ready to run
//BLOCKED - Thread waiting to acquire lock
//WAITING - Thread waiting indefinitely (wait(), join())
//TIMED_WAITING - Thread waiting for specific time (sleep(), wait(timeout))
//TERMINATED - Thread completed execution

//Race condition:
//- Multiple threads modify shared data simultaneously
//- Solution: synchronization

//Deadlock:
//- Two threads waiting for each other's locks
//- Solution: careful lock ordering, timeout

//Starvation:
//- Thread never gets CPU time
//- Solution: proper priority management

//Visibility:
//- Changes by one thread not visible to others
//- Solution: volatile or synchronization