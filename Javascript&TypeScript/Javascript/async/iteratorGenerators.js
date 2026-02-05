function mainSummary() {
	iteratorBasics();
	customIterator();
	generatorBasics();
	generatorAdvanced();
}

function iteratorBasics() {
	//Iterables have Symbol.iterator method
	const arr = [1, 2, 3];
	const iterator = arr[Symbol.iterator]();
	
	console.log(iterator.next()); //{value: 1, done: false}
	console.log(iterator.next()); //{value: 2, done: false}
	console.log(iterator.next()); //{value: 3, done: false}
	console.log(iterator.next()); //{value: undefined, done: true}
	
	//for...of uses iterator protocol
	for (let value of arr) {
		console.log(value); //1, 2, 3
	}
	
	//Spread operator uses iterator
	const arr2 = [...arr]; //[1, 2, 3]
	
	//Built-in iterables: Array, String, Map, Set
	//Objects are NOT iterable by default
}

function customIterator() {
	//Make object iterable by defining Symbol.iterator
	const range = {
		start: 1,
		end: 5,
		
		[Symbol.iterator]() {
			let current = this.start;
			const last = this.end;
			
			return {
				next() {
					if (current <= last) {
						return { value: current++, done: false };
					}
					return { done: true };
				}
			};
		}
	};
	
	for (let num of range) {
		console.log(num); //1, 2, 3, 4, 5
	}
	
	const arr = [...range]; //[1, 2, 3, 4, 5]
}

function generatorBasics() {
	//Generator function - uses function* and yield
    //Generators are iterable with loops
	function* simpleGenerator() {
		yield 1;
		yield 2;
		yield 3;
	}
	
	const gen = simpleGenerator();
	console.log(gen.next()); //{value: 1, done: false}
	console.log(gen.next()); //{value: 2, done: false}
	console.log(gen.next()); //{value: 3, done: false}
	console.log(gen.next()); //{value: undefined, done: true}
	
	//Passing values to generator with next()
	function* generatorWithInput() {
		const a = yield "First";
		console.log("Received:", a);
		const b = yield "Second";
		console.log("Received:", b);
		return "Done";
	}

	//GENERATOR ADVANCED
	const genAvd = generatorWithInput();
	console.log(genAvd.next()); //{value: "First", done: false}
	console.log(genAvd.next(10)); //"Received: 10" {value: "Second", done: false}
	console.log(genAvd.next(20)); //"Received: 20" {value: "Done", done: true}
	
	//yield* delegates to another generator
	function* gen1() {
		yield 1;
		yield 2;
	}
	
	function* gen2() {
		yield* gen1(); //Delegate
		yield 3;
	}
	
	console.log([...gen2()]); //[1, 2, 3]
}