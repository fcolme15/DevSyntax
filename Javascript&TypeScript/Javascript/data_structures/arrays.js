function mainSummary() {
	arrayBasics();
	arrayIteration();
	arrayTransformation();
	arraySearching();
	arraySorting();
	arrayUtilities();
}

function arrayBasics() {
	//Array literal
	const arr1 = [1, 2, 3];
	const arr2 = ["a", "b", "c"];
	const mixed = [1, "two", true, null, { x: 5 }];
	
	//Array constructor
	const arr3 = new Array(3); //Creates array with length 3, empty slots
	const arr4 = new Array(1, 2, 3); //Creates [1, 2, 3]
	
	//Array.of - creates array from arguments
	const arr5 = Array.of(3); //[3] - not length 3
	const arr6 = Array.of(1, 2, 3); //[1, 2, 3]
	
	//Array.from - creates array from iterable or array-like
	const str = "hello";
	const chars = Array.from(str); //["h", "e", "l", "l", "o"]
	const doubled = Array.from([1, 2, 3], x => x * 2); //[2, 4, 6]
	const range = Array.from({ length: 5 }, (_, i) => i); //[0, 1, 2, 3, 4]
	
	//Spread operator
	const arr7 = [...arr1]; //Copy array
	const combined = [...arr1, ...arr2]; //Combine arrays
	
	//Empty array
	const empty = [];
    
    //at - access element at index (supports negative)
	console.log(arr6.at(1)); 
	console.log(arr6.at(-1)); 
    
    //length property
	console.log(arr6.length); 
	arr6.length = 2; //Truncate array
    
    let array = [1, 2, 3];
	
	//push - add to end, returns new length
	array.push(4);
	array.push(5, 6); //Can add multiple
	
	//pop - remove from end, returns removed element
	const last = array.pop();
	
	//unshift - add to beginning, returns new length
	array.unshift(0);
	
	//shift - remove from beginning, returns removed element
	const first = array.shift();
	
	//splice - add/remove at any position, returns removed elements
	array.splice(2, 0, 2.5); //At index 2, delete 0, insert 2.5
	
	array.splice(2, 1); //At index 2, delete 1 element
	
	array.splice(2, 2, "a", "b", "c"); //Delete 2, insert 3
	
	//concat - merge arrays, returns new array (doesn't mutate)
	const array2 = [6, 7];
	const merged = array.concat(array2);
}

function addingRemovingElements() {
	
}

function arrayIteration() {
	const arr = [1, 2, 3, 4, 5];
	
	//forEach - execute function for each element
	arr.forEach((value, index, array) => {
		console.log(value, index); //1 0, 2 1, 3 2, etc.
	});
	
	//for...of - iterate over values
	for (let value of arr) {
		console.log(value); //1, 2, 3, 4, 5
	}
	
	//for...in - iterate over indices (avoid for arrays)
	for (let index in arr) {
		console.log(index); //"0", "1", "2", "3", "4" - strings, not numbers
	}
	
	//Traditional for loop
	for (let i = 0; i < arr.length; i++) {
		console.log(arr[i]); //1, 2, 3, 4, 5
	}
	
	//entries - iterate over [index, value] pairs
	for (let [index, value] of arr.entries()) {
		console.log(index, value); //0 1, 1 2, 2 3, etc.
	}
	
	//keys - iterate over indices
	for (let index of arr.keys()) {
		console.log(index); //0, 1, 2, 3, 4
	}
	
	//values - iterate over values
	for (let value of arr.values()) {
		console.log(value); //1, 2, 3, 4, 5
	}
}

