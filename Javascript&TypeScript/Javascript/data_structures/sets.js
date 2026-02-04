function mainSummary() {
	setCreation();
	setMethods();
	setIteration();
	setOperations();
}

function setCreation() {
	//Empty set
	const set1 = new Set();
	
	//Set from array - automatically removes duplicates
	const set2 = new Set([1, 2, 3, 3, 4, 4, 5]);
	
	//Set from string - each character becomes element
	const set3 = new Set("hello");
	
	//Set with different types
	const set4 = new Set([1, "two", true, null, { x: 5 }]);
	
	//Set size property
	console.log(set2.size); //5
	
	//Converting Set back to array
	const arr = [...set2]; //[1, 2, 3, 4, 5]
	const arr2 = Array.from(set2); //[1, 2, 3, 4, 5]
}

function setMethods() {
	const set = new Set();
	
	//add - adds element, returns Set
	set.add(1);
	set.add(2);
	set.add(3);
	//Method chaining
	set.add(4).add(5).add(6);
	
	//has - checks if element exists
	console.log(set.has(3)); //true
	
	//delete - removes element, returns boolean
	console.log(set.delete(3)); //true - was removed false - didn't exist
	
	//clear - removes all elements
	set.clear();
	
	//NaN handling - Set treats NaN as equal to itself
	const nanSet = new Set();
	nanSet.add(NaN);
	
	//Object references - same reference = same element
	const obj = { x: 1 };
	const objSet = new Set();
	objSet.add(obj);
	objSet.add(obj); //Same reference
	console.log(objSet.size); //1
	
	objSet.add({ x: 1 }); //Different reference
	console.log(objSet.size); //2 - different objects
}

function setIteration() {
	const set = new Set([1, 2, 3, 4, 5]);
	
	//for...of - iterate over values
	for (let value of set) {
		console.log(value); //1, 2, 3, 4, 5
	}
	
	//forEach - callback for each element
	set.forEach((value, valueAgain, set) => {
		console.log(value); //1, 2, 3, 4, 5
		//Note: second param is also value (for compatibility with Map)
	});
	
	//values - returns iterator of values
    //keys - same as values (for Map compatibility)
	//for (let key of set.keys())
	for (let value of set.values()) {
		console.log(value); //1, 2, 3, 4, 5
	}
	
	//entries - returns [value, value] pairs
	for (let [key, value] of set.entries()) {
		console.log(key, value); //1 1, 2 2, 3 3, etc.
	}
	
	//Convert to array and use array methods
	const doubled = [...set].map(x => x * 2); //[2, 4, 6, 8, 10]
}

function setOperations() {
	const setA = new Set([1, 2, 3, 4]);
	const setB = new Set([3, 4, 5, 6]);
	
	//Union - all unique elements from both sets
	const union = new Set([...setA, ...setB]);
	
	//Intersection, Difference, Symmetric Difference
	const resultSet = new Set(
		[...setA].filter(x => setB.has(x)) //Intersection - elements in both sets
        
        //[...setA].filter(x => !setB.has(x)) //Difference - elements in setA but not in setB
        
        //Symmetric difference - elements in either set but not both
        //...[...setA].filter(x => !setB.has(x)),
		//...[...setB].filter(x => !setA.has(x))
	);
	
	//Subset - check if setA is subset of setB
	const isSubset = [...setA].every(x => setB.has(x));

	//Superset - check if setA contains all of setB
	const isSuperset = [...setB].every(x => setA.has(x));
}