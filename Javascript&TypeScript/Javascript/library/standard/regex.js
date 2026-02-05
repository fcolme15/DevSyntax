function mainSummary() {
	regexCreation();
	regexMethods();
	regexPatterns();
	regexFlags();
}

function regexCreation() {
	//Literal notation
	const regex1 = /hello/;
	const regex2 = /\d+/;
	
	//Constructor
	const regex3 = new RegExp("hello");
	const regex4 = new RegExp("\\d+"); //Need to escape backslash
	
	//With flags
	const regex5 = /hello/gi; //Global, case-insensitive
	const regex6 = new RegExp("hello", "gi");
	
	//Dynamic pattern (use constructor)
	const word = "test";
	const regex7 = new RegExp(word); //Matches "test"
}

function regexMethods() {
	const text = "The quick brown fox jumps over the lazy dog";
	
	//test() - returns true/false
	const hasQuick = /quick/.test(text);
	console.log(hasQuick); //true
	
	//exec() - returns match details or null
	const match = /quick/.exec(text);
	console.log(match); //["quick", index: 4, input: "The quick...", groups: undefined]
	console.log(match[0]); //"quick"
	console.log(match.index); //4
	
	//String methods with regex
	//match() - returns matches or null
	const matches = text.match(/\w+/g); //All words
	console.log(matches); //["The", "quick", "brown", ...]
	
	const singleMatch = text.match(/quick/);
	console.log(singleMatch[0]); //"quick"
	
	//matchAll() - returns iterator of all matches
	const regex = /\b\w{5}\b/g; //5-letter words
	const allMatches = [...text.matchAll(regex)];
	console.log(allMatches); //Array of match objects
	
	//search() - returns index of first match or -1
	const index = text.search(/fox/);
	console.log(index); //16
	
	//replace() - replaces matches
	const replaced = text.replace(/dog/, "cat");
	console.log(replaced); //"The quick brown fox jumps over the lazy cat"
	
	const allReplaced = text.replace(/o/g, "0"); //Global flag
	console.log(allReplaced); //"The quick br0wn f0x jumps 0ver the lazy d0g"
	
	//replace with function
	const uppercased = text.replace(/\b\w/g, match => match.toUpperCase());
	console.log(uppercased); //"The Quick Brown Fox..."
	
	//split() - split string by regex
	const words = text.split(/\s+/); //Split by whitespace
	console.log(words); //["The", "quick", "brown", ...]
}

function regexPatterns() {
	//Character classes
	console.log(/\d/.test("5")); //true - digit [0-9]
	console.log(/\D/.test("a")); //true - non-digit
	console.log(/\w/.test("a")); //true - word char [a-zA-Z0-9_]
	console.log(/\W/.test("!")); //true - non-word char
	console.log(/\s/.test(" ")); //true - whitespace
	console.log(/\S/.test("a")); //true - non-whitespace
	console.log(/./.test("x")); //true - any char except newline
	
	//Character sets
	console.log(/[aeiou]/.test("hello")); //true - any vowel
	console.log(/[^aeiou]/.test("hello")); //true - not a vowel
	console.log(/[0-9]/.test("5")); //true - digit range
	console.log(/[a-z]/.test("a")); //true - lowercase letter
	console.log(/[A-Z]/.test("A")); //true - uppercase letter
	
	//Quantifiers
	console.log(/\d+/.test("123")); //true - one or more digits
	console.log(/\d*/.test("abc")); //true - zero or more digits
	console.log(/\d?/.test("1")); //true - zero or one digit
	console.log(/\d{3}/.test("123")); //true - exactly 3 digits
	console.log(/\d{2,4}/.test("123")); //true - 2 to 4 digits
	console.log(/\d{2,}/.test("12345")); //true - 2 or more digits
	
	//Anchors
	console.log(/^hello/.test("hello world")); //true - starts with
	console.log(/world$/.test("hello world")); //true - ends with
	console.log(/^\d+$/.test("123")); //true - entire string is digits
	console.log(/\bcat\b/.test("cat")); //true - word boundary
	
	//Groups and alternation
	console.log(/(cat|dog)/.test("I have a cat")); //true - cat OR dog
	console.log(/(\d{3})-(\d{4})/.test("123-4567")); //true - capturing groups
	
	//Lookahead/lookbehind
	console.log(/\d(?=px)/.test("10px")); //true - digit followed by px
	console.log(/(?<=\$)\d+/.test("$100")); //true - digit preceded by $
}

function regexFlags() {
	const text = "Hello World hello world";
	
	//g - global (find all matches)
	console.log(text.match(/hello/)); //["hello"] - first match only
	console.log(text.match(/hello/g)); //["hello", "hello"] - all matches
	
	//i - case-insensitive
	console.log(/hello/.test("HELLO")); //false
	console.log(/hello/i.test("HELLO")); //true
	
	//m - multiline (^ and $ match line breaks)
	const multiline = "line1\nline2";
	console.log(/^line2/.test(multiline)); //false
	console.log(/^line2/m.test(multiline)); //true
	
	//s - dotAll (. matches newlines)
	console.log(/.+/.test("a\nb")); //true - stops at newline
	console.log(/.+/s.test("a\nb")); //true - includes newline
	
	//u - unicode
	console.log(/\u{1F600}/u.test("😀")); //true - emoji
	
	//y - sticky (matches from lastIndex)
	const regex = /\d+/y;
	regex.lastIndex = 0;
	console.log(regex.exec("123 456")); //["123"]
	regex.lastIndex = 4;
	console.log(regex.exec("123 456")); //["456"]
	
	//Combining flags
	const combined = /hello/gi; //global + case-insensitive
	console.log(text.match(combined)); //["Hello", "hello"]
}