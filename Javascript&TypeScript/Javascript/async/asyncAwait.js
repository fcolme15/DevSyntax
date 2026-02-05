function mainSummary() {
	asyncFunctionBasics();
	awaitKeyword();
	errorHandling();
	parallelExecution();
	topLevelAwait();
}

function asyncFunctionBasics() {
	//async keyword makes function return a promise
	async function greet() {
		return "Hello";
	}
	console.log(greet()); //Promise {<fulfilled>: "Hello"}
	greet().then(function(result) {
		console.log(result); //"Hello"
	});
	//Equivalent to:
	function greetPromise() {
		return Promise.resolve("Hello");
	}
	
	//async arrow function
	const asyncArrow = async () => {
		return "Arrow function result";
	};
}

function awaitKeyword() {
	//await pauses execution until promise resolves
	//Can only use await inside async function
	
	function delay(ms) {
		return new Promise(resolve => setTimeout(resolve, ms));
	}
	
	async function example() {
		console.log("Start");
		await delay(1000); //Waits 1 second
		console.log("After 1 second");
		await delay(1000); //Waits another second
		console.log("After 2 seconds");
	}
	example();
	
	//await with value
	async function fetchUser() {
		const user = await Promise.resolve({ id: 1, name: "John" });
		console.log(user); //{id: 1, name: "John"}
		return user;
	}
	
	//Sequential async operations
	function getUser(id) {
		return new Promise(resolve => {
			setTimeout(() => resolve({ id: id, name: "John" }), 1000);
		});
	}
	
	function getPosts(userId) {
		return new Promise(resolve => {
			setTimeout(() => resolve([{ id: 1, title: "Post 1" }]), 1000);
		});
	}
	
	async function getUserData() {
		const user = await getUser(1);
		console.log("User:", user);
		
		const posts = await getPosts(user.id);
		console.log("Posts:", posts);
		
		return { user, posts };
	}
	
	getUserData(); //Much cleaner than promise chaining or callbacks
}

function errorHandling() {
	//Handling promise rejection right away with an inline catch to fix itself

	//try/catch with finally
	async function processData() {
		try {
			const data = await Promise.resolve("Data");
			console.log(data);
			return data;
		} catch (error) {
			console.log("Error:", error);
		} finally {
			console.log("Cleanup");
		}
	}
	
	processData();
}

//Helper functions for examples
function getUser(id) {
	return new Promise(resolve => {
		setTimeout(() => resolve({ id, name: "John" }), 1000);
	});
}

function getPosts(userId) {
	return new Promise(resolve => {
		setTimeout(() => resolve([{ id: 1, title: "Post 1" }]), 1000);
	});
}

function getComments(postId) {
	return new Promise(resolve => {
		setTimeout(() => resolve([{ id: 1, text: "Comment" }]), 1000);
	});
}

function parallelExecution() {
	//Sequential await - slow (waits for each)
	async function sequential() {
		const user = await getUser(1); //1 second
		const posts = await getPosts(1); //1 second
		const comments = await getComments(1); //1 second
		//Total: 3 seconds
		return { user, posts, comments };
	}
	
	//Parallel execution - fast (runs simultaneously)
	async function parallel() {
		const userPromise = getUser(1);
		const postsPromise = getPosts(1);
		const commentsPromise = getComments(1);
		
		const user = await userPromise;
		const posts = await postsPromise;
		const comments = await commentsPromise;
		//Total: 1 second (all run at same time)
		return { user, posts, comments };
	}
	
	//Using Promise.all for parallel execution
	async function parallelWithAll() {
		const [user, posts, comments] = await Promise.all([
			getUser(1),
			getPosts(1),
			getComments(1)
		]);
		//Total: 1 second, cleaner syntax
		return { user, posts, comments };
	}

    //Also can use:
	//Promise.allSettled with async/await
	//Promise.race with async/await
}

function topLevelAwait() {
	//Top-level await (ES2022) - await outside async function in modules
	//Only works in ES modules (type="module" in HTML or .mjs files)
	
	//In module file:
	//const data = await fetch('https://api.example.com/data');
	//const json = await data.json();
	//export { json };
	
	//Before top-level await, had to use IIFE:
	//(async function() {
	//	const data = await fetch('https://api.example.com/data');
	//	const json = await data.json();
	//	console.log(json);
	//})();
	
	//Top-level await blocks module execution until promise resolves
	//Use for initialization tasks, loading config, etc.
}