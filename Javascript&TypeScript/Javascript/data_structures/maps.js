function mainSummary() {
	mapCreation();
	mapMethods();
	mapIteration();
	mapVsObject();
}

//============================================================
//COMPARISON: Map vs Object
//============================================================
//Map: Any key type, guaranteed insertion order, built-in size, optimized for add/delete, no prototype pollution
//Object: String/Symbol keys only, simpler syntax, JSON serializable, better for fixed structure
//Use Map for dynamic key-value storage with non-string keys or frequent modifications
//Use Object for simple data structures, configuration, JSON compatibility

function mapCreation() {
	//Empty map
	const map1 = new Map();
	
	//Map from array of [key, value] pairs
	const map2 = new Map([
		["name", "John"],
		["age", 30],
		["city", "NYC"]
	]);
	
	//Map from Object.entries
	const obj = { a: 1, b: 2, c: 3 };
	const map3 = new Map(Object.entries(obj));
	
	//Map size property
	console.log(map2.size); //3
	
	//Keys can be any type
	const map4 = new Map();
	const keyObj = { id: 1 };
	const keyFunc = function() {};
	const keySymbol = Symbol("key");
	
	map4.set(keyObj, "object key");
	map4.set(keyFunc, "function key");
	map4.set(keySymbol, "symbol key");
	map4.set(1, "number key");
	map4.set("1", "string key");
}

function mapMethods() {
	const map = new Map();
	
	//set - adds or updates entry, returns Map
	map.set("name", "John");
	//Updating existing key
	map.set("age", 31);
	//Method chaining
	map.set("country", "USA").set("state", "NY");
	console.log(map.size); //5
	
	//get - retrieves value by key
	console.log(map.get("name")); //"John"
	
	//has - checks if key exists
	console.log(map.has("name")); //true
	
	//delete - removes entry, returns boolean
	console.log(map.delete("state")); //true - was removed
	
	//clear - removes all entries
	map.clear();
	
	//NaN as key - Map treats NaN === NaN
	const nanMap = new Map();
	nanMap.set(NaN, "value");
}

function mapIteration() {
	const map = new Map([
		["a", 1],
		["b", 2],
		["c", 3]
	]);
	
	//for...of - iterate over [key, value] pairs
	for (let [key, value] of map) {
		console.log(key, value); //a 1, b 2, c 3
	}
	
	//forEach - callback for each entry
	map.forEach((value, key, map) => {
		console.log(key, value); //a 1, b 2, c 3
	});
	
	//keys - returns iterator of keys
	for (let key of map.keys()) {
		console.log(key); //a, b, c
	}
	
	//values - returns iterator of values
	for (let value of map.values()) {
		console.log(value); //1, 2, 3
	}
	
	//entries - returns iterator of [key, value] pairs
	for (let [key, value] of map.entries()) {
		console.log(key, value); //a 1, b 2, c 3
	}
	
	//Convert to array
	const keysArray = [...map.keys()]; //['a', 'b', 'c']
	const valuesArray = [...map.values()]; //[1, 2, 3]
	const entriesArray = [...map.entries()]; //[['a', 1], ['b', 2], ['c', 3]]
	
	//Convert to Object
	const obj = Object.fromEntries(map);
	console.log(obj); //{a: 1, b: 2, c: 3}
	
	//Filter/transform Map
	const filtered = new Map(
		[...map].filter(([key, value]) => value > 1)
	);
	console.log(filtered); //Map(2) {'b' => 2, 'c' => 3}
}