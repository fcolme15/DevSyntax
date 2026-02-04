function mainSummary() {
	queueWithArray();
	dequeWithArray();
}

//============================================================
//QUEUE (FIFO - First In First Out)
//============================================================

function queueWithArray() {
	const queue = [];
	
	//Enqueue - add to end
	queue.push(1);
	queue.push(2);
	queue.push(3);
	
	//Dequeue - remove from front returns the value shifted out
	const first = queue.shift();
	
	//Peek - view front without removing
	const front = queue[0];
	
	//Check if empty
	const isEmpty = queue.length === 0;
	
	//Size
	console.log(queue.length); //2
	
	//Clear queue
	queue.length = 0;
	
	//Note: shift() is O(n) - inefficient for large queues
	//For high-performance queues, use linked list or circular buffer
}

//============================================================
//DEQUE (Double-Ended Queue)
//============================================================

function dequeWithArray() {
	const deque = [];
	
	//Add to front
	deque.unshift(1);
	deque.unshift(2);
	console.log(deque); //[2, 1]
	
	//Add to back
	deque.push(3);
	deque.push(4);
	console.log(deque); //[2, 1, 3, 4]
	
	//Remove from front
	const front = deque.shift();
	console.log(front); //2
	console.log(deque); //[1, 3, 4]
	
	//Remove from back
	const back = deque.pop();
	console.log(back); //4
	console.log(deque); //[1, 3]
	
	//Peek front
	console.log(deque[0]); //1
	
	//Peek back
	console.log(deque[deque.length - 1]); //3
	
	//Deque allows operations on both ends
}