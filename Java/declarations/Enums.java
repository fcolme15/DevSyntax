public class EnumsReference {
    public static void main(String[] args) {
        basicEnumsUsage();
        enumWithFields();
        enumMethods();
        enumInSwitch();
        enumCollections();
    }

    //============================================================
    //BASIC ENUMS
    //============================================================
    public static void basicEnumsUsageUsage() {
        //Enum declaration and usage
        Day today = Day.MONDAY;
        Day tomorrow = Day.TUESDAY;
        
        //Compare enums -> use == or .equals()
        boolean same = (today == Day.MONDAY); //true
        boolean same2 = today.equals(Day.MONDAY); //true
        
        //Get enum name as string
        String name = today.name(); //"MONDAY"
        
        //Get enum ordinal (position in declaration, starts at 0)
        int position = today.ordinal(); //0
        
        //Convert string to enum
        Day parsed = Day.valueOf("WEDNESDAY"); //Day.WEDNESDAY
        //Day invalid = Day.valueOf("INVALID"); //IllegalArgumentException
        
        //Get all enum values
        Day[] allDays = Day.values();
        for(Day day : allDays) {
            System.out.println(day.name() + " - " + day.ordinal());
        }
    }

    //============================================================
    //ENUMS WITH FIELDS AND METHODS
    //============================================================
    public static void enumWithFields() {
        //Access enum fields
        System.out.println(Planet.EARTH.getMass()); //5.976e24
        System.out.println(Planet.MARS.surfaceGravity()); //3.71
        
        //Calculate weight on different planets
        double earthWeight = 80.0;
        double marsWeight = earthWeight / Planet.EARTH.surfaceGravity() * Planet.MARS.surfaceGravity();
        
        
    }

    //============================================================
    //ENUM METHODS
    //============================================================
    public static void enumMethods() {
        //compareTo() - compares ordinal values
        int comparison = Day.MONDAY.compareTo(Day.FRIDAY); //Negative (MONDAY < FRIDAY)
        
        //toString() - returns name by default, can be overridden
        String str = Day.MONDAY.toString(); //"MONDAY"
        
        //Custom enum methods
        Day day = Day.SATURDAY;
        boolean isWeekend = day.isWeekend(); //true
        
        //Enum with abstract methods
        Operation add = Operation.PLUS;
        double result = add.apply(5, 3); //8.0
        
        Operation multiply = Operation.MULTIPLY;
        result = multiply.apply(5, 3); //15.0
    }

    //============================================================
    //ENUMS IN SWITCH STATEMENTS
    //============================================================
    public static void enumInSwitch() {
        Day today = Day.WEDNESDAY;
        
        //Traditional switch
        switch(today) {
            case MONDAY:
                System.out.println("Start of work week");
                break;
            case FRIDAY:
                System.out.println("Almost weekend");
                break;
            case SATURDAY:
            case SUNDAY:
                System.out.println("Weekend!");
                break;
            default:
                System.out.println("Midweek");
        }
        
        //Switch expression (Java 14+)
        String message = switch(today) {
            case MONDAY -> "Start of work week";
            case FRIDAY -> "Almost weekend";
            case SATURDAY, SUNDAY -> "Weekend!";
            default -> "Midweek";
        };
        
        //Pattern matching with switch (Java 21+)
        TrafficLight light = TrafficLight.RED;
        String action = switch(light) {
            case RED -> "Stop";
            case YELLOW -> "Slow down";
            case GREEN -> "Go";
        };
    }

    //============================================================
    //ENUMS WITH COLLECTIONS
    //============================================================
    public static void enumCollections() {
        //EnumSet - specialized Set for enums 
        java.util.EnumSet<Day> weekend = java.util.EnumSet.of(Day.SATURDAY, Day.SUNDAY);
        java.util.EnumSet<Day> weekdays = java.util.EnumSet.range(Day.MONDAY, Day.FRIDAY);
        java.util.EnumSet<Day> allDays = java.util.EnumSet.allOf(Day.class);
        
        //EnumMap - specialized Map with enum keys 
        java.util.EnumMap<Day, String> schedule = new java.util.EnumMap<>(Day.class);
        schedule.put(Day.MONDAY, "Meeting at 9am");
        schedule.put(Day.WEDNESDAY, "Lunch with team");
        
        //Iterate through enum set
        for(Day day : weekend) {
            System.out.println(day + " is a weekend day");
        }
        
        //Check membership
        boolean hasMonday = weekdays.contains(Day.MONDAY); //true
    }
}

//============================================================
//SIMPLE ENUM
//============================================================
enum Day {
    MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY;
    
    //Custom method in enum
    public boolean isWeekend() {
        return this == SATURDAY || this == SUNDAY;
    }
}

//============================================================
//ENUM WITH FIELDS AND CONSTRUCTOR
//============================================================
enum Planet {
    MERCURY(3.303e23, 2.4397e6),
    VENUS(4.869e24, 6.0518e6),
    EARTH(5.976e24, 6.37814e6),
    MARS(6.421e23, 3.3972e6);
    
    private final double mass; //in kilograms
    private final double radius; //in meters
    private static final double G = 6.67300e-11; //gravitational constant
    
    //Constructor is always private (implicit)
    Planet(double mass, double radius) {
        this.mass = mass;
        this.radius = radius;
    }
    
    public double getMass() {
        return mass;
    }
    
    public double getRadius() {
        return radius;
    }
    
    public double surfaceGravity() {
        return G * mass / (radius * radius);
    }
}

//============================================================
//ENUM WITH ABSTRACT METHODS
//============================================================
enum Operation {
    PLUS {
        public double apply(double x, double y) {
            return x + y;
        }
    },
    MINUS {
        public double apply(double x, double y) {
            return x - y;
        }
    },
    MULTIPLY {
        public double apply(double x, double y) {
            return x * y;
        }
    },
    DIVIDE {
        public double apply(double x, double y) {
            return x / y;
        }
    };
    
    //Abstract method that each enum constant must implement
    public abstract double apply(double x, double y);
}

//============================================================
//ENUM FOR STATE MACHINE
//============================================================
enum TrafficLight {
    RED(30),
    YELLOW(5),
    GREEN(45);
    
    private final int duration; //seconds
    
    TrafficLight(int duration) {
        this.duration = duration;
    }
    
    public int getDuration() {
        return duration;
    }
    
    public TrafficLight next() {
        return switch(this) {
            case RED -> GREEN;
            case GREEN -> YELLOW;
            case YELLOW -> RED;
        };
    }
}