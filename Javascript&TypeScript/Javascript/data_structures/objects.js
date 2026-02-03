function mainSummary() {
	objectCreation();
	propertyAccessAddDelete();
	objectMethods();
	objectStaticMethods();
	propertyDescriptors();
	objectIteration();
}

function objectCreation() {
	//Object literal
	const obj1 = {
		name: "John",
		age: 30,
		city: "NYC"
	};
	
	//Empty object
	const obj2 = {};
	
	//Object constructor
	const obj3 = new Object();
	obj3.name = "Jane";
	
	//Object.create - creates object with specified prototype, keeping properties and their values
	const proto = { 
        age: 0, 
        greet() { console.log(`Hello, I'm ${this.name} and age ${this.age}`); } 
    };
	const obj4 = Object.create(proto);
	obj4.name = "Bob";
    obj4.greet(); //"Hello" - method comes from proto, not obj itself
    console.log(obj4.hasOwnProperty("greet")); //false - it's on the prototype
	
	//Computed property names
	const key = "dynamicKey";
	const obj5 = {
		[key]: "value"
	};
	
	//Property shorthand
	const name = "Alice";
	const age = 25;
	const obj6 = { name, age }; //Same as {name: name, age: age}
}

function propertyAccessAddDelete() {
	const person = {
		name: "John",
		age: 30,
		"full name": "John Doe",
		address: {
			city: "NYC",
			zip: "10001"
		}
	};
	
	//Dot notation
	console.log(person.name); //"John"
	console.log(person.address.city); //"NYC"
	
	//Bracket notation
	console.log(person["name"]); //"John"
	console.log(person["full name"]); //"John Doe" - required for spaces
	
	//Adding properties
	person.email = "john@example.com";
	person["phone"] = "555-1234";
	
	//Deleting properties
	delete person.phone;
	
	//Optional chaining
	console.log(person.address?.city); //If undefined - no error
}

function objectMethods() {
    //Cannot use arrow methods property access is needed. No access to "this."
	const calculator = {
		value: 0,
		
		//Method using 'this'
		add(n) {
			this.value += n;
			return this; //Method chaining
		},
		
		subtract(n) {
			this.value -= n;
			return this;
		},
		
		getValue() {
			return this.value;
		},
		
		//Getter
		get result() {
			return this.value;
		},
		
		//Setter
		set result(val) {
			this.value = val;
		}
	};
	
	calculator.add(10).subtract(3);
	console.log(calculator.getValue()); //7
	console.log(calculator.result); //7 - using getter
	calculator.result = 20; //Using setter
	console.log(calculator.result); //20
}

function objectStaticMethods() {
	const obj = { a: 1, b: 2, c: 3 };
	
	//Object.keys - returns array of keys
	console.log(Object.keys(obj)); //["a", "b", "c"]
	
	//Object.values - returns array of values
	console.log(Object.values(obj)); //[1, 2, 3]
	
	//Object.entries - returns array of [key, value] pairs
	console.log(Object.entries(obj)); //[["a", 1], ["b", 2], ["c", 3]]
	
	//Object.fromEntries - creates object from entries
	const entries = [["x", 10], ["y", 20]];
	const newObj = Object.fromEntries(entries);
	console.log(newObj); //{x: 10, y: 20}
	
	//Object.assign - copy properties to target object
	const target = { a: 1 };
	const source1 = { b: 2 };
	const source2 = { c: 3 };
	Object.assign(target, source1, source2);
	console.log(target); //{a: 1, b: 2, c: 3}
	
	//Object.assign for shallow copy
	const original = { x: 1, y: 2 };
	const copy = Object.assign({}, original);
	console.log(copy); //{x: 1, y: 2}
	
	//Object.freeze - prevents modification
	const frozen = Object.freeze({ a: 1, b: 2 });
	frozen.a = 10; //Silently fails in non-strict mode
	delete frozen.b; //Silently fails
	
	//Object.seal - prevents adding/removing properties
	const sealed = Object.seal({ a: 1, b: 2 });
	sealed.a = 10; //Allowed - can modify existing
	sealed.c = 3; //Silently fails - can't add
	delete sealed.b; //Silently fails - can't delete
	
	//Object.isFrozen, Object.isSealed
	console.log(Object.isFrozen(frozen)); //true
	console.log(Object.isSealed(sealed)); //true
	
	//Object.getPrototypeOf - get prototype
	const proto = Object.getPrototypeOf(obj);
	console.log(proto === Object.prototype); //true
	
	//Object.setPrototypeOf - set prototype (avoid, use Object.create)
	const newProto = { greet() { console.log("Hi"); } };
	Object.setPrototypeOf(obj, newProto);
	
	//Object.hasOwn - check if object has own property
	console.log(Object.hasOwn(obj, "a")); //true
	//hasOwnProperty (older method)
	console.log(obj.hasOwnProperty("a")); //true
}

function propertyDescriptors() {
	const obj = { name: "John" };
	
	//Object.getOwnPropertyDescriptor - get descriptor for property
	const descriptor = Object.getOwnPropertyDescriptor(obj, "name");
	console.log(descriptor);
	//{value: "John", writable: true, enumerable: true, configurable: true}
	
	//Object.defineProperties - define multiple properties
	Object.defineProperties(obj, {
		city: {
			value: "NYC",
			writable: true,
			enumerable: true,
			configurable: true
		},
		country: {
			value: "USA",
			writable: false, //Cannot be changed
			enumerable: false, //Won't show in for...in, Object.keys
			configurable: true//Cannot be deleted or reconfigured
		}
	});
	
	console.log(Object.keys(obj)); //["name", "age", "city"] - no "country"
	
	//Getters and setters in descriptors
	let internalValue = 0;
	Object.defineProperty(obj, "computed", {
		get() {
			return internalValue * 2;
		},
		set(value) {
			internalValue = value;
		},
		enumerable: true,
		configurable: true
	});
}

function objectIteration() {
	const person = { name: "John", age: 30, city: "NYC" };
	
	//for...in - iterates over enumerable properties
	for (let key in person) {
		console.log(key, person[key]); //name John, age 30, city NYC
	}
	
	//Object.keys with forEach
	Object.keys(person).forEach(key => {
		console.log(key, person[key]);
	});
    
    //Object.values
	for (let value of Object.values(person)) {
		console.log(value); //John, 30, NYC
	}
	
	//Object.entries with for...of
	for (let [key, value] of Object.entries(person)) {
		console.log(key, value);
	}
}