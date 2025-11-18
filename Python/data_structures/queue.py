#Covers: queue (FIFO), deque operations, priority queue with heapq

from collections import deque
from queue import Queue
import heapq

def deque_basics() -> None:
    """Deque (double-ended queue) - efficient operations at both ends"""
    
    #============================================================
    #DEQUE CREATION
    #============================================================
    
    #Create empty deque
    dq: deque[int] = deque()
    
    #Create from iterable
    dq = deque([1, 2, 3, 4, 5])
    
    #Create with max length (circular buffer)
    dq = deque(maxlen=3) #Automatically removes from opposite end when full
    
    
    #============================================================
    #ADDING ELEMENTS
    #============================================================
    
    dq = deque([2, 3, 4])
    
    #Add to right (end) O(1)
    dq.append(5) #deque([2, 3, 4, 5])
    
    #Add to left (front) O(1)
    dq.appendleft(1) #deque([1, 2, 3, 4, 5])
    
    #Extend right
    dq.extend([6, 7]) #deque([1, 2, 3, 4, 5, 6, 7])
    
    #Extend left
    dq.extendleft([0, -1]) #deque([-1, 0, 1, 2, 3, 4, 5, 6, 7])
    
    
    #============================================================
    #REMOVING ELEMENTS
    #============================================================
    
    dq = deque([1, 2, 3, 4, 5])
    
    #Remove from right O(1)
    item: int = dq.pop() #5, deque([1, 2, 3, 4])
    
    #Remove from left O(1)
    item = dq.popleft() #1, deque([2, 3, 4])
    
    #Remove specific value (first occurrence)
    dq.remove(3) #deque([2, 4])
    
    #Clear all
    dq.clear() #deque([])
    
    
    #============================================================
    #ACCESSING ELEMENTS
    #============================================================
    
    dq = deque([1, 2, 3, 4, 5])
    
    #Index access O(n) - slower than list
    first: int = dq[0] #1
    last: int = dq[-1] #5
    
    
    #============================================================
    #ROTATING
    #============================================================
    
    dq = deque([1, 2, 3, 4, 5])
    
    #Rotate right (positive)
    dq.rotate(2) #deque([4, 5, 1, 2, 3])
    
    #Rotate left (negative)
    dq.rotate(-1) #deque([5, 1, 2, 3, 4])
    
    
    #============================================================
    #OTHER OPERATIONS
    #============================================================
    
    dq = deque([1, 2, 3, 4, 5])
    
    #Count occurrences
    count: int = dq.count(3) 
    
    #Reverse in place
    dq.reverse() #deque([5, 4, 3, 2, 1])
    
    #Length
    length: int = len(dq) 
    


def queue_basics() -> None:
    """Queue using queue.Queue - thread-safe for multi-threading"""
    
    #============================================================
    #QUEUE OPERATIONS
    #============================================================
    
    #Create empty queue
    q: Queue[int] = Queue()
    
    #Enqueue - add to back
    q.put(1)
    q.put(2)
    q.put(3)
    
    #Dequeue - remove and return front (blocks if empty)
    item: int = q.get()
    
    #Non-blocking get
    try:
        item = q.get_nowait() #Raises Empty exception if empty
    except:
        pass
    
    #Check if empty
    is_empty: bool = q.empty() #False
    
    #Size
    size: int = q.qsize() #Approximate size


def priority_queue_heapq() -> None:
    """Priority queue using heapq - min-heap (lower number = higher priority)"""
    
    #============================================================
    #BASIC PRIORITY QUEUE
    #============================================================
    
    #Create empty priority queue
    pq: list[int] = []
    
    #Add elements O(log n)
    heapq.heappush(pq, 3)
    heapq.heappush(pq, 1)
    heapq.heappush(pq, 5)
    heapq.heappush(pq, 2)
    
    #Peek highest priority (smallest value) O(1)
    if pq:
        highest_priority: int = pq[0] #1
    
    #Remove and return highest priority O(log n)
    item: int = heapq.heappop(pq) #1
    item = heapq.heappop(pq) #2
    item = heapq.heappop(pq) #3
    
    #Convert list to heap in-place O(n)
    numbers: list[int] = [3, 1, 4, 1, 5, 9, 2, 6]
    heapq.heapify(numbers) #Makes it a valid heap
    
    #Get n smallest/largest elements
    smallest: list[int] = heapq.nsmallest(3, [3, 1, 4, 1, 5]) #[1, 1, 3]
    largest: list[int] = heapq.nlargest(3, [3, 1, 4, 1, 5]) #[5, 4, 3]
    
    
    #============================================================
    #PRIORITY QUEUE WITH TUPLES
    #============================================================
    
    #Use tuples (priority, value) for custom priorities
    pq_tasks: list[tuple[int, str]] = []
    
    #Lower number = higher priority
    heapq.heappush(pq_tasks, (2, "Medium priority"))
    heapq.heappush(pq_tasks, (1, "High priority"))
    heapq.heappush(pq_tasks, (3, "Low priority"))
    
    #Pop returns highest priority first
    priority: int
    task: str
    priority, task = heapq.heappop(pq_tasks) #(1, "High priority")
    priority, task = heapq.heappop(pq_tasks) #(2, "Medium priority")
    
    
    #============================================================
    #MAX HEAP (negative numbers trick)
    #============================================================
    
    #heapq is min-heap, use negative numbers for max-heap
    max_heap: list[int] = []
    
    heapq.heappush(max_heap, -5)
    heapq.heappush(max_heap, -3)
    heapq.heappush(max_heap, -8)
    
    #Pop largest (negate to get original value)
    largest: int = -heapq.heappop(max_heap) #8
    largest = -heapq.heappop(max_heap) #5
    largest = -heapq.heappop(max_heap) #3


if __name__ == "__main__":
    print("=== Deque Basics ===")
    deque_basics()
    
    print("\n=== Queue Basics ===")
    queue_basics()
    
    print("\n=== Priority Queue with Heapq ===")
    priority_queue_heapq()