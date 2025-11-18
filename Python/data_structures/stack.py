#Covers: stack implementation using list and deque (LIFO - Last In First Out)

from collections import deque

def stack_with_list() -> None:
    
    #============================================================
    #STACK OPERATIONS WITH LIST
    #============================================================
    
    #Create empty stack
    stack: list[int] = []
    
    #Push - add to top O(1)
    stack.append(1)
    stack.append(2)
    stack.append(3)
    #Stack: [1, 2, 3] (3 is top)
    
    #Peek - view top without removing
    if stack: #Check not empty
        top: int = stack[-1] #3
    
    #Pop - remove and return top O(1)
    item: int = stack.pop() #3
    #Stack: [1, 2]
    
    #Check if empty
    is_empty: bool = len(stack) == 0 #False
    is_empty = not stack #Alternative
    
    #Size
    size: int = len(stack) #2
    
    #Clear stack
    stack.clear() #[]


def stack_with_deque() -> None:
    """Stack using deque - better performance, preferred method"""
    
    #============================================================
    #STACK OPERATIONS WITH DEQUE
    #============================================================
    
    #Create empty stack
    stack: deque[int] = deque()
    
    #Push - add to top O(1)
    stack.append(1)
    stack.append(2)
    stack.append(3)

    #Pop - remove and return top O(1)
    item: int = stack.pop() #3
    #Stack: deque([1, 2])

    #Peek - view top without removing
    if stack: #Check not empty
        top: int = stack[-1] #3
    
    #Check if empty
    is_empty: bool = len(stack) == 0 #False
    is_empty = not stack #Alternative
    
    #Size
    size: int = len(stack) #2
    
    #Clear stack
    stack.clear() #deque([])



if __name__ == "__main__":
    print("=== Stack with List ===")
    stack_with_list()
    
    print("\n=== Stack with Deque ===")
    stack_with_deque()
    