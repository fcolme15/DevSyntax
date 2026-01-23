//============================================================
//INTERFACE VS ABSTRACT CLASS COMPARISON
//============================================================
//Interfaces:
//- Cannot have constructors
//- All fields are public static final
//- Can extend multiple interfaces
//- Cannot have instance variables
//- Methods are public by default

//Abstract classes:
//- Can have constructors
//- Can have instance variables with any access modifier
//- Can only extend one class
//- Can have any access modifiers for methods
//- Can have concrete methods
// 

public class InterfacesReference {
    public static void main(String[] args) {
        basicInterfaces();
        interfaceInheritance();
        defaultMethods();
        staticMethods();
        functionalInterfaces();
    }

    //============================================================
    //BASIC INTERFACES USAGE
    //============================================================
    public static void basicInterfaces() {
        //Create objects that implement interfaces
        //Interface reference can point to any implementing class
        Animal dog = new Dog();
        dog.makeSound(); //"Bark"
        dog.eat(); //"Dog is eating"
        
        Animal cat = new Cat();
        cat.makeSound(); //"Meow"
    }

    //============================================================
    //DEFAULT METHODS (Java 8+) - Predefined don't all have to be overrridden
    //============================================================
    public static void defaultMethods() {
        //Default methods provide implementation in interface
        Vehicle car = new Car();
        car.start(); //"Vehicle started" (default implementation)
        car.stop(); //"Car stopped" (overridden)
        
        Vehicle bike = new Bike();
        bike.start(); //"Vehicle started" (uses default)
        bike.stop(); //"Bike stopped" (overridden)
    }

    //============================================================
    //STATIC METHODS IN INTERFACES (Java 8+)
    //============================================================
    public static void staticMethods() {
        //Static methods called on interface itself
        int sum = MathOperations.add(5, 3); //8
        int product = MathOperations.multiply(5, 3); //15
        
        //Cannot be called on implementing class
        //Calculator calc = new Calculator();
        //calc.add(5, 3); //Compilation error
    }

    //============================================================
    //FUNCTIONAL INTERFACES (Java 8+) -> 
    // Only one abstract method allows for incode imlementations with lambda expressions
    //============================================================
    public static void functionalInterfaces() {
        Converter<String, Integer> stringToInt = s -> Integer.parseInt(s);
        Integer result = stringToInt.convert("123"); //123
        
        Converter<Integer, String> intToString = i -> String.valueOf(i);
        String str = intToString.convert(456); //"456"
        
        //Predicate example
        Predicate<Integer> isEven = n -> n % 2 == 0;
        System.out.println(isEven.test(4)); //true
        System.out.println(isEven.test(5)); //false
    }
}

//============================================================
//BASIC INTERFACE DEFINITION
//============================================================
interface Animal {
    //All methods are public and abstract by default
    void makeSound();
    void eat();

    //Default method provides implementation
    default void run() {
        System.out.println("Run started");
    }
    
    //Constants are public static final by default
    int MAX_AGE = 100;
}

class Dog implements Animal {
    //Must implement all abstract methods
    @Override
    public void makeSound() {
        System.out.println("Bark");
    }
    
    @Override
    public void eat() {
        System.out.println("Dog is eating");
    }

    @Override
    public void run() {
        System.out.println("Dog is running");
    }
}

class Cat implements Animal {
    @Override
    public void makeSound() {
        System.out.println("Meow");
    }
    
    @Override
    public void eat() {
        System.out.println("Cat is eating");
    }
}

interface Movable {
    void move();
}

//============================================================
//MULTIPLE INTERFACE IMPLEMENTATION
//============================================================
class Robot implements Animal, Movable {
    @Override
    public void makeSound() {
        System.out.println("Beep boop");
    }
    
    @Override
    public void eat() {
        System.out.println("Robot charging");
    }
    
    @Override
    public void move() {
        System.out.println("Robot moving");
    }
}

//============================================================
//INTERFACE INHERITANCE
//============================================================
interface Device {
    void charge();
}

interface Phone extends Device {
    void call();
}

//============================================================
//DEFAULT METHODS (Java 8+)
//============================================================
interface Vehicle {
    void stop(); //Abstract method
    
    //Default method provides implementation
    default void start() {
        System.out.println("Vehicle started");
    }
    
    default void honk() {
        System.out.println("Beep!");
    }
}

class Car implements Vehicle {
    @Override
    public void stop() {
        System.out.println("Car stopped");
    }
    
    //Can override default methods
    @Override
    public void honk() {
        System.out.println("Car horn: HONK!");
    }
    //start() uses default implementation
}

class Bike implements Vehicle {
    @Override
    public void stop() {
        System.out.println("Bike stopped");
    }
    //Uses default implementations for start() and honk()
}

//============================================================
//STATIC METHODS IN INTERFACES (Java 8+)
//============================================================
interface MathOperations {
    //Static methods in interfaces
    static int add(int a, int b) {
        return a + b;
    }
    
    static int multiply(int a, int b) {
        return a * b;
    }
    
    //Can have both static and abstract methods
    int subtract(int a, int b); //Abstract
}

class Calculator implements MathOperations {
    @Override
    public int subtract(int a, int b) {
        return a - b;
    }
    //Cannot override static methods from interface
}

//============================================================
//FUNCTIONAL INTERFACES (Java 8+)
//============================================================
@FunctionalInterface //Optional annotation for compile-time checking
interface Converter<F, T> {
    T convert(F from); //Single abstract method
    
    //Can have default methods
    default void log(F from, T to) {
        System.out.println("Converted " + from + " to " + to);
    }
    
    //Can have static methods
    static <F, T> void printConversion(F from, T to) {
        System.out.println(from + " -> " + to);
    }
}

@FunctionalInterface
interface Predicate<T> {
    boolean test(T value);
    
    //Default method for combining predicates
    default Predicate<T> and(Predicate<T> other) {
        return value -> this.test(value) && other.test(value);
    }
    
    default Predicate<T> or(Predicate<T> other) {
        return value -> this.test(value) || other.test(value);
    }
}

//============================================================
//MARKER INTERFACE (Empty interface)
//============================================================
interface Serializable {
    //No methods - used to mark classes
}

class Data implements Serializable {
    private int value;
    //Class is now marked as Serializable
}

