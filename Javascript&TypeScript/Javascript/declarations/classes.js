function mainSummary() {
	comprehensiveClassExample();
	classExpressions();
	inheritance();
}

function comprehensiveClassExample() {
	class BankAccount {
		//Instance property (not static)
		accountType = "Checking";
		
		//Static property - shared across all instances
		static interestRate = 0.05;
		static bankName = "MyBank";
		
		//Private field - # prefix
		#balance = 0;
		#pin;
		
		//Constructor - only one allowed, no overloading
		constructor(owner, initialBalance = 0, pin) {
			this.owner = owner; //Public property
			this.#balance = initialBalance; //Private property
			this.#pin = pin;
			this.transactions = []; //Public property
		}
		
		//Instance methods
		deposit(amount) {
			this.#balance += amount;
			this.transactions.push(`Deposit: ${amount}`);
			return this; //Return this for method chaining
		}
		
		withdraw(amount, pin) {
			if (!this.#verifyPin(pin)) {
				console.log("Invalid PIN");
				return this;
			}
			if (amount > this.#balance) {
				console.log("Insufficient funds");
				return this;
			}
			this.#balance -= amount;
			this.transactions.push(`Withdrawal: ${amount}`);
			return this;
		}
		
		//Private method
		#verifyPin(pin) {
			return pin === this.#pin;
		}
		
		#calculateInterest() {
			return this.#balance * BankAccount.interestRate;
		}
		
		//Getter - accessed like property
		get balance() {
			return this.#balance;
		}
		
		get accountInfo() {
			return `${this.owner}'s ${this.accountType} at ${BankAccount.bankName}`;
		}
		
		//Setter - set like property
		set balance(amount) {
			if (amount < 0) {
				console.log("Balance cannot be negative");
				return;
			}
			this.#balance = amount;
		}
		
		//Static method - called on class, not instance
		static compareAccounts(acc1, acc2) {
			return acc1.balance - acc2.balance;
		}
		
		static formatCurrency(amount) {
			return `$${amount.toFixed(2)}`;
		}
	}
	
	//Usage
	const account1 = new BankAccount("John", 1000, "1234");
	const account2 = new BankAccount("Jane", 500, "5678");
	
	//Instance methods and chaining
	account1.deposit(200).withdraw(50, "1234");
	console.log(account1.balance); //1150
	
	//Getters accessed like properties
	console.log(account1.accountInfo); //"John's Checking at MyBank"
	
	//Setter
	account1.balance = 2000;
	console.log(account1.balance); //2000
	
	//Static methods called on class
	console.log(BankAccount.compareAccounts(account1, account2)); //Positive number
	console.log(BankAccount.formatCurrency(account1.balance)); //"$2000.00"
	console.log(BankAccount.bankName); //"MyBank"
	
	//Static NOT accessible on instances
	console.log(account1.bankName); //undefined
	//account1.formatCurrency(100); //Error - not a function
	
	//Private fields NOT accessible outside class
	//console.log(account1.#balance); //Error
	//account1.#verifyPin("1234"); //Error
	
	//Public properties accessible
	console.log(account1.owner); //"John"
	console.log(account1.accountType); //"Checking"
}


function classExpressions() {
	//Anonymous class expression
	const Animal = class {
		constructor(type) {
			this.type = type;
		}
		speak() {
			console.log(`${this.type} makes a sound`);
		}
	};
	const cat = new Animal("Cat");
	cat.speak(); //"Cat makes a sound"
	
	//Named class expression
	const Vehicle = class Car {
		constructor(brand) {
			this.brand = brand;
		}
		//Car name only accessible inside class
		static getClassName() {
			return Car.name; //"Car"
		}
	};
	const toyota = new Vehicle("Toyota");
	console.log(Vehicle.getClassName()); //"Car"
	//console.log(Car); //Error - Car not defined outside
}


function inheritance() {
	//Parent class
	class Animal {
		constructor(name, species) {
			this.name = name;
			this.species = species;
		}
		
		speak() {
			console.log(`${this.name} makes a sound`);
		}
		
		getInfo() {
			return `${this.name} is a ${this.species}`;
		}
	}
	
	//Child class extends parent
	class Dog extends Animal {
		constructor(name, breed) {
			super(name, "Dog"); //Must call super before accessing this
			this.breed = breed;
		}
		
		//Override parent method
		speak() {
			console.log(`${this.name} barks`);
		}
		
		//Call parent method with super
		parentSpeak() {
			super.speak();
		}
		
		//Child-specific method
		fetch() {
			console.log(`${this.name} fetches the ball`);
		}
	}
	
	const dog = new Dog("Rex", "Labrador");
	dog.speak(); //"Rex barks" - overridden method
	dog.parentSpeak(); //"Rex makes a sound" - parent method
	dog.fetch(); //"Rex fetches the ball"
	console.log(dog.getInfo()); //"Rex is a Dog" - inherited method
	
	//instanceof checks
	console.log(dog instanceof Dog); //true
	console.log(dog instanceof Animal); //true
	console.log(dog instanceof Object); //true
	
	//Multi-level inheritance
	class Puppy extends Dog {
		constructor(name, breed, age) {
			super(name, breed);
			this.age = age;
		}
	}
	
	const puppy = new Puppy("Max", "Beagle", 1);
	console.log(puppy instanceof Puppy); //true
	console.log(puppy instanceof Dog); //true
	console.log(puppy instanceof Animal); //true
}