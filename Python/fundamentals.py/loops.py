#Covers: for loops, while loops, break, continue, pass, else clause, enumerate, zip

def loops() -> None:
    
    #============================================================
    #FOR LOOPS - Iterate over sequences
    #============================================================
    arr  = []
    
    for i in range(10): #i = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
        arr.append(i)
    
    #range(start, stop, step)
    for i in range(len(arr)-1, 0, -1): #Reverse loop
        pass #Skip this iteration
    
    #Iterate over list
    fruits: list[str] = ["apple", "banana", "cherry"]
    for fruit in fruits:
        pass
    
    #Iterate over string
    for char in "hello":
        pass
    
    #Iterate over dictionary
    person: dict[str, int] = {"Alice": 25, "Bob": 30}
    
    for key in person: #Default: iterate keys
        pass
    
    for key in person.keys():
        pass
    
    for value in person.values():
        pass
    
    for key, value in person.items():
        pass


    #============================================================
    #WHILE LOOPS - Continue while condition is True
    #============================================================
    
    count: int = 0
    while count < 5:
        count += 1
    
    # Infinite loop with break
    while True:
        break  # Exit immediately
    

    #============================================================
    #ENUMERATE - Get index + value
    #============================================================
    
    colors: list[str] = ["red", "green", "blue"]
    
    for index, color in enumerate(colors):
        pass  # index = 0, 1, 2 and color = "red", "green", "blue"
    
    # Start index at custom value
    for index, color in enumerate(colors, start=1):
        pass  # index = 1, 2, 3
    

    #============================================================
    #ZIP - Iterate multiple sequences together
    #============================================================
    
    names: list[str] = ["Alice", "Bob", "Charlie"]
    ages: list[int] = [25, 30, 35]
    
    for name, age in zip(names, ages):
        pass #Pairs: ("Alice", 25), ("Bob", 30), ("Charlie", 35)
    
    #If one is shorter it stops at shortest sequence. 
    scores: list[int] = [90, 85]
    for name, age, score in zip(names, ages, scores):
        pass #Only 2 iterations
    

    #============================================================
    #BREAK - Exit loop early
    #============================================================
    
    for i in range(10):
        if i == 5:
            break #Exits loop when i is 5
    
    
    #============================================================
    #CONTINUE - Skip to next iteration
    #============================================================
    
    for i in range(5):
        if i == 2:
            continue #Skips the iteration where i == 2
    
    
    #============================================================
    #PASS - Placeholder (does nothing)
    #============================================================
    
    for i in range(3):
        pass #Fill empty error with nothing syntax
    
    
    #============================================================
    #ELSE CLAUSE - Runs if loop completes without break
    #============================================================
    
    for i in range(5):
        if i == 10:
            break
    else:
        pass #This runs because break never executed
    
    for i in range(5):
        if i == 3:
            break
    else:
        pass #This does NOT run because break executed
    

    count = 0
    while count < 3:
        count += 1
    else: #Runs after while condition becomes False
        pass  

if __name__ == "__main__":
    loops()