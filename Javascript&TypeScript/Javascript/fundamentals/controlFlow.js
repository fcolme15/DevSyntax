//Run all examples
function mainSummary() {
	ifElseStatements();
	switchStatements();
}

function ifElseStatements() {
	//Basic if
	let age = 20;
	if (age >= 18) {
		console.log("Adult");
	}
	
	//If-else
	if (age < 18) {
		console.log("Minor");
	} else {
		console.log("Adult");
	}
	
	//If-else if-else chain
	let score = 85;
	if (score >= 90) {
		console.log("A");
	} else if (score >= 80) {
		console.log("B");
	} else if (score >= 70) {
		console.log("C");
	} else {
		console.log("F");
	}
	
	//Nested if statements
	let hasLicense = true;
	let hasInsurance = true;
	if (hasLicense) {
		if (hasInsurance) {
			console.log("Can drive");
		} else {
			console.log("Need insurance");
		}
	}
	
	//Single-line if (no braces)
	if (age >= 18) console.log("Adult");
}

function switchStatements() { //Switch uses strict equality (===)
	//Basic switch with break
	let day = 3;
	switch (day) {
		case 1:
			console.log("Monday");
			break;
		case 2:
			console.log("Tuesday");
			break;
		case 3:
			console.log("Wednesday");
			break;
		default:
			console.log("Other day");
	}
	
	//Multiple cases with same code (fall-through)
	let fruit = "apple";
	switch (fruit) {
		case "apple":
		case "pear":
		case "orange":
			console.log("Common fruit");
			break;
		case "dragonfruit":
		case "starfruit":
			console.log("Exotic fruit");
			break;
		default:
			console.log("Unknown fruit");
	}
}