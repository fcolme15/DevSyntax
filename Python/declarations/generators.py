#Covers: generator functions, yield, generator expressions, lazy evaluation

def generators() -> None:
    
    #============================================================
    #BASIC GENERATOR FUNCTION
    #============================================================
    
    #Regular function - returns all values at once
    def get_numbers_list() -> list[int]:
        result: list[int] = []
        for i in range(5):
            result.append(i)
        return result #Returns entire list in memory
    
    #Generator function - yields values one at a time
    def get_numbers_generator():
        for i in range(5):
            yield i #Pauses here, returns value, resumes on next call
    
    #Using generator
    gen = get_numbers_generator()
    print(type(gen)) #<class 'generator'>
    
    #Get values one at a time
    first: int = next(gen) #0
    second: int = next(gen) #1
    third: int = next(gen) #2
    
    #Iterate through remaining values
    for num in gen: #3, 4
        print(num)
    
    
    #============================================================
    #GENERATOR EXPRESSIONS - Like list comprehensions
    #============================================================
    
    #List comprehension - creates entire list
    squares_list: list[int] = [x**2 for x in range(10)]
    print(type(squares_list)) #<class 'list'>
    
    #Generator expression - creates generator (use parentheses)
    squares_gen = (x**2 for x in range(10))
    print(type(squares_gen)) #<class 'generator'>
    
    #Convert to list when needed
    result: list[int] = list(squares_gen)
    
    #Use directly in functions that accept iterables
    total: int = sum(x**2 for x in range(10)) #No list created!
    maximum: int = max(x**2 for x in range(10))
    
    
    #============================================================
    #GENERATOR WITH PARAMETERS
    #============================================================
    
    def repeat(value, times: int):
        """Yields value specified number of times"""
        for _ in range(times):
            yield value
    
    for item in repeat("hello", 3):
        print(item) #hello, hello, hello
    
    
    #============================================================
    #SENDING VALUES TO GENERATORS
    #============================================================
    
    def echo():
        """Generator that can receive values"""
        while True:
            received = yield #Receives value from send()
            if received is not None:
                print(f"Received: {received}")
    
    gen = echo()
    next(gen) #Must prime generator first
    gen.send("Hello") #Sends value to generator
    gen.send("World")
    gen.close() #Stop generator
    
    
    #============================================================
    #CONVERTING BETWEEN GENERATORS AND LISTS
    #============================================================
    
    #Generator to list
    gen = (x**2 for x in range(5))
    as_list: list[int] = list(gen) #[0, 1, 4, 9, 16]
    
    #List to generator
    my_list: list[int] = [1, 2, 3, 4, 5]
    as_gen = (x for x in my_list) #Generator from list
    #Or use iter()
    as_gen2 = iter(my_list)


if __name__ == "__main__":
    generators()