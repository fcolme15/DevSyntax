function mainSummary() {
	forLoop();
	whileLoop();
	forAutoLoop();
	breakContinue();
	nestedLoops();
}

//============================================================
//FOR LOOP
//============================================================

function forLoop() {
	//Basic for loop
	for (let i = 0; i < 5; i++) {
		console.log(i); //0, 1, 2, 3, 4
	}
	
	//Multiple variables
	for (let i = 0, j = 10; i < 5; i++, j--) {
		console.log(i, j); //0 10, 1 9, 2 8, 3 7, 4 6
	}
	
	//Empty initialization or update
	let x = 0;
	for (; x < 3; x++) {
		console.log(x); //0, 1, 2
	}
	
	//Infinite loop (requires break)
	for (;;) {
		console.log("Infinite");
		break; //Exit immediately
	}
}

//============================================================
//WHILE LOOP
//============================================================

function whileLoop() {
	//Basic while loop
	let i = 0;
	while (i < 5) {
		console.log(i); //0, 1, 2, 3, 4
		i++;
	}
	
	//Using break in while
	let num = 0;
	while (true) {
		console.log(num);
		num++;
		if (num >= 3) break;
	}
    
    //DO-WHILE LOOP

    //Executes at least once, then checks condition    
    //Runs once even if condition is false
	i = 0;
	do {
		console.log(i); //0, 1, 2, 3, 4
		i++;
	} while (i < 5);
	
	
}

//============================================================
//FOR...IN LOOP. Keyword "in" changes what it iterates
//============================================================

function forInLoop() {
	//Iterates over enumerable properties (keys) of object
	let person = {
		name: "John",
		age: 30,
		city: "NYC"
	};
	
	for (let key in person) {
		console.log(key, person[key]); //name John, age 30, city NYC
	}
	
	//Works with arrays (iterates over indices, not recommended)
	let arr = [10, 20, 30];
	for (let index in arr) {
		console.log(index, arr[index]); //"0" 10, "1" 20, "2" 30
	}
	//Note: index is string, not number
	
	//Includes inherited enumerable properties
	let child = Object.create(person);
	child.school = "MIT";
	for (let key in child) {
		console.log(key); //school, name, age, city (includes inherited)
	}
}

//============================================================
//FOR...OF LOOP. Keyword "of" changes what it iterates
//============================================================

function forOfLoop() {
	//Iterates over iterable objects (arrays, strings, maps, sets)
	
	//With arrays - iterates over values
	let arr = [10, 20, 30];
	for (let value of arr) {
		console.log(value); //10, 20, 30
	}
	
	//With strings - iterates over characters
	let str = "hello";
	for (let char of str) {
		console.log(char); //h, e, l, l, o
	}
	
	//With Maps - iterates over [key, value] pairs
	let map = new Map([
		["a", 1],
		["b", 2]
	]);
	for (let [key, value] of map) {
		console.log(key, value); //a 1, b 2
	}
	
	//Getting index with entries()
	let colors = ["red", "green", "blue"];
	for (let [index, value] of colors.entries()) {
		console.log(index, value); //0 red, 1 green, 2 blue
	}
	
	//Cannot use for...of on plain objects
	//let obj = {a: 1};
	//for (let val of obj) {} //Error: obj is not iterable
}


//============================================================
//BREAK AND CONTINUE
//============================================================

function breakContinue() {
	//break - exits loop immediately
	for (let i = 0; i < 10; i++) {
		if (i === 5) break;
		console.log(i); //0, 1, 2, 3, 4
	}
	
	//Labeled break - breaks out of nested loops
	outer: for (let i = 0; i < 3; i++) {
		for (let j = 0; j < 3; j++) {
			if (i === 1 && j === 1) break outer;
			console.log(i, j);
		}
	}
	//Prints: 0 0, 0 1, 0 2, 1 0, then breaks


	//continue - skips current iteration, continues with next
	for (let i = 0; i < 5; i++) {
		if (i === 2) continue;
		console.log(i); //0, 1, 3, 4 (skips 2)
	}
	//Labeled continue
	outer: for (let i = 0; i < 3; i++) {
		for (let j = 0; j < 3; j++) {
			if (j === 1) continue outer;
			console.log(i, j);
		}
	}
	//Prints: 0 0, 1 0, 2 0
}