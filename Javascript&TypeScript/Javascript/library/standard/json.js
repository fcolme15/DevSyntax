function mainSummary() {
	jsonStringify();
	jsonParse();
}

function jsonStringify() {
	//Basic usage - converts object to JSON string
	const obj = { name: "John", age: 30, city: "NYC" };
	const json = JSON.stringify(obj);
	console.log(json); //'{"name":"John","age":30,"city":"NYC"}'
	console.log(typeof json); //"string"
	
	//Values that don't serialize
	const special = {
		fn: function() {}, //Omitted
		undef: undefined, //Omitted
		sym: Symbol("x"), //Omitted
		date: new Date(), //Converted to ISO string
		regex: /test/, //Converted to {}
		nan: NaN, //Converted to null
		inf: Infinity //Converted to null
	};
	console.log(JSON.stringify(special)); //'{"date":"2024-12-25T00:00:00.000Z"}'
	
	//Formatting with spaces (pretty print)
	const formatted = JSON.stringify(obj, null, 2);
	console.log(formatted);
	//{
	//  "name": "John",
	//  "age": 30,
	//  "city": "NYC"
	//}
	
	//Replacer function (filter/transform properties)
	const filtered = JSON.stringify(obj, (key, value) => {
		if (key === "age") return undefined; //Exclude age
		return value;
	});
	console.log(filtered); //'{"name":"John","city":"NYC"}'
}

function jsonParse() {
	//Basic usage - converts JSON string to object
	const json = '{"name":"John","age":30,"city":"NYC"}';
	const obj = JSON.parse(json);
	console.log(obj); //{name: "John", age: 30, city: "NYC"}
	console.log(typeof obj); //"object"
	console.log(obj.name); //"John"
	
	//Reviver function (transform values during parsing)
	const dateJson = '{"created":"2024-12-25T00:00:00.000Z"}';
	const withDate = JSON.parse(dateJson, (key, value) => {
		if (key === "created") {
			return new Date(value); //Convert string to Date
		}
		return value;
	});
	console.log(withDate.created instanceof Date); //true
}