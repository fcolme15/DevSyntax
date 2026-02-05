function mainSummary() {
	closureBasics();
	makingPrivateVariable();
	closureInLoops();
	iife();
}

function closureBasics() {
	//Closure - inner function remembers outer variables
	function makeCounter() {
		let count = 0; //Remembers the value of this variable everytime its called
		
		return function() {
			count++;
			return count;
		};
	}
	
	const counter1 = makeCounter();
	console.log(counter1()); //1
	console.log(counter1()); //2
	
	const counter2 = makeCounter();
	console.log(counter2()); //1 - separate closure, separate count
	
	//Closure with parameters
	function makeMultiplier(factor) { //Remembers the value of the parameter
		return function(number) {
			return number * factor;
		};
	}
	
	const double = makeMultiplier(2);
	const triple = makeMultiplier(3);
	console.log(double(5)); //10
	console.log(triple(5)); //15
}

function makingPrivateVariable() {
	//Multiple methods sharing private variable
	function createBankAccount(initialBalance) {
		let balance = initialBalance; //Private
		
		return {
			deposit(amount) {
				balance += amount;
				return balance;
			},
			withdraw(amount) {
				if (amount > balance) return balance;
				balance -= amount;
				return balance;
			},
			getBalance() {
				return balance;
			}
		};
	}
	
	const account = createBankAccount(1000);
	account.deposit(500);
	account.withdraw(200);
	console.log(account.getBalance()); //1300
	//console.log(account.balance); //undefined - can't access directly
}

function closureInLoops() { //Var is same obj reference in loops
    
	//var is function scoped so all versions get the reference to the same i
	var functions = [];
	for (var i = 0; i < 3; i++) {
		functions.push(function() {
			console.log(i);
		});
	}
	functions[0](); //3 - not 0
	functions[1](); //3 - not 1
	functions[2](); //3 - not 2
	
	//let creates a new var each time(block-scoped)
	const functionsLet = [];
	for (let j = 0; j < 3; j++) {
		functionsLet.push(function() {
			console.log(j);
		});
	}
	functionsLet[0](); //0
	functionsLet[1](); //1
	functionsLet[2](); //2
}


function iife() {
    //Its a solution fo the global variable polution due to the usage of var
    //Not an issue if let and const are used instead

	//IIFE - function executes immediately, creates private scope
	(function() {
		const privateVar = "Can't access outside";
		console.log("IIFE executed");
	})();
	//console.log(privateVar); //Error - not accessible
	
	//IIFE with parameters
	(function(name) {
		console.log(`Hello ${name}`);
	})("John");
	
	//IIFE with return value
	const result = (function() {
		return 10 + 20;
	})();
	console.log(result); //30
	
	//Alternative syntax
	(function() { console.log("Works"); }());
	!function() { console.log("Also works"); }();
}