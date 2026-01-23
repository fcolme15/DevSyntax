public class TypeCastingReference {
    public static void main(String[] args) {
        primitiveCastingUsage();
        referenceCastingUsage();
        autoboxingUsage();
    }

    //============================================================
    //PRIMITIVE TYPE CASTING - USAGE
    //============================================================
    public static void primitiveCastingUsage() {
        //Widening (implicit/automatic) - no data loss
        int intVal = 100;
        long longVal = intVal; //int -> long
        float floatVal = intVal; //int -> float
        double doubleVal = intVal; //int -> double
        
        byte byteVal = 10;
        short shortVal = byteVal; //byte -> short
        int intVal2 = byteVal; //byte -> int
        
        //Narrowing (explicit) - potential data loss, requires cast
        double d = 9.78;
        int i = (int) d; //9 (decimal part truncated)
        
        long l = 100L;
        int i2 = (int) l; //long -> int
        
        int largeInt = 130;
        byte b = (byte) largeInt; //-126 (overflow, wraps around)
        
        float f = 3.14f;
        int i3 = (int) f; //3
        
        //Character conversions
        char c = 'A';
        int asciiValue = c; //65 (widening)
        
        int num = 66;
        char ch = (char) num; //'B' (narrowing)
        
        //Boolean cannot be cast to/from other primitives
        //boolean bool = (boolean) 1; //Compilation error
    }

    //============================================================
    //REFERENCE TYPE CASTING - USAGE
    //============================================================
    public static void referenceCastingUsage() {
        //Upcasting (implicit) - child to parent
        Dog dog = new Dog();
        Animal animal = dog; //Dog -> Animal (automatic)
        
        //Can only call Animal methods
        animal.eat();
        //animal.bark(); //Compilation error - Animal doesn't have bark()
        
        //Downcasting (explicit) - parent to child
        Animal animal2 = new Dog();
        Dog dog2 = (Dog) animal2; //Must cast explicitly
        dog2.bark(); //Now can call Dog methods
        
        //ClassCastException if wrong type
        Animal animal3 = new Cat();
        //Dog dog3 = (Dog) animal3; //Runtime error: ClassCastException
        
        //instanceof check before casting
        if(animal3 instanceof Dog) {
            Dog dog3 = (Dog) animal3;
            dog3.bark();
        } else {
            System.out.println("Not a Dog");
        }
        
        //Pattern matching (Java 16+)
        if(animal3 instanceof Cat cat) {
            cat.meow(); //Variable 'cat' automatically created and cast
        }
        
        //Casting with interfaces
        Animal dog3 = new Dog();
        if(dog3 instanceof Movable) {
            Movable movable = (Movable) dog3;
            movable.move();
        }
    }

    //============================================================
    //AUTOBOXING AND UNBOXING - USAGE
    //============================================================
    public static void autoboxingUsage() {
        //Autoboxing - primitive to wrapper (automatic)
        int primitiveInt = 5;
        Integer wrapperInt = primitiveInt; //int -> Integer
        
        //Unboxing - wrapper to primitive (automatic)
        Integer wrapperInt2 = 10;
        int primitiveInt2 = wrapperInt2; //Integer -> int
        
        //Explicit boxing
        Integer explicit = Integer.valueOf(5);
        
        //Explicit unboxing
        int primitiveExplicit = explicit.intValue();
        
        //All wrapper classes
        Byte b = 1; //byte -> Byte
        Short s = 2; //short -> Short
        Integer i = 3; //int -> Integer
        Long l = 4L; //long -> Long
        Float f = 5.0f; //float -> Float
        Double d = 6.0; //double -> Double
        Character c = 'A'; //char -> Character
        Boolean bool = true; //boolean -> Boolean
        
        //NullPointerException risk
        Integer nullValue = null;
        //int crash = nullValue; //NullPointerException during unboxing
        
        //Wrapper to wrapper (must unbox then box)
        Integer intWrapper = 5;
        Long longWrapper = intWrapper.longValue(); //int -> long -> Long
        //Long wrong = intWrapper; //Compilation error
        
        //In collections - autoboxing happens automatically
        List<Integer> numbers = new ArrayList<>();
        numbers.add(5); //Autoboxes int to Integer
        int value = numbers.get(0); //Unboxes Integer to int
    }
}

//============================================================
//CLASS DEFINITIONS FOR EXAMPLES
//============================================================
class Animal {
    public void eat() {
        System.out.println("Eating");
    }
}

class Dog extends Animal implements Movable {
    public void bark() {
        System.out.println("Bark");
    }
    
    @Override
    public void move() {
        System.out.println("Dog moving");
    }
}

class Cat extends Animal {
    public void meow() {
        System.out.println("Meow");
    }
}

interface Movable {
    void move();
}