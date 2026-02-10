function mainSummaryClasses() {
    classesBasicClass();
    classesAccessModifiers();
    classesInheritance();
    classesAbstractClasses();
}

//TypeScript-specific class features:
//- Access modifiers: public, private, protected
//- Parameter properties (constructor shorthand: constructor(public name: string))
//- readonly properties
//- Override inheritance methods
//- Abstract classes and abstract methods
//- implements keyword for interface enforcement
//- Static type checking for all members

function classesBasicClass() {
    class Person {
        name: string;
        age: number;

        constructor(name: string, age: number) {
            this.name = name;
            this.age = age;
        }

        greet(): string {
            return `Hello, I'm ${this.name}`;
        }
    }
    let person = new Person("John", 30);

    //Parameter properties (shorthand). Same as above.
    class User {
        constructor(public name: string, public age: number) {}
        //Automatically creates and assigns name and age properties
    }

    //Readonly properties
    class Point {
        readonly x: number;
        readonly y: number;

        constructor(x: number, y: number) {
            this.x = x;
            this.y = y;
        }
    }
    let point = new Point(10, 20);

    //Static members
    class MathUtils {
        static PI: number = 3.14159;

        static square(x: number): number {
            return x * x;
        }
    }

    console.log(MathUtils.PI);
    console.log(MathUtils.square(5));
}

function classesAccessModifiers() {
    class BankAccount {
        public accountNumber: string; //Accessible everywhere (default)
        private balance: number; //Only accessible within class
        protected owner: string; //Accessible within class and subclasses

        constructor(accountNumber: string, initialBalance: number, owner: string) {
            this.accountNumber = accountNumber;
            this.balance = initialBalance;
            this.owner = owner;
        }

        public deposit(amount: number): void {
            this.balance += amount;
        }

        public getBalance(): number {
            return this.balance;
        }
    }

    let account = new BankAccount("123", 1000, "John");
    account.deposit(500);
    console.log(account.accountNumber); //OK - public
    //console.log(account.balance); //Error - private
    //console.log(account.owner); //Error - protected
}

function classesInheritance() {
    //Showing overriding a parent class method

    class Animal {
        constructor(public name: string) {}

        move(distance: number): void {
            console.log(`${this.name} moved ${distance}m`);
        }
    }

    class Dog extends Animal {
        constructor(name: string, public breed: string) {
            super(name); //Call parent constructor
        }

        bark(): void {
            console.log("Woof!");
        }

        //Override parent method
        move(distance: number): void {
            console.log("Running...");
            super.move(distance); //Call parent method
        }
    }

    let dog = new Dog("Buddy", "Golden Retriever");
    dog.bark();
    dog.move(10);

    //Implementing interfaces
    interface Drawable {
        draw(): void;
    }

    class Circle implements Drawable {
        constructor(public radius: number) {}

        draw(): void {
            console.log(`Drawing circle with radius ${this.radius}`);
        }
    }
}

/* Abstract classes vs interfaces: Abstract classes allow for function implementation and constructors
AKA: Abstract class = interface + shared implementation + constructors. */
function classesAbstractClasses() {
    //Abstract class - cannot be instantiated directly
    abstract class Shape {
        constructor(public color: string) {}

        abstract area(): number; //Must be implemented by subclass
        abstract perimeter(): number;

        //Concrete method
        describe(): string {
            return `A ${this.color} shape with area ${this.area()}`;
        }
    }

    class Rectangle extends Shape {
        constructor(color: string, public width: number, public height: number) {
            super(color);
        }

        area(): number {
            return this.width * this.height;
        }

        perimeter(): number {
            return 2 * (this.width + this.height);
        }
    }

    //let shape = new Shape("red"); //Error: Cannot create instance of abstract class
    let rect = new Rectangle("blue", 10, 5);
    console.log(rect.describe());
}