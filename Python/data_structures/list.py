#Covers: list creation, indexing, slicing, methods, comprehensions

def list_basics() -> None:
    
    #============================================================
    #CREATION
    #============================================================
    
    #Empty list
    empty: list = []
    empty = list()
    
    #Initialized list
    numbers: list[int] = [1, 2, 3, 4, 5]
    mixed: list = [1, "hello", 3.14, True]
    
    #From other iterables
    from_string: list[str] = list("hello") #['h', 'e', 'l', 'l', 'o']
    from_range: list[int] = list(range(5)) #[0, 1, 2, 3, 4]
    
    #List comprehension
    squares: list[int] = [x**2 for x in range(5)] #[0, 1, 4, 9, 16]
    evens: list[int] = [x for x in range(10) if x % 2 == 0] #[0, 2, 4, 6, 8]
    
    
    #============================================================
    #INDEXING AND SLICING - All slicing makes a new list
    #============================================================
    
    nums: list[int] = [10, 20, 30, 40, 50]
    
    #Indexing
    first: int = nums[0] #10
    last: int = nums[-1] #50
    
    #Slicing [start:end:step]
    subset: list[int] = nums[1:4] #[20, 30, 40]
    subset = nums[:3] #[10, 20, 30]
    subset = nums[2:] #[30, 40, 50]
    subset = nums[::2] #[10, 30, 50]
    subset = nums[::-1] #[50, 40, 30, 20, 10] - reversed
    
    
    #============================================================
    #ADDING ELEMENTS
    #============================================================
    
    nums = [1, 2, 3]
    
    #Append - add to end O(1)
    nums.append(4) #[1, 2, 3, 4]
    
    #Insert - add at index O(n)
    nums.insert(1, 99) #[1, 99, 2, 3, 4]
    
    #Extend - add multiple elements via a list O(k)
    nums.extend([5, 6, 7]) #[1, 99, 2, 3, 4, 5, 6, 7]
    
    #Concatenation
    combined: list[int] = [1, 2] + [3, 4] #[1, 2, 3, 4]
    
    
    #============================================================
    #REMOVING ELEMENTS
    #============================================================
    
    nums = [10, 20, 30, 20, 40]
    
    #Remove - remove first occurrence O(n)
    nums.remove(20) #[10, 30, 20, 40]
    
    #Pop - remove and return at index O(n), O(1) for end
    last: int = nums.pop() #40, nums = [10, 30, 20]
    second: int = nums.pop(1) #30, nums = [10, 20]
    
    #Clear - remove all
    nums.clear() #[]
    
    #Delete by index
    nums = [1, 2, 3, 4, 5]
    del nums[2] #[1, 2, 4, 5]
    del nums[1:3] #[1, 5]
    
    
    #============================================================
    #SEARCHING AND COUNTING
    #============================================================
    
    nums = [10, 20, 30, 20, 40]
    
    #Find index
    idx: int = nums.index(20) #1 (first occurrence)
    #idx = nums.index(99) #ValueError if not found
    
    #Count occurrences
    count: int = nums.count(20) #2
    
    #Check membership
    exists: bool = 30 in nums #True
    exists = 99 not in nums #True
    
    
    #============================================================
    #SORTING
    #============================================================
    
    nums = [3, 1, 4, 1, 5, 9, 2]
    
    #Sort in place
    nums.sort() #[1, 1, 2, 3, 4, 5, 9]
    nums.sort(reverse=True) #[9, 5, 4, 3, 2, 1, 1]
    nums.reverse() #Reverse list in place

    #Return sorted copy - original unchanged
    original: list[int] = [3, 1, 4, 1, 5]
    sorted_list: list[int] = sorted(original) #[1, 1, 3, 4, 5]

    #Sort with key
    words: list[str] = ["apple", "pie", "banana", "cherry"]
    words.sort(key=len) #['pie', 'apple', 'banana', 'cherry']
    
    
    #============================================================
    #OTHER METHODS
    #============================================================
    
    nums = [1, 2, 3, 4, 5]
    
    #Length
    length: int = len(nums) #5
    
    #Min/max/sum
    minimum: int = min(nums) #1
    maximum: int = max(nums) #5
    total: int = sum(nums) #15
    
    #Create a new copy
    copy: list[int] = nums.copy()
    copy = nums[:] 
    copy = list(nums) 


if __name__ == "__main__":
    list_basics()