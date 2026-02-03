function mainSummary() {
	arrayDestructuring();
	objectDestructuring();
}

//Can be used in function parameters to descructure right away

//============================================================
//ARRAY DESTRUCTURING
//============================================================

function arrayDestructuring() {
	//Basic array destructuring
	const arr = [1, 2, 3];
	const [a, b, c] = arr;
	
	//Skipping elements
	const [first, , third] = [10, 20, 30];
	console.log(first, third); //10, 30
	
	//Default values
	const [x = 0, y = 0] = [5];
	console.log(x, y); //5, 0
	
	//Rest pattern - collects remaining elements
	const [head, ...tail] = [1, 2, 3, 4, 5];
	console.log(head); //1
	console.log(tail); //[2, 3, 4, 5]
	
	//Swapping variables
	let num1 = 10;
	let num2 = 20;
	[num1, num2] = [num2, num1]; 
	
	//Ignoring return values
	function getCoords() {
		return [10, 20, 30];
	}
	const [, , z] = getCoords();
	console.log(z); //30
	
	//Destructuring from strings
	const [char1, char2] = "Hello";
	console.log(char1, char2); //H, e
}

//============================================================
//OBJECT DESTRUCTURING
//============================================================

function objectDestructuring() {
	//Basic object destructuring
	const person = { name: "John", age: 30, city: "NYC" };
	const { name, age, city } = person;
	
	//Renaming variables
	const { name: personName, age: personAge } = person;
	console.log(personName, personAge); //"John", 30
	
	//Default values
	const { country = "USA", state = "NY" } = person;
	console.log(country, state); //"USA", "NY"
	
	//Renaming with defaults
	const { phone: phoneNumber = "N/A" } = person;
	console.log(phoneNumber); //"N/A"
	
	//Rest pattern - collects remaining properties
	const { name: n, ...rest } = person;
	console.log(n); //"John"
	console.log(rest); //{age: 30, city: "NYC"}
	
	//Destructuring without declaration
	let a, b;
	({ a, b } = { a: 1, b: 2 }); //Parentheses required
	console.log(a, b); //1, 2
	
	//Extracting specific properties
	const { age: userAge } = { name: "Jane", age: 25, email: "jane@example.com" };
	console.log(userAge); //25


	//============================================================
	//NESTED DESTRUCTURING
	//============================================================
	//Nested object destructuring
	const user = {
		id: 1,
		name2: "John",
		address: {
			street: "123 Main St",
			city1: "NYC",
			coords: {
				lat: 40.7128,
				lng: -74.0060
			}
		}
	};
	
	const { name2, address: { city1, coords: { lat, lng } } } = user;

	//Nested array destructuring
	const matrix = [[1, 2], [3, 4], [5, 6]];
	const [[a1, b1], [c, d]] = matrix;
	console.log(a1, b1, c, d); //1, 2, 3, 4
	
	//Mixed nested destructuring
	const data = {
		users: [
			{ name: "Alice", age: 25 },
			{ name: "Bob", age: 30 }
		]
	};
	const { users: [firstUser, { name: secondName }] } = data;
	console.log(firstUser); //{name: "Alice", age: 25}
	console.log(secondName); //"Bob"
}