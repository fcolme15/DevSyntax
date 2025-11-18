#Covers: classes, inheritance, virtual methods, @property, @staticmethod, @classmethod, magic methods

from abc import ABC, abstractmethod 

#============================================================
#BASIC CLASS
#============================================================

class Car:
    
    #Class variable - shared by ALL instances of the class
    wheels: int = 4
    total_cars: int = 0
    
    def __init__(self, brand: str, model: str, year: int) -> None:
        """Constructor"""
        #Class instance variables - unique to each instance
        self.brand: str = brand
        self.model: str = model
        self.year: int = year
        self.mileage: float = 0.0
        self._fuel: float = 100.0 #Protected by convention not enforced (signified by the _)
        self.__vin: str = "ABC123" #Private by convention not enforced (signified by the __)
        
        #Increment class variable
        Car.total_cars += 1
    
    #Instance method - operates on instance (self)
    def drive(self, miles: float) -> None:
        """Regular instance method"""
        self.mileage += miles
        self._fuel -= miles * 0.05
        print(f"Drove {miles} miles. Total: {self.mileage}")
    
    def refuel(self) -> None:
        """Another instance method"""
        self._fuel = 100.0
        print("Refueled!")
    
    #Getter method using @property decorator
    @property
    def fuel(self) -> float:
        """Access like attribute: car.fuel instead of car.fuel()"""
        return self._fuel
    
    #Setter method using @property.setter
    @fuel.setter
    def fuel(self, amount: float) -> None:
        """Set like attribute: car.fuel = 50"""
        if 0 <= amount <= 100:
            self._fuel = amount
        else:
            raise ValueError("Fuel must be between 0 and 100")
    
    #Class method - operates on class, not instance
    @classmethod
    def from_string(cls, car_string: str) -> "Car":
        """Alternative constructor using @classmethod.
        Needed as its a constructor that takes in a string then calls the normal constructor"""
        brand, model, year = car_string.split(",")
        
        #cls refers to the class constructor. If inherited class calls method it calls the inherited construtor
        return cls(brand, model, int(year)) 
    @classmethod
    def get_total_cars(cls) -> int:
        """Access class variables"""
        return cls.total_cars
    
    #Static method - doesn't need self or cls and is called using the class name not the instance of the class
    @staticmethod
    def is_vintage(year: int) -> bool:
        """Utility function related to class but independent"""
        return year < 2000
    
    #Magic method - string representation
    def __str__(self) -> str:
        """Called by str() and print() - user-friendly"""
        return f"{self.year} {self.brand} {self.model}"
    
    def __repr__(self) -> str:
        """Called by repr() - developer-friendly, should be unambiguous"""
        return f"Car(brand='{self.brand}', model='{self.model}', year={self.year})"
    
    #Magic method - comparison
    def __eq__(self, other: object) -> bool:
        """Called by == operator"""
        if not isinstance(other, Car):
            return False
        return (self.brand == other.brand and 
                self.model == other.model and 
                self.year == other.year)
    
    def __lt__(self, other: "Car") -> bool:
        """Called by < operator"""
        return self.year < other.year
    
    #Magic method - arithmetic
    def __add__(self, other: "Car") -> float:
        """Called by + operator"""
        return self.mileage + other.mileage
    
    #Magic method - length
    def __len__(self) -> int:
        """Called by len()"""
        return int(self.mileage)
    
    #Magic method - container access
    def __getitem__(self, key: str) -> str | int:
        """Called by car['brand']"""
        if key == "brand":
            return self.brand
        elif key == "model":
            return self.model
        elif key == "year":
            return self.year
        raise KeyError(f"Invalid key: {key}")


#============================================================
#INHERITANCE - ElectricCar inherits from Car
#============================================================

