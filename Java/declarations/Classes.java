//Covers: classes, constructors, access modifiers, static vs instance, inheritance, abstract classes, final, Object methods

public class Classes {
    public static void main(String[] args) {
        //Create instances
        Car car1 = new Car("Toyota", "Camry", 2020);
        Car car2 = new Car("Toyota", "Camry", 2021);

        car1.drive(50);
        System.out.println("car1 mileage: " + car1.getMileage());
        
        //Class variables are shared across all instances
        System.out.println("Total cars: " + Car.getTotalCars());
        
        //Using getters/setters for private fields
        System.out.println("Fuel: " + car1.getFuel());
        car1.setFuel(75);
        
        //Object methods: toString(), equals(), hashCode()
        System.out.println(car1); //Calls toString()
        
        //Inheritance - ElectricCar extends Car
        ElectricCar tesla = new ElectricCar("Tesla", "Model 3", 2022, 75);
        tesla.drive(30); //Calls overridden method
        tesla.fastCharge(); //Calls new method specific to ElectricCar
        
        //Polymorphism - parent reference, child object
        Car polymorphicCar = new ElectricCar("Rivian", "R1T", 2023, 135);
        polymorphicCar.drive(20); //Calls ElectricCar's version
        
        //Casting to access subclass methods
        if (polymorphicCar instanceof ElectricCar) {
            ElectricCar electric = (ElectricCar) polymorphicCar;
            electric.fastCharge();
        }
        
        //Abstract class - cannot instantiate Vehicle directly
        //Vehicle v = new Vehicle("Generic"); //Compilation error
        Vehicle bike = new Motorcycle("Harley", false);
        bike.startEngine(); //Must implement abstract method
        
        //Final keyword examples
        final int MAX_VALUE = 100; //Final variable - constant
        //MAX_VALUE = 200; //Compilation error
        
        final Car car3 = new Car("Ford", "Mustang", 2021);
        car3.drive(10); //Can modify object
        //car3 = new Car("Chevy", "Corvette", 2022); //Compilation error - cannot reassign reference
    }
}

//============================================================
//CAR CLASS - Demonstrates basic class features
//============================================================
class Car {
    //Static key word makes it a class variable -> shared by all instances
    private static int totalCars = 0;
    
    //Instance variables - unique to each instance
    //Private so if inherited from it can only be accessed by getters and setters.
    private String brand;
    private String model;
    private int year;
    private double mileage;
    private double fuel;
    
    //Static block -> runs once when class is loaded
    static {
        totalCars = 0;
    }
    
    //Constructor #1 - Default constructor
    public Car() {
        //Constructor chaining, calling another constructor decided by the parameters given -> Calls constructor #3
        this("Unknown", "Unknown", 0);
    }

    //Constructor #2 
    public Car(String brand, String model) {
        this(brand, model, 2024);
    }

    //Constructor #3
    public Car(String brand, String model, int year) {
        this.brand = brand;
        this.model = model;
        this.year = year;
        this.mileage = 0.0;
        this.fuel = 100.0;
        totalCars++;
    }
    
    public void drive(double miles) { //Instance Method
        this.mileage += miles;
        this.fuel -= miles * 0.05;
    }
    
    public void refuel() { //Instance Method
        this.fuel = 100.0;
    }
    
    public double getFuel() { //Instance Method - Getter method
        return fuel;
    }
    
    public void setFuel(double amount) { //Instance Method - Setter method
        if (amount >= 0 && amount <= 100) {
            this.fuel = amount;
        }
    }
    
    public double getMileage() { //Instance Method - Getter method
        return mileage;
    }
    
    //Static method - operates on class, not instance. Ex: ClassName.StaticMethod();
    public static int getTotalCars() {
        return totalCars; //Can access static variables
        //return mileage; //Cannot access instance variables -> Compilation error
    }
    
    //Override Object class methods - .toString()
    @Override
    public String toString() {
        return year + " " + brand + " " + model;
    }
    
    //Override Object class methods - ==
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Car car = (Car) obj;
        return year == car.year && brand.equals(car.brand) && model.equals(car.model);
    }
    
    //Final key word - makes method that cannot be overridden in subclasses
    public final void displayWarranty() {
        System.out.println("5 year warranty");
    }
}

//============================================================
//ELECTRICCAR - Demonstrates inheritance
//============================================================
class ElectricCar extends Car {
    //New instance variables
    private int batterySize;
    private double charge;
    
    //Constructor - calls parent constructor with super()
    public ElectricCar(String brand, String model, int year, int batterySize) {
        super(brand, model, year); //Must be first line calling parent constructor
        this.batterySize = batterySize;
        this.charge = 100.0;
    }
    
    //Override parent method - 
    //@Override tells compiler its meant to override and forces a compile time error if nothing is overritten
    @Override
    public void drive(double miles) {
        //super.drive(miles); //Can call parent's version with super
        double newMileage = getMileage() + miles;
        this.charge -= miles * 0.3;
        System.out.println("Drove " + miles + " miles on battery");
    }
    
    @Override
    public void refuel() {
        this.charge = 100.0; 
    }
    
    //New method specific to ElectricCar
    public void fastCharge() {
        this.charge = 80.0;
    }
    
    //Override toString()
    @Override
    public String toString() {
        return super.toString() + " (Electric)"; 
    }
}

//============================================================
//VEHICLE - Abstract class (cannot be instantiated)
//============================================================
abstract class Vehicle {
    protected String brand; //Protected - accessible in subclasses and same package
    
    public Vehicle(String brand) {
        this.brand = brand;
    }
    
    //Abstract method - no implementation & Must be overridden by subclasses
    public abstract void startEngine();
}

//Concrete implementation of abstract class
class Motorcycle extends Vehicle {
    private boolean hasSidecar;
    
    public Motorcycle(String brand, boolean hasSidecar) {
        super(brand); //Call parent constructor
        this.hasSidecar = hasSidecar;
    }
    
    //Must implement all abstract methods from parent
    @Override
    public void startEngine() {
        System.out.println(brand + " motorcycle engine started: Vroom!");
    }
}

//============================================================
//FINAL CLASS - Cannot be extended
//============================================================
final class ImmutableConfig {
    private final String setting; //Final instance variable - must be initialized
    
    public ImmutableConfig(String setting) {
        this.setting = setting; //Can only set once in constructor
    }
}

//class ExtendConfig extends ImmutableConfig {} //Compilation error - cannot extend final class