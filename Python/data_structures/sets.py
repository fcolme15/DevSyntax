#Covers: set creation, operations, methods, frozenset

def set_basics() -> None:
    
    #============================================================
    #CREATION
    #============================================================
    
    #Empty set
    empty: set = set() #Cannot use {} - that's empty dict
    
    #Initialized set - Can use {} because its a non empty initialized set
    numbers: set[int] = {1, 2, 3, 4, 5}
    
    #From list (removes duplicates)
    nums_list: list[int] = [1, 2, 2, 3, 3, 3]
    unique: set[int] = set(nums_list) #{1, 2, 3}
    
    #From string
    chars: set[str] = set("hello") #{'h', 'e', 'l', 'o'}
    
    #Set comprehension
    squares: set[int] = {x**2 for x in range(5)} #{0, 1, 4, 9, 16}
    
    
    #============================================================
    #ADDING ELEMENTS
    #============================================================
    
    nums: set[int] = {1, 2, 3}
    
    #Add single element
    nums.add(4) #{1, 2, 3, 4}
    nums.add(2) #{1, 2, 3, 4} - duplicate ignored
    
    #Add multiple elements - Adding another set or list
    nums.update([5, 6, 7]) #{1, 2, 3, 4, 5, 6, 7}
    nums.update({8, 9}) #Can update with another set
    
    
    #============================================================
    #REMOVING ELEMENTS
    #============================================================
    
    nums = {1, 2, 3, 4, 5}
    
    #Remove - raises KeyError if not found
    nums.remove(3) #{1, 2, 4, 5}
    #nums.remove(99) #KeyError
    
    #Discard - no error if not found
    nums.discard(4) #{1, 2, 5}
    nums.discard(99) #No error
    
    #Pop - remove and return arbitrary element
    element: int = nums.pop() #Removes random element
    
    #Clear all
    nums.clear() #set()
    
    
    #============================================================
    #CHECKING MEMBERSHIP
    #============================================================
    
    nums = {1, 2, 3, 4, 5}
    
    #Check if element exists O(1) average
    exists: bool = 3 in nums #True
    exists = 99 not in nums #True
    
    #Length
    length: int = len(nums) #5
    
    
    #============================================================
    #SET OPERATIONS
    #============================================================
    
    set1: set[int] = {1, 2, 3, 4}
    set2: set[int] = {3, 4, 5, 6}
    
    #Union - all elements from both sets
    union: set[int] = set1 | set2 #{1, 2, 3, 4, 5, 6}
    union = set1.union(set2) #Same thing
    
    #Intersection - elements in both sets
    intersection: set[int] = set1 & set2 #{3, 4}
    intersection = set1.intersection(set2) #Same thing
    
    #Difference - elements in set1 but not set2
    diff: set[int] = set1 - set2 #{1, 2}
    diff = set1.difference(set2) #Same thing
    
    #Symmetric difference - elements in either but not both
    sym_diff: set[int] = set1 ^ set2 #{1, 2, 5, 6}
    sym_diff = set1.symmetric_difference(set2) #Same thing
    
    
    #============================================================
    #SUBSET AND SUPERSET
    #============================================================
    
    set1 = {1, 2, 3}
    set2 = {1, 2, 3, 4, 5}
    
    #Check if subset
    is_subset: bool = set1 <= set2 #True
    is_subset = set1.issubset(set2) #Same thing
    
    #Check if proper subset (strict)
    is_proper: bool = set1 < set2 #True
    
    #Check if superset
    is_superset: bool = set2 >= set1 #True
    is_superset = set2.issuperset(set1) #Same thing
    
    #Check if disjoint (no common elements)
    set3: set[int] = {7, 8, 9}
    is_disjoint: bool = set1.isdisjoint(set3) #True
    
    
    #============================================================
    #Sorting and converting to a list
    #============================================================
    
    nums = {1, 2, 3, 4, 5}
    
    #Convert to sorted list for ordered iteration
    sorted_nums: list[int] = sorted(nums)
    

    list_nums: list[int] = list(nums) #Convert the set into a list
    
    #============================================================
    #COMMON USE CASES
    #============================================================
    
    #Remove duplicates from list
    items: list[int] = [1, 2, 2, 3, 3, 3, 4]
    unique_items: list[int] = list(set(items)) #[1, 2, 3, 4] (order not preserved)
    
    #Find common elements
    list1: list[int] = [1, 2, 3, 4]
    list2: list[int] = [3, 4, 5, 6]
    common: set[int] = set(list1) & set(list2) #{3, 4}
    
    #Find unique elements across lists
    all_unique: set[int] = set(list1) ^ set(list2) #{1, 2, 5, 6}


def frozenset_usage() -> None:
    """Immutable version of set"""
    
    #============================================================
    #FROZENSET BASICS
    #============================================================
    
    #Create frozenset
    frozen: frozenset[int] = frozenset([1, 2, 3, 4])
    
    #From set
    regular: set[int] = {1, 2, 3}
    frozen = frozenset(regular)
    
    #Cannot modify
    #frozen.add(5) #AttributeError - no add method
    #frozen.remove(1) #AttributeError - no remove method
    
    
    #============================================================
    #USE CASES
    #============================================================
    
    #Can be dict keys (sets cannot)
    set_dict: dict[frozenset[int], str] = {}
    set_dict[frozenset([1, 2, 3])] = "value"
    
    #Can be elements of other sets (sets cannot)
    set_of_sets: set[frozenset[int]] = {frozenset([1, 2]), frozenset([3, 4])}
    
    #All set operations work
    f1: frozenset[int] = frozenset([1, 2, 3])
    f2: frozenset[int] = frozenset([2, 3, 4])
    union: frozenset[int] = f1 | f2 #frozenset({1, 2, 3, 4})


if __name__ == "__main__":
    print("=== Set Basics ===")
    set_basics()
    
    print("\n=== Frozenset ===")
    frozenset_usage()