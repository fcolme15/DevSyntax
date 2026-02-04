function mainSummary() {
	stackWithArray();
}

//============================================================
//STACK (LIFO - Last In First Out)
//============================================================

function stackWithArray() {
	const stack = [];
	
	//Push - add to top
	stack.push(1);
	stack.push(2);
	stack.push(3);
	console.log(stack); //[1, 2, 3]
	
	//Pop - remove from top and returns the value popped
	const top = stack.pop();
	
	//Peek - view top without removing
	const peek = stack[stack.length - 1];
	
	//Check if empty
	const isEmpty = stack.length === 0;
	
	//Size
	console.log(stack.length); //2
	
	//Clear stack
	stack.length = 0;
	console.log(stack); //[]
}