function arrayTransformation() {
	const arr = [1, 2, 3, 4, 5];
	
	//map - transform each element, returns new array
	const doubled = arr.map(x => x * 2);
	const objects = arr.map((value, index) => ({ value, index }));
	
	//filter - keep elements that pass test, returns new array
	const evens = arr.filter(x => x % 2 === 0);
	
	//reduce - reduce to single value
	const sum = arr.reduce((acc, curr) => acc + curr, 0);
	
	//reduceRight - reduce from right to left
	const reversed = arr.reduceRight((acc, curr) => [...acc, curr], []);
	
	//flat - flatten nested arrays
	const nested = [1, [2, 3], [4, [5, 6]]];
	console.log(nested.flat()); //[1, 2, 3, 4, [5, 6]] - depth 1
	console.log(nested.flat(2)); //[1, 2, 3, 4, 5, 6] - depth 2
	console.log(nested.flat(Infinity)); //Flatten all levels
	
	//flatMap - map then flat (depth 1)
	const words = ["hello world", "foo bar"];
	const allWords = words.flatMap(str => str.split(" "));
	console.log(allWords); //["hello", "world", "foo", "bar"]
}

function arraySearching() {
	const arr = [10, 20, 30, 40, 50, 30];
	
	//indexOf - first index of element, -1 if not found
	console.log(arr.indexOf(30)); //2
	console.log(arr.indexOf(30, 3)); //5 - search from index 3
	
	//lastIndexOf - last index of element if exists
	console.log(arr.lastIndexOf(30)); //5
	
	//includes - checks if element exists
	console.log(arr.includes(30)); //true
	console.log(arr.includes(30, 3)); //true - search from index 3
	
	//find - returns first element that passes test
	const found = arr.find(x => x > 25);
	
	//findIndex - returns index of first element that passes test
	const foundIndex = arr.findIndex(x => x > 25);
	
	//findLast - returns last element that passes test
	const foundLast = arr.findLast(x => x > 25);
	
	//findLastIndex - returns index of last element that passes test
	const foundLastIndex = arr.findLastIndex(x => x > 25);
	
	//some - checks if ANY element passes test
	console.log(arr.some(x => x > 40)); //true
	
	//every - checks if ALL elements pass test
	console.log(arr.every(x => x > 0)); //true
}

function arraySorting() {
	//sort - sorts in place, mutates array
	const arr1 = [3, 1, 4, 1, 5, 9];
	arr1.sort();
	
	//Default sort converts to strings - watch out
	const arr2 = [10, 5, 40, 25, 1000];
	arr2.sort();
	console.log(arr2); //[10, 1000, 25, 40, 5] - lexicographic
	
	//Numeric sort - provide compare function
	arr2.sort((a, b) => a - b); //Ascending
	arr2.sort((a, b) => b - a); //Descending
	
	//Sorting objects by age ascending
	const people = [
		{ name: "John", age: 30 },
		{ name: "Jane", age: 25 },
		{ name: "Bob", age: 35 }
	];
	people.sort((a, b) => a.age - b.age);
	
	//reverse - reverses array in place
	const arr3 = [1, 2, 3, 4, 5];
	arr3.reverse();
	
	//toSorted - returns sorted copy without mutation
	const arr4 = [3, 1, 4];
	const sorted = arr4.toSorted();
	
	//toReversed - returns reversed copy without mutation
	const reversed = arr4.toReversed();
}

function arrayUtilities() {
	const arr = [1, 2, 3, 4, 5];
	
	//slice - extract portion, returns new array. Non-mutating.
	const arr2 = [1, 2, 3, 4, 5];
	console.log(arr2.slice(1, 3)); //[2, 3] - from index 1 to 3 (exclusive)
	console.log(arr2.slice(2)); //[3, 4, 5] - from index 2 to end
	console.log(arr2.slice(-2)); //[4, 5] - last 2 elements
	console.log(arr2); //[1, 2, 3, 4, 5] - unchanged
	
	//join - create string from array. Non-mutating.
	console.log(arr2.join()); //"1,2,3,4,5"
	console.log(arr2.join("-")); //"1-2-3-4-5"
	
	//toString - convert to string. Non-mutating.
	console.log(arr2.toString()); //"1,2,3,4,5"
	
	//Array.isArray - check if value is array
	console.log(Array.isArray(arr2)); //true
	console.log(Array.isArray("hello")); //false
	console.log(Array.isArray({ length: 5 })); //false
	
	//fill - fill array with static value. Mutating.
	const arr3 = [1, 2, 3, 4, 5];
	arr3.fill(0);
	arr4.fill(9, 2, 4); //Fill with 9 from index 2 to 4 (exclusive)
}