function mainSummary() {
	functionDeclarations();
	functionExpressions();
	arrowFunctions();
	parameters();
	returnValues();
	closure();
}

//============================================================
//COMPARISON: function declaration vs expression vs arrow
//============================================================
//Declaration: Hoisted, has 'this', can be named, readable syntax
//Expression: Not hoisted, has 'this', can be anonymous or named
//Arrow: Not hoisted, no 'this' binding, concise syntax, implicit return
//Hoisted so can be called before declaration

function functionDeclarations() { 
	
	//Function with parameters
	function add(a, b) {
		return a + b;
	}
	console.log(add(2, 3)); //5
	
	//Function declarations are hoisted
	sayHi(); //"Hi" - works even before declaration
	function sayHi() {
		console.log("Hi");
	}
}

//Not hoisted so cannot be called before instantiated
function functionExpressions() {
	//Anonymous function expression -> Not named so cannot call itself
	const greet = function() {
		console.log("Hello");
	};
	greet(); //"Hello"
	
	//Named function expression -> Can call itself 
	const factorial = function fact(n) {
		return n <= 1 ? 1 : n * fact(n - 1);
	};
	console.log(factorial(5)); //120
	//console.log(fact(5)); //Error - fact only accessible inside function
	
	//Function expressions are NOT hoisted
	//sayHi(); //Error - cannot access before initialization
	const sayHi = function() {
		console.log("Hi");
	};
	

	//Immediately Invoked Function Expression (IIFE) -> Runs immediately
	
	//IIFE with parameters
	(function(name) {
		console.log(`Hello ${name}`);
	})("John");
	
	//IIFE with return value
	const result = (function() {
		return 42;
	})();
	console.log(result); //42
}

//============================================================
//ARROW FUNCTIONS
//============================================================

function arrowFunctions() {
	//Basic arrow function
    //No parameters - empty parentheses required
	const greet = () => {
		console.log("Hello");
	};
	greet();
	
	//Single parameter - parentheses optional
	const square = x => x * x;
	console.log(square(5)); //25
	
	//Multiple parameters - parentheses required
	const add = (a, b) => a + b;
	console.log(add(2, 3)); //5
	
	//Implicit return - no braces needed for single expression
	const multiply = (a, b) => a * b;
	console.log(multiply(2, 3)); //6
	
	//Explicit return - braces required
	const divide = (a, b) => {
		return a / b;
	};
	console.log(divide(6, 2)); //3
	
	//Returning object literal - wrap in parentheses
	const makeObject = (name, age) => ({ name: name, age: age });
	console.log(makeObject("John", 30)); //{name: "John", age: 30}
	
	//Arrow functions do NOT have their own 'this'
	const obj = {
		value: 42,
		regular: function() {
			console.log(this.value); //42 - 'this' refers to obj
		},
		arrow: () => {
			console.log(this.value); //undefined - 'this' from outer scope
		}
	};
	obj.regular();
	obj.arrow();
}

function parameters() {
	//Default parameters
	function greet(name = "Guest") {
		console.log(`Hello ${name}`);
	}
	greet(); //"Hello Guest"
	greet("John"); //"Hello John"
	
	//Rest parameters - collects remaining arguments into array
	//Rest must be last parameter
	function logAll(first, ...rest) {
		console.log(first); //1
		console.log(rest); //[2, 3, 4]
	}
	logAll(1, 2, 3, 4);
	
	//Destructuring parameters - arrays
	function sum([a, b]) {
		return a + b;
	}
	console.log(sum([2, 3])); //5
}

//============================================================
//RETURN VALUES
//============================================================

function returnValues() {
	//Explicit return
	function add(a, b) {
		return a + b;
	}
	console.log(add(2, 3)); //5
	
	//No return or empty return - returns undefined
	function emptyReturn() {
		return;
	}
	console.log(emptyReturn()); //undefined
	
	//Returning functions
	function multiplier(factor) {
		return function(x) {
			return x * factor;
		};
	}
	const double = multiplier(2);
	console.log(double(5)); //10
}

function closure() {
	//Closures - function retains access to outer scope
	function counter() {
		let count = 0;
		return function() {
			count++;
			return count;
		};
	}
	const increment = counter();
	console.log(increment()); //1
	console.log(increment()); //2

    //After counter() finishes, normally count would be destroyed. 
    //But because the returned function still references count, 
    //JavaScript keeps count alive in memory. 
    //Each call to increment() accesses the same count variable - that's the closure.
}

