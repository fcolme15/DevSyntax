function mainSummary() {
	varExample();
	letExample();
	constExample();
	hoistingExample();
	numberExample();
	stringExample();
	booleanExample();
	undefinedExample();
	nullExample();
	symbolExample();
}

//============================================================
//VARIABLE DECLARATIONS
//============================================================

//var - function-scoped, hoisted and initialized to undefined, can be redeclared
function varExample() {
	var x = 10;
	var x = 20; //Redeclaration ignored(no error), only assignment happens
	console.log(x); //20
	
	if (true) {
		var y = 30; //Function-scoped, not block-scoped
	}
	console.log(y); //Accessible outside block
}

//let - block-scoped, hoisted but in temporal dead zone, cannot be redeclared
function letExample() {
	let x = 10;
	//let x = 20; //Error: cannot redeclare
	x = 20; //Reassignment
	console.log(x); //20
	
	if (true) {
		let y = 30; //block-scoped
		console.log(y); //30
	}

	//console.log(y); //Error: y is not defined
}

//const - block-scoped, hoisted but in temporal dead zone, cannot be reassigned
function constExample() {
	const x = 10;
	//x = 20; //Error: assignment to constant variable
	//const x = 30; //Error: cannot redeclare
	
	//const with objects - reference is constant, not contents
	const obj = { name: "John" };
	obj.name = "Jane"; //allowed - mutating contents
	//obj = {}; //Error: cannot reassign reference
}

//Hoisting and temporal dead zone
function hoistingExample() {
	//var is hoisted and initialized to undefined
	console.log(x); //undefined
	var x = 10;
	
	//let/const are hoisted but in temporal dead zone until declaration
	//console.log(y); //Error: cannot access before initialization
	let y = 20;
	
	//console.log(z); //Error: cannot access before initialization
	const z = 30;
}





//============================================================
//PRIMITIVE TYPES
//============================================================

function numberExample() {
	//Number literals
	let int = 42;
	let float = 3.14;
	let negative = -10;
	let scientific = 2e3; //2000
	let hex = 0xFF; //255
	let binary = 0b1010; //10
	let octal = 0o744; //484
	
	//Special numeric values
	let infinity = Infinity;
	let negInfinity = -Infinity;
	let notANumber = NaN;
	
	//Number checking
	console.log(Number.isNaN(NaN)); //true
	console.log(Number.isFinite(42)); //true
	console.log(Number.isInteger(42)); //true
	console.log(Number.isInteger(3.14)); //false
	
	//BigInt - for integers beyond Number.MAX_SAFE_INTEGER (2^53 - 1)
	let big1 = 9007199254740991n; //n suffix
	let big2 = BigInt(9007199254740991);
	let big3 = BigInt("9007199254740991");
	
	//BigInt operations
	let sum = 100n + 50n;
	let product = 10n * 5n;
	//let mixed = 10n + 5; //Error: cannot mix BigInt and number
	//console.log(100n / 3n); //33n - truncates to integer
}

//String - immutable sequence of characters
function stringExample() {
	let single = 'Hello';
	let double = "World";
	let template = `Hello ${single}`; //template literal with interpolation
	
	//Escape sequences
	let escaped = "He said \"Hello\"";
	let newline = "Line 1\nLine 2";
}

//Boolean - true or false
function booleanExample() {
	let isTrue = true;
	let isFalse = false;
}

//Undefined - variable declared but not assigned
function undefinedExample() {
	let x; //declared but not initialized
	console.log(x); //undefined
	
	//Function with no return
	function noReturn() {}
	console.log(noReturn()); //undefined
	
	//Object property that doesn't exist
	let obj = {};
	console.log(obj.nonExistent); //undefined
}

//Null - intentional absence of value
function nullExample() {
	let x = null; //explicitly set to null
	console.log(x); //null
	console.log(typeof x); //"object" - historical bug in JavaScript
	
	//Checking for null
	console.log(x === null); //true
	console.log(x == undefined); //true - loose equality
	console.log(x === undefined); //false - strict equality
}

//Symbol - unique and immutable primitive
function symbolExample() {
	//Creating symbols
	let sym1 = Symbol();
	let sym2 = Symbol("description");
	let sym3 = Symbol("description");
	
	//Each symbol is unique
	console.log(sym2 === sym3); //false - even with same description
	
	//Using symbols as object keys
	let obj = {};
	let idSymbol = Symbol("id");
	obj[idSymbol] = 123;
	console.log(obj[idSymbol]); //123
	
	//Symbols are hidden from for...in and Object.keys()
	for (let key in obj) {
		console.log(key); //nothing logged
	}
	console.log(Object.keys(obj)); //[]
	console.log(Object.getOwnPropertySymbols(obj)); //[Symbol(id)]
	
	//Global symbol registry
	let globalSym1 = Symbol.for("app.id");
	let globalSym2 = Symbol.for("app.id");
	console.log(globalSym1 === globalSym2); //true - same global symbol
	console.log(Symbol.keyFor(globalSym1)); //"app.id"
}

//============================================================
//COMPARISON: var vs let vs const
//============================================================
//var: function-scoped, hoisted and initialized to undefined, redeclarable - avoid
//let: block-scoped, temporal dead zone, reassignable - use when reassignment needed
//const: block-scoped, temporal dead zone, not reassignable - use by default

//============================================================
//COMPARISON: undefined vs null
//============================================================
//undefined: variable exists but has no value (system-generated)
//null: intentional absence of value (developer-assigned)
//Use null to explicitly indicate "no value"