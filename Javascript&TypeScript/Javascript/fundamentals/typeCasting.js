//Run all examples
function main() {
	typeofOperator();
	typeCheckingMethods();
	explicitConversion();
	implicitCoercion();
	truthyFalsy();
}

//============================================================
//TYPE CHECKING
//============================================================

//typeof operator - returns string representing type
function typeofOperator() {
	console.log(typeof 42); //"number"
	console.log(typeof "hello"); //"string"
	console.log(typeof true); //"boolean"
	console.log(typeof undefined); //"undefined"
	console.log(typeof null); //"object" - historical bug
	console.log(typeof 100n); //"bigint"
	console.log(typeof Symbol()); //"symbol"
	console.log(typeof {}); //"object"
	console.log(typeof []); //"object"
	console.log(typeof function(){}); //"function"
}

//Type checking methods for specific types
function typeCheckingMethods() {
	//Array checking
	console.log(Array.isArray([])); //true
	console.log(Array.isArray({})); //false
	
	//Number checking
	console.log(Number.isNaN(NaN)); //true
	console.log(Number.isNaN("hello")); //false - not NaN type
	console.log(isNaN("hello")); //true - coerces to number first
	console.log(Number.isFinite(42)); //true
	console.log(Number.isFinite(Infinity)); //false
	console.log(Number.isInteger(42)); //true
	console.log(Number.isInteger(3.14)); //false
	
	//Instance checking
	console.log(new Date() instanceof Date); //true
	console.log([] instanceof Array); //true
	console.log({} instanceof Object); //true
}

//============================================================
//EXPLICIT TYPE CONVERSION
//============================================================

//Converting to Number
function explicitConversion() {
	//Number() - converts entire string or returns NaN
	console.log(Number("42")); //42
	console.log(Number("42px")); //NaN
	console.log(Number(true)); //1
	console.log(Number(false)); //0
	console.log(Number(null)); //0
	console.log(Number(undefined)); //NaN
	console.log(Number("")); //0
	console.log(Number(" ")); //0
	
	//parseInt() - parses until non-digit, optionally specify radix
	console.log(parseInt("42")); //42
	console.log(parseInt("42px")); //42
	console.log(parseInt("3.14")); //3
	console.log(parseInt("FF", 16)); //255
	console.log(parseInt("1010", 2)); //10
	
	//parseFloat() - parses decimal numbers
	console.log(parseFloat("3.14")); //3.14
	console.log(parseFloat("3.14px")); //3.14
	
	//Unary plus operator - same as Number()
	console.log(+"42"); //42
	console.log(+true); //1
	
	//Converting to String
	console.log(String(42)); //"42"
	console.log(String(true)); //"true"
	console.log(String(null)); //"null"
	console.log(String(undefined)); //"undefined"
	console.log((42).toString()); //"42"
	console.log((42).toString(2)); //"101010" - binary
	console.log((42).toString(16)); //"2a" - hexadecimal
	
	//Converting to Boolean
	console.log(Boolean(1)); //true
	console.log(Boolean(0)); //false
	console.log(Boolean("")); //false
	console.log(Boolean("hello")); //true
	console.log(Boolean(null)); //false
	console.log(Boolean(undefined)); //false
	
	//Double negation - same as Boolean()
	console.log(!!"hello"); //true
	console.log(!!0); //false
}

//============================================================
//IMPLICIT TYPE COERCION
//============================================================

//Automatic type conversion in operations
function implicitCoercion() {
	//String concatenation - numbers become strings
	console.log("5" + 3); //"53"
	console.log("5" + true); //"5true"
	console.log("5" + null); //"5null"
	
	//Arithmetic operations - strings become numbers
	console.log("5" - 3); //2
	console.log("10" * "2"); //20
	console.log("10" / "2"); //5
	console.log("10" % "3"); //1
	
	//Comparison coercion
	console.log("5" == 5); //true - loose equality coerces types
	console.log("5" === 5); //false - strict equality no coercion
	console.log(null == undefined); //true - special case
	console.log(null === undefined); //false
	
	//Boolean context coercion
	if ("hello") { //truthy
		console.log("Non-empty string is truthy");
	}
}

