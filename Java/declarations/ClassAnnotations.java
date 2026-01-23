public class AnnotationsReference {
    public static void main(String[] args) {
        builtInAnnotationsUsage();
        customAnnotationsUsage();
    }

    //============================================================
    //BUILT-IN ANNOTATIONS - USAGE
    //============================================================
    public static void builtInAnnotationsUsage() {
        DeprecatedExample obj = new DeprecatedExample();
        obj.oldMethod(); //Shows warning if @Deprecated is used
        obj.newMethod();
        
        OverrideExample child = new OverrideExample();
        child.display(); //Overrides parent method
    }

    //============================================================
    //CUSTOM ANNOTATIONS - USAGE
    //============================================================
    public static void customAnnotationsUsage() {
        //Annotations provide metadata
        //Can be accessed via reflection at runtime
        
        TestClass test = new TestClass();
        //Reflection would be used to find @Test methods and execute them
    }
}

//============================================================
//@Override - Indicates method overrides superclass method
//============================================================
class Parent {
    public void display() {
        System.out.println("Parent");
    }
}

class OverrideExample extends Parent {
    @Override //Compiler checks if method actually overrides
    public void display() {
        System.out.println("Child");
    }
    
    //@Override
    //public void displya() { //Compilation error - typo, not overriding
    //}
}

//============================================================
//@Deprecated - Marks element as deprecated
//============================================================
class DeprecatedExample {
    @Deprecated //Shows warning when used
    public void oldMethod() {
        System.out.println("Old method");
    }
    
    @Deprecated(since = "2.0", forRemoval = true)
    public void veryOldMethod() {
        System.out.println("Will be removed");
    }
    
    public void newMethod() {
        System.out.println("New method");
    }
}

//============================================================
//@SuppressWarnings - Suppresses compiler warnings
//============================================================
class SuppressWarningsExample {
    @SuppressWarnings("unchecked") //Suppress specific warning
    public void methodWithWarning() {
        List rawList = new ArrayList(); //No generic type
        rawList.add("item");
    }
    
    @SuppressWarnings({"unchecked", "deprecation"}) //Multiple warnings
    public void multipleWarnings() {
        List list = new ArrayList();
        DeprecatedExample obj = new DeprecatedExample();
        obj.oldMethod();
    }
    
    @SuppressWarnings("all") //Suppress all warnings
    public void allWarnings() {
        //Suppresses all compiler warnings
    }
}

//============================================================
//@FunctionalInterface - Marks interface as functional
//============================================================
@FunctionalInterface //Compiler enforces single abstract method
interface Calculator {
    int calculate(int a, int b); //Single abstract method
    
    //int anotherMethod(int x); //Compilation error - multiple abstract methods
    
    //Can have default and static methods
    default void log() {
        System.out.println("Logging");
    }
    
    static void info() {
        System.out.println("Calculator interface");
    }
}

//============================================================
//@SafeVarargs - Suppresses varargs warnings
//============================================================
class SafeVarargsExample {
    @SafeVarargs //Suppress heap pollution warning
    public final void process(List<String>... lists) {
        for(List<String> list : lists) {
            System.out.println(list);
        }
    }
}

//============================================================
//CUSTOM ANNOTATION DEFINITIONS
//============================================================

//Simple marker annotation (no elements)
@interface Test {
}

//Annotation with single element
@interface Author {
    String value(); //Single element named "value"
}

//Annotation with multiple elements
@interface Info {
    String name();
    String version();
    String date() default "unknown"; //Default value
}

//Annotation with array element
@interface Tags {
    String[] value();
}

//============================================================
//ANNOTATION USAGE EXAMPLES
//============================================================
class TestClass {
    @Test //Marker annotation
    public void testMethod1() {
        System.out.println("Test 1");
    }
    
    @Author("Alice") //Single element (value)
    public void method1() {
    }
    
    @Info(name = "Method", version = "1.0") //Multiple elements, date uses default
    public void method2() {
    }
    
    @Info(name = "Method", version = "2.0", date = "2024-01-01") //All elements
    public void method3() {
    }
    
    @Tags({"important", "critical"}) //Array element
    public void method4() {
    }
}

//============================================================
//META-ANNOTATIONS (Annotations for annotations)
//============================================================

//@Retention - How long annotation is retained
@Retention(RetentionPolicy.RUNTIME) //Available at runtime via reflection
@interface RuntimeAnnotation {
    String value();
}

@Retention(RetentionPolicy.SOURCE) //Discarded by compiler
@interface SourceAnnotation {
    String value();
}

@Retention(RetentionPolicy.CLASS) //Retained in .class file but not at runtime
@interface ClassAnnotation {
    String value();
}

//@Target - Where annotation can be used
@Target(ElementType.METHOD) //Only on methods
@interface MethodOnly {
    String value();
}

@Target(ElementType.TYPE) //Only on classes, interfaces, enums
@interface TypeOnly {
    String value();
}

@Target({ElementType.METHOD, ElementType.FIELD}) //Multiple targets
@interface MethodOrField {
    String value();
}

//@Documented - Include in Javadoc
@Documented
@interface DocumentedAnnotation {
    String value();
}

//@Inherited - Annotation inherited by subclasses
@Inherited
@interface InheritedAnnotation {
    String value();
}

//@Repeatable - Annotation can be used multiple times
@Repeatable(Schedules.class)
@interface Schedule {
    String day();
}

@interface Schedules {
    Schedule[] value();
}

//Usage of @Repeatable
class RepeatingExample {
    @Schedule(day = "Monday")
    @Schedule(day = "Wednesday")
    @Schedule(day = "Friday")
    public void meeting() {
    }
}