class ElectricCar(Car): #Inherits from car
    
    def __init__(self, brand: str, model: str, year: int, battery_size: int) -> None:
        """Constructor that calls parent constructor"""
        super().__init__(brand, model, year) #Call parent __init__

        #New attributes
        self.battery_size: int = battery_size 
        self.charge: float = 100.0 
    
    #Override parent method
    def drive(self, miles: float) -> None:
        """Override drive to use battery instead of fuel"""
        self.mileage += miles
        self.charge -= miles * 0.3
        print(f"Drove {miles} miles on battery. Charge: {self.charge}%")
    
    #Override parent method
    def refuel(self) -> None:
        """Override refuel to charge battery"""
        self.charge = 100.0
        print("Battery charged!")
    
    #New method
    def fast_charge(self) -> None:
        """Method unique to ElectricCar"""
        self.charge = 80.0
        print("Fast charged to 80%!")
    
    #Override magic method
    def __str__(self) -> str:
        """Override parent's __str__"""
        return f"{self.year} {self.brand} {self.model} (Electric)"


#============================================================
#ABSTRACT BASE CLASS - Cannot be instantiated
#============================================================

class Vehicle(ABC): #Needs ABC inheritance 
    """Abstract class using ABC - defines interface"""
    
    def __init__(self, brand: str) -> None:
        self.brand: str = brand
    
    #Abstract method - MUST be implemented by subclasses
    @abstractmethod
    def start_engine(self) -> None:
        """Subclasses must implement this"""
        pass #Or use ... (Ellipsis)
    
    @abstractmethod
    def stop_engine(self) -> None:
        """Another required method"""
        ... #Use Ellipsis instead of pass
    
    #Concrete method - optional to override
    def honk(self) -> None:
        """Regular method that can be used as-is or overridden"""
        print("Beep beep!")


#Concrete implementation of abstract class
class Motorcycle(Vehicle):
    """Must implement all abstract methods"""
    
    def __init__(self, brand: str, has_sidecar: bool) -> None:
        super().__init__(brand)
        self.has_sidecar: bool = has_sidecar
    
    #Implement required abstract method
    def start_engine(self) -> None:
        print(f"{self.brand} motorcycle engine started: Vroom!")
    
    #Implement required abstract method
    def stop_engine(self) -> None:
        print(f"{self.brand} motorcycle engine stopped")
    
    #Override optional concrete method
    def honk(self) -> None:
        print("Beep! Beep! (motorcycle horn)")


#============================================================
#USAGE EXAMPLES
#============================================================

def demo() -> None:
    """Demonstrates class usage"""
    
    #Create instances
    car1: Car = Car("Toyota", "Camry", 2020)
    car2: Car = Car("Honda", "Civic", 2019)
    
    #Instance variables are unique
    car1.drive(50)
    print(f"car1 mileage: {car1.mileage}") #50
    print(f"car2 mileage: {car2.mileage}") #0
    
    #Class variables are shared
    print(f"Total cars: {Car.total_cars}") #2
    print(f"Wheels: {car1.wheels}") #4
    
    #Using @property
    print(f"Fuel: {car1.fuel}") #Access like attribute
    car1.fuel = 75 #Set like attribute
    
    #Using @classmethod
    car3: Car = Car.from_string("Ford,Mustang,2021")
    
    #Using @staticmethod
    is_old: bool = Car.is_vintage(1995) #True
    
    #Magic methods
    print(car1) #Calls __str__
    print(repr(car1)) #Calls __repr__
    is_equal: bool = car1 == car2 #Calls __eq__
    total_miles: float = car1 + car2 #Calls __add__
    length: int = len(car1) #Calls __len__
    brand: str | int = car1["brand"] #Calls __getitem__
    
    #Inheritance
    tesla: ElectricCar = ElectricCar("Tesla", "Model 3", 2022, 75)
    tesla.drive(30) #Calls overridden method
    tesla.fast_charge() #Calls new method
    
    #Abstract class
    #vehicle = Vehicle("Generic") #ERROR - cannot instantiate ABC
    bike: Motorcycle = Motorcycle("Harley", False)
    bike.start_engine() #Must implement
    bike.honk() #Can override or use parent's
    
    #Protected vs private
    print(car1._fuel) #Protected - can access but shouldn't
    #print(car1.__vin) #ERROR - name mangled to _Car__vin
    print(car1._Car__vin) #Can access but very bad practice


if __name__ == "__main__":
    demo()