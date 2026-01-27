function mainSummary() {
	stringCreation();
	templateLiterals();
	stringMethods();
	stringManipulation();
	stringSearching();
}

function stringCreation() {
	//String literals
	let single = 'Hello';
	let double = "World";
	let backtick = `Template`;
	
	//String constructor (rarely used)
	let strObj = new String("Hello"); //Creates String object, not primitive
	let strPrimitive = String(123); //"123" - converts to primitive string
	
	//Escape sequences
	let quote = "He said \"Hello\"";
	let apostrophe = 'It\'s working';
	let backslash = "Path: C:\\folder\\file";
	let newline = "Line 1\nLine 2";
	let tab = "Column1\tColumn2";
	let unicode = "\u0041"; //"A"
	let emoji = "\u{1F600}"; //"😀"
}

function templateLiterals() {
	//Expression interpolation with ${}
	let name = "John";
	let age = 30;
	let greeting = `Hello ${name}, you are ${age} years old`;
	
	//Expressions inside ${}
	let sum = `2 + 2 = ${2 + 2}`; //"2 + 2 = 4"
	let conditional = `Status: ${age >= 18 ? "Adult" : "Minor"}`;
	
	//Multiline strings
	let multiline = `Line 1
    Line 2
    Line 3`;
	
	//Nested template literals
	let outer = `Outer ${`Inner ${5}`}`; //"Outer Inner 5"
	
	//Tagged templates (advanced)
	function tag(strings, ...values) {
		return strings[0] + values[0].toUpperCase();
	}
	let tagged = tag`Hello ${"world"}`; //"Hello WORLD"
}

//============================================================
//STRING PROPERTIES AND BASIC METHODS
//============================================================

function stringMethods() {
	let str = "Hello World";
	
	//Length property
	console.log(str.length); //11
	
	//Character access
	console.log(str[0]); //"H"
	console.log(str.charAt(0)); //"H"
	console.log(str.charAt(100)); //"" - empty string for out of bounds
	console.log(str.charCodeAt(0)); //72 - Unicode value of 'H'
	console.log(str.codePointAt(0)); //72 - handles emoji/extended Unicode
	
	//Case conversion
	console.log(str.toLowerCase()); //"hello world"
	console.log(str.toUpperCase()); //"HELLO WORLD"
	
	//Trimming whitespace
	let padded = "  trim me  ";
	console.log(padded.trim()); //"trim me"
	console.log(padded.trimStart()); //"trim me  "
	console.log(padded.trimEnd()); //"  trim me"
	
	//Repeating
	console.log("ha".repeat(3)); //"hahaha"
	
	//Padding
	console.log("5".padStart(3, "0")); //"005"
	console.log("5".padEnd(3, "0")); //"500"
}

function stringManipulation() {
	let str = "Hello World";
	
	//Substring extraction
	console.log(str.substring(0, 5)); //"Hello" - (start, end)
	console.log(str.substring(6)); //"World" - from index to end
	console.log(str.substr(0, 5)); //"Hello" - (start, length) - deprecated
	console.log(str.slice(0, 5)); //"Hello" - like substring but handles negatives
	console.log(str.slice(-5)); //"World" - negative counts from end
	console.log(str.slice(-5, -1)); //"Worl"
	
	//Splitting
	console.log(str.split(" ")); //["Hello", "World"]
	console.log(str.split("")); //["H", "e", "l", "l", "o", " ", "W", "o", "r", "l", "d"]
	console.log("a,b,c".split(",")); //["a", "b", "c"]
	console.log("a,b,c".split(",", 2)); //["a", "b"] - limit to 2 elements
	
	//Concatenation
	console.log(str.concat(" ", "Everyone")); //"Hello World Everyone"
	console.log("a".concat("b", "c")); //"abc"
	
	//Replacing
	console.log(str.replace("World", "JavaScript")); //"Hello JavaScript"
	console.log("aaa".replace("a", "b")); //"baa" - only first occurrence
	console.log("aaa".replaceAll("a", "b")); //"bbb" - all occurrences
	console.log(str.replace(/o/g, "0")); //"Hell0 W0rld" - regex for global replace
}

function stringSearching() {
	let str = "Hello World";
	
	//Index searching
	console.log(str.indexOf("o")); //4 - first occurrence
	console.log(str.indexOf("o", 5)); //7 - search starting from index 5
	console.log(str.indexOf("x")); //-1 - not found
	console.log(str.lastIndexOf("o")); //7 - last occurrence
	
	//Inclusion checking
	console.log(str.includes("World")); //true
	console.log(str.includes("world")); //false - case sensitive
	console.log(str.startsWith("Hello")); //true
	console.log(str.startsWith("World", 6)); //true - check from index 6
	console.log(str.endsWith("World")); //true
	console.log(str.endsWith("Hello", 5)); //true - check first 5 chars
	
	//Pattern matching with regex
	console.log(str.match(/o/g)); //["o", "o"] - all matches
	console.log(str.search(/World/)); //6 - index of first match
	console.log(/World/.test(str)); //true - regex test method
}