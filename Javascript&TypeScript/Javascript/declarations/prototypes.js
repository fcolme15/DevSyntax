function mainSummary() {
	prototypeBasics();
	constructorFunctions();
	prototypeChain();
	objectCreate();
	prototypeModification();
}

//============================================================
//Prototypes: How JavaScript actually works under the hood
//Classes: Syntactic sugar over prototypes (ES6+)
//Prototype is an object that other objects inherit properties and methods from. 
//It's JavaScript's mechanism for inheritance - 
//NOT a template/blueprint like classes in other languages.
//============================================================

function prototypeBasics() {
	//Every function has a prototype property
	function Person(name) {
		this.name = name;
	}
	
	//Add method to prototype
	Person.prototype.greet = function() {
		console.log(`Hello, I'm ${this.name}`);
	};
	
	const john = new Person("John");
	john.greet(); //"Hello, I'm John"
	
	//Method is on prototype, not instance
	console.log(john.hasOwnProperty("name")); //true
	console.log(john.hasOwnProperty("greet")); //false - on prototype
	
	//Check prototype
	console.log(Object.getPrototypeOf(john) === Person.prototype); //true
	console.log(john.__proto__ === Person.prototype); //true - deprecated way
	
	//All instances share same prototype
	const jane = new Person("Jane");
	console.log(john.greet === jane.greet); //true - same function reference
}

function constructorFunctions() {
	//Constructor function - pre-ES6 way to create classes
	function Car(brand, model) {
		this.brand = brand;
		this.model = model;
		//Avoid defining methods here - creates new function per instance
	}
	
	//Add methods to prototype instead
	Car.prototype.getInfo = function() {
		return `${this.brand} ${this.model}`;
	};
	
	Car.prototype.start = function() {
		console.log(`${this.brand} starting`);
	};
	
	const car1 = new Car("Toyota", "Camry");
	const car2 = new Car("Honda", "Civic");
	
	console.log(car1.getInfo()); //"Toyota Camry"
	car2.start(); //"Honda starting"
	
	//Shared prototype methods
	console.log(car1.getInfo === car2.getInfo); //true
	
	//What 'new' does:
	//1. Creates empty object
	//2. Sets object's prototype to constructor's prototype
	//3. Calls constructor with 'this' bound to new object
	//4. Returns the object (unless constructor explicitly returns object)
}

function prototypeChain() {
	//Create constructor hierarchy
	function Animal(name) {
		this.name = name;
	}
	
	Animal.prototype.eat = function() {
		console.log(`${this.name} is eating`);
	};
	
	function Dog(name, breed) {
		Animal.call(this, name); //Call parent constructor
		this.breed = breed;
	}
	
	//Set up prototype chain
	Dog.prototype = Object.create(Animal.prototype);
	Dog.prototype.constructor = Dog; //Fix constructor reference
	
	Dog.prototype.bark = function() {
		console.log(`${this.name} barks`);
	};
	
	const dog = new Dog("Rex", "Labrador");
	dog.bark(); //"Rex barks"
	dog.eat(); //"Rex is eating" - from Animal prototype
	
	//Prototype chain: dog -> Dog.prototype -> Animal.prototype -> Object.prototype -> null
	console.log(dog instanceof Dog); //true
	console.log(dog instanceof Animal); //true
	console.log(dog instanceof Object); //true
	
	//Property lookup walks up prototype chain
	console.log(dog.hasOwnProperty("name")); //true - own property
	console.log(dog.hasOwnProperty("bark")); //false - on Dog.prototype
	console.log(dog.hasOwnProperty("eat")); //false - on Animal.prototype
}

function objectCreate() {
	//Object.create - creates object with specified prototype
	const personPrototype = {
		greet: function() {
			console.log(`Hello, I'm ${this.name}`);
		},
		introduce: function() {
			console.log(`My name is ${this.name}, age ${this.age}`);
		}
	};
	
	//Create object with personPrototype as prototype
	const john = Object.create(personPrototype);
	john.name = "John";
	john.age = 30;
	john.greet(); //"Hello, I'm John"
	
	//Create object with null prototype (no inherited properties)
	const bareObject = Object.create(null);
	bareObject.name = "test";
	//console.log(bareObject.toString()); //Error - no toString method
	
	//Object.create with property descriptors
	const jane = Object.create(personPrototype, {
		name: { value: "Jane", writable: true, enumerable: true },
		age: { value: 25, writable: true, enumerable: true }
	});
	jane.greet(); //"Hello, I'm Jane"
	
	//Compare with object literal
	const literalObject = {}; //Prototype is Object.prototype
	console.log(Object.getPrototypeOf(literalObject) === Object.prototype); //true
	
	//Create inherits from specific object
	const parent = { x: 10 };
	const child = Object.create(parent);
	child.y = 20;
	console.log(child.x); //10 - inherited from parent
	console.log(child.y); //20 - own property
}

function prototypeModification() {
	function Person(name) {
		this.name = name;
	}
	
	//Adding properties to prototype
	Person.prototype.greet = function() {
		console.log(`Hello ${this.name}`);
	};
	
	const john = new Person("John");
	john.greet(); //"Hello John"
	
	//Add method after instance created - still accessible
	Person.prototype.sayBye = function() {
		console.log(`Bye ${this.name}`);
	};
	john.sayBye(); //"Bye John" - dynamically added
	
	//Shadowing - instance property hides prototype property
	Person.prototype.age = 0;
	console.log(john.age); //0 - from prototype
	john.age = 30; //Create own property
	console.log(john.age); //30 - from instance (shadows prototype)
	
	const jane = new Person("Jane");
	console.log(jane.age); //0 - still gets from prototype
	
	//Check property location
	console.log(john.hasOwnProperty("age")); //true
	console.log(jane.hasOwnProperty("age")); //false
	
	//Delete to reveal prototype property
	delete john.age;
	console.log(john.age); //0 - now accesses prototype again
}