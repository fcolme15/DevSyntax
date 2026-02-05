function mainSummary() {
	tryCatchFinally();
	throwingErrors();
	errorTypes();
	customErrors();
}

function tryCatchFinally() {
	//Basic try/catch
	try {
		//const result = riskyOperation();
		console.log(result);
	} catch (error) {
		console.log("Error:", error.message);
	}
	
	//try/catch/finally
	try {
		console.log("Attempting operation");
		throw new Error("Something failed");
	} catch (error) {
		console.log("Caught:", error.message);
	} finally {
		console.log("Cleanup - always runs");
	}
}

function throwingErrors() {
	//throw keyword - throws any value
	//Re-throwing errors
	try {
		try {
			throw new Error("Original error");
		} catch (error) {
			console.log("Caught, processing...");
			throw error; //Re-throw to outer catch
		}
	} catch (error) {
		console.log("Outer caught:", error.message);
	}
	
	//throw in async code
	async function asyncError() {
		throw new Error("Async error");
	}
	
	asyncError().catch(error => {
		console.log("Caught async:", error.message);
	});
}

function errorTypes() {
	//Error - generic error
	const err1 = new Error("Generic error");
	console.log(err1.name); //"Error"
	console.log(err1.message); //"Generic error"
	console.log(err1.stack); //Stack trace
	
	//SyntaxError - syntax errors
    //ReferenceError - undefined variable
	//TypeError - wrong type operation
	//RangeError - value out of range
	//URIError - URI encoding/decoding error
	//EvalError - error in eval() (rare)
	//AggregateError - multiple errors (Promise.any)
}

function customErrors() {
	//Custom error class
	class HttpError extends Error {
		constructor(message, statusCode) {
			super(message);
			this.name = "HttpError";
			this.statusCode = statusCode;
		}
	}
	
	function fetchData() {
		throw new HttpError("Not found", 404);
	}
	
	try {
		fetchData();
	} catch (error) {
		if (error instanceof HttpError) {
			console.log(`HTTP ${error.statusCode}: ${error.message}`);
		}
	}
}