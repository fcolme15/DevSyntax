function mainSummary() {
	promiseCreation();
	thenCatchFinally();
	promiseChaining();
	promiseStatic();
	errorHandling();
}

function promiseCreation() {
	//Promise constructor takes executor function with resolve/reject
	const promise = new Promise(function(resolve, reject) {
		//Async operation
		setTimeout(function() {
			const success = true;
			if (success) {
				resolve("Operation successful"); //Fulfilled
			} else {
				reject("Operation failed"); //Rejected
			}
		}, 1000);
	});
	
	//Promise has 3 states: pending, fulfilled, rejected
	console.log(promise); //Promise {<pending>}
	
	//Creating resolved promise
	const resolvedPromise = Promise.resolve("Immediate success");
	console.log(resolvedPromise); //Promise {<fulfilled>: "Immediate success"}
	
	//Creating rejected promise
	const rejectedPromise = Promise.reject("Immediate failure");
	console.log(rejectedPromise); //Promise {<rejected>: "Immediate failure"}
}

function thenCatchFinally() {
	//then - handles fulfilled promise
	const promise1 = Promise.resolve("Success");
	promise1.then(function(result) {
		console.log(result); //"Success"
	});
	
	//catch - handles rejected promise
	const promise2 = Promise.reject("Error");
	promise2.catch(function(error) {
		console.log("Caught:", error); //"Caught: Error"
	});
	
	//then with both success and error handlers
    //Can chain with catch so that yes the first error runs the second then function 
    //but any error in the then is also caught by the catch
	const promise3 = new Promise(function(resolve, reject) {
		resolve("Done");
	});
	promise3.then(
		function(result) {
			console.log("Success:", result);
		},
		function(error) {
			console.log("Error:", error);
		}
	);
	
	//finally - runs regardless of outcome
	const promise4 = Promise.resolve("Complete");
	promise4
		.then(function(result) {
			console.log(result);
		})
		.catch(function(error) {
			console.log(error);
		})
		.finally(function() {
			console.log("Cleanup - always runs");
		});
}

function promiseChaining() {
	//Returning value in then - becomes resolved promise
	Promise.resolve(5)
		.then(function(num) {
			return num * 2; //10
		})
		.then(function(num) {
			return num + 3; //13
		})
		.then(function(num) {
			console.log(num); //13
		});
}

function promiseStatic() {
	//Promise.all - waits for all promises, rejects if any fails
	const p1 = Promise.resolve(1);
	const p2 = Promise.resolve(2);
	const p3 = Promise.resolve(3);
	Promise.all([p1, p2, p3]).then(function(results) {
		console.log(results); //[1, 2, 3]
	});
	
	//Promise.race - resolves/rejects with first settled promise
	const slow = new Promise(resolve => setTimeout(() => resolve("Slow"), 2000));
	const fast = new Promise(resolve => setTimeout(() => resolve("Fast"), 1000));
	Promise.race([slow, fast]).then(function(result) {
		console.log(result); //"Fast"
	});
	
	//Promise.allSettled - waits for all, returns status of each
	const p7 = Promise.resolve(1);
	const p8 = Promise.reject("Error");
	const p9 = Promise.resolve(3);
	Promise.allSettled([p7, p8, p9]).then(function(results) {
		console.log(results);
		//[
		//  {status: "fulfilled", value: 1},
		//  {status: "rejected", reason: "Error"},
		//  {status: "fulfilled", value: 3}
		//]
	});
	
	//Promise.any - resolves with first fulfilled promise
    //Promise.any rejects only if all promises reject
	const p10 = Promise.reject("Error 1");
	const p11 = Promise.resolve("Success");
	const p12 = Promise.reject("Error 2");
	Promise.any([p10, p11, p12]).then(function(result) {
		console.log(result); //"Success"
	});
}