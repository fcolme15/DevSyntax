//Run all examples
function mainSummary() {
	arithmeticOperators();
	assignmentOperators();
	comparisonOperators();
	logicalOperators();
	bitwiseOperators();
	ternaryOperator();
	nullishCoalescing();
	optionalChaining();
	otherOperators();
}

function arithmeticOperators() {
	//Basic arithmetic
	let sum = 5 + 3; //8
	let difference = 5 - 3; //2
	let product = 5 * 3; //15
	let quotient = 15 / 3; //5
	let remainder = 10 % 3; //1
	let exponent = 2 ** 3; //8 (2^3)
	
	//Increment and decrement
	let x = 5;
	x++; //Post-increment: use value then add 1
	console.log(x); //6
	
	let y = 5;
	++y; //Pre-increment: add 1 then use value
	console.log(y); //6
	
	//Unary plus and minus
	let num = "42";
	console.log(+num); //42 - converts to number
	console.log(-num); //-42 - converts to number and negates
}

function assignmentOperators() {
	//Basic assignment
	let x = 10;
	
	//Compound assignment
	x += 5; //x = x + 5
	x -= 3; //x = x - 3
	x *= 2; //x = x * 2
	x /= 4; //x = x / 4
	x %= 3; //x = x % 3
	x **= 2; //x = x ** 2
	
	//Logical assignment (ES2021)
	let a = null;
	a ||= 10; //a = a || 10 (assigns if falsy)
	console.log(a); //10
	
	let b = 5;
	b &&= 10; //b = b && 10 (assigns if truthy)
	console.log(b); //10
	
	let c = null;
	c ??= 10; //c = c ?? 10 (assigns if null/undefined)
	console.log(c); //10
}

//== (loose equality): performs type coercion, compares values
//=== (strict equality): no type coercion, compares type and value
function comparisonOperators() {
	//Equality
	console.log(5 == "5"); //true - loose equality, type coercion
	console.log(5 === "5"); //false - strict equality, no coercion
	console.log(5 != "5"); //false - loose inequality
	console.log(5 !== "5"); //true - strict inequality
	
	//Relational
	console.log(5 > 3); //true
	console.log(5 < 3); //false
	console.log(5 >= 5); //true
	console.log(5 <= 3); //false
	
	//String comparison (lexicographic)
	console.log("apple" < "banana"); //true
	console.log("Apple" < "apple"); //true - uppercase comes first
}

function logicalOperators() {
	//AND - returns first falsy or last value
	console.log(true && true); //true
	console.log(true && false); //false
	console.log(5 && 10); //10 - both truthy, returns last
	console.log(0 && 10); //0 - first falsy
	
	//OR - returns first truthy or last value
	console.log(true || false); //true
	console.log(false || false); //false
	console.log(0 || 10); //10 - first truthy
	console.log(0 || null); //null - both falsy, returns last
	
	//NOT - inverts boolean
	console.log(!true); //false
	console.log(!false); //true
	console.log(!0); //true - 0 is falsy
	console.log(!"hello"); //false - non-empty string is truthy
}

function bitwiseOperators() {
	//Bitwise AND, OR, XOR
	console.log(5 & 3); //1 (0101 & 0011 = 0001)
	console.log(5 | 3); //7 (0101 | 0011 = 0111)
	console.log(5 ^ 3); //6 (0101 ^ 0011 = 0110)
	
	//Bitwise NOT
	console.log(~5); //-6 (inverts bits)
	
	//Bit shifts
	console.log(5 << 1); //10 (shift left: multiply by 2)
	console.log(5 >> 1); //2 (shift right: divide by 2)
	console.log(-5 >> 1); //-3 (sign-propagating right shift)
	console.log(-5 >>> 1); //2147483645 (zero-fill right shift)
}

function ternaryOperator() {
	//Syntax: condition ? valueIfTrue : valueIfFalse
	let age = 20;
	let status = age >= 18 ? "adult" : "minor";
	console.log(status); //"adult"
	
	//Nested ternary (use sparingly)
	let score = 85;
	let grade = score >= 90 ? "A" : score >= 80 ? "B" : "C";
	console.log(grade); //"B"
	
	//Ternary in expressions
	let max = 10 > 5 ? 10 : 5;
	console.log(max); //10
}

function nullishCoalescing() {
	//Nullish coalescing (??) - returns right side if left is null/undefined
	let x = null;
	let result1 = x ?? "default"; //"default"
	
	let y = 0;
	let result2 = y ?? "default"; //0 - only null/undefined trigger default
	
	let z = "";
	let result3 = z ?? "default"; //"" - only null/undefined trigger default
	
	//Compare with OR operator
	let a = 0;
	let orResult = a || "default"; //"default" - 0 is falsy
	let nullishResult = a ?? "default"; //0 - only null/undefined
	
	//Chaining
	let value = null ?? undefined ?? "fallback"; //"fallback"
}

function optionalChaining() {
	//Optional chaining (?.) - safely access nested properties
	let user = {
		name: "John",
		address: {
			city: "NYC"
		}
	};
	
	//Safe property access
	console.log(user?.name); //"John"
	console.log(user?.phone); //undefined - no error
	console.log(user?.address?.city); //"NYC"
	console.log(user?.address?.zip); //undefined - no error
	
	//With null/undefined objects
	let nullUser = null;
	console.log(nullUser?.name); //undefined - no error
	
	//Optional method call
	let obj = {
		method: function() { return "called"; }
	};
	console.log(obj.method?.()); //"called"
	console.log(obj.missing?.()); //undefined - no error
	
	//Optional array access
	let arr = [1, 2, 3];
	console.log(arr?.[0]); //1
	console.log(arr?.[10]); //undefined
	
	let nullArr = null;
	console.log(nullArr?.[0]); //undefined - no error
	
	//Combining with nullish coalescing
	let result = user?.address?.zip ?? "No zip";
	console.log(result); //"No zip"
}

function otherOperators() {
	//typeof - returns type as string
	console.log(typeof 42); //"number"
	console.log(typeof "hello"); //"string"
	
	//instanceof - checks prototype chain
	console.log([] instanceof Array); //true
	console.log({} instanceof Object); //true
	
	//delete - removes object property
	let obj = { name: "John", age: 30 };
	delete obj.age;
	console.log(obj); //{name: "John"}
	
	//in - checks if property exists
	let car = { brand: "Toyota" };
	console.log("brand" in car); //true
	console.log("model" in car); //false
	
	//Comma operator - evaluates left to right, returns last
	let x = (1, 2, 3);
	console.log(x); //3
}