function mainSummary() {
	callbackBasics();
	asynchronousCallbacks();
	callbackHell();
	errorFirstCallbacks();
}

//============================================================
//COMPARISON: Synchronous vs Asynchronous Callbacks
//============================================================
//Synchronous callbacks: Execute immediately (array methods like map, forEach)
//Asynchronous callbacks: Execute later (setTimeout, event listeners, API calls)
//Async callbacks don't block code execution - other code runs while waiting

function callbackBasics() {
	//Callback - function passed as argument to another function
	function greet(name, callback) {
		console.log(`Hello ${name}`);
		callback();
	}
	
	greet("John", function() {
		console.log("Callback executed");
	});
	
	//Callback with parameters are the same just send the correct parameters
	
	//Array methods use callbacks
	const numbers = [1, 2, 3, 4, 5];
	const doubled = numbers.map(function(num) {
		return num * 2;
	});
}

function asynchronousCallbacks() {
	//setTimeout - executes callback after delay
	console.log("Start");
	
	setTimeout(function() {
		console.log("Executed after 2 seconds");
	}, 2000);
	
	console.log("End"); //Logs before setTimeout callback
	//Output order: Start, End, Executed after 2 seconds
	
	//setInterval - executes callback repeatedly
	let count = 0;
	const intervalId = setInterval(function() {
		count++;
		console.log(`Count: ${count}`);
		if (count >= 3) {
			clearInterval(intervalId); //Stop interval
		}
	}, 1000);
	
	//Event listeners use callbacks
	//button.addEventListener('click', function(event) {
	//	console.log('Button clicked');
	//});
}

function callbackHell() {
	//Nested callbacks create "pyramid of doom"
	function step1(callback) {
		setTimeout(function() {
			console.log("Step 1 complete");
			callback();
		}, 1000);
	}
	
	function step2(callback) {
		setTimeout(function() {
			console.log("Step 2 complete");
			callback();
		}, 1000);
	}
	
	function step3(callback) {
		setTimeout(function() {
			console.log("Step 3 complete");
			callback();
		}, 1000);
	}
	
	//Callback hell - deeply nested, hard to read
	step1(function() {
		step2(function() {
			step3(function() {
				console.log("All steps complete");
			});
		});
	});
	
	//Problems: hard to read, hard to error handle, hard to maintain
	//Solution: Promises and async/await (covered in other files)
}

function errorFirstCallbacks() {
	//Node.js convention: first parameter is error, second is result
	function readFile(filename, callback) {
		setTimeout(function() {
			const error = filename === "invalid.txt" ? new Error("File not found") : null;
			const data = error ? null : "File contents";
			callback(error, data);
		}, 1000);
	}
	
	//Using error-first callback
	readFile("valid.txt", function(error, data) {
		if (error) {
			console.log("Error:", error.message);
			return;
		}
		console.log("Data:", data);
	});
}
