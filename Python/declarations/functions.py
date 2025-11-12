#Covers: definition, parameters, return, type hints, default args, *args, **kwargs, scope, docstrings

def functions() -> None:
    """Demonstrates all Python function patterns"""
    
    #============================================================
    #BASIC FUNCTION DEFINITION
    #============================================================
    
    #Simple function with no parameters or return
    #No explicit return value defualts to a none return
    def greet() -> None:
        print("Hello!")
    
    #Function with parameters and return
    def add(a: int, b: int) -> int:
        return a + b
    
    #Multiple return values (returns tuple)
    def get_stats(numbers: list[int]) -> tuple[int, int, float]:
        total: int = sum(numbers)
        count: int = len(numbers)
        average: float = total / count
        return total, count, average #Implicitly creates tuple
    
    #Calling and unpacking
    result: tuple[int, int, float] = get_stats([1, 2, 3, 4, 5])
    total, count, avg = get_stats([1, 2, 3, 4, 5]) #Tuple unpacking
    
    
    #============================================================
    #DEFAULT ARGUMENTS
    #============================================================
    
    #Default arguments always need to go to the back
    def greet_person(name: str, greeting: str = "Hello") -> str:
        return f"{greeting}, {name}!"
    
    message1: str = greet_person("Alice") #Uses default: "Hello, Alice!"
    message2: str = greet_person("Bob", "Hi") #Override default: "Hi, Bob!"
    
    #IMPORTANT: Don't use mutable defaults. The list is made the first run and reused every other run as it's an object
    def bad_append(item: int, lst: list[int] = []) -> list[int]: #BAD!
        lst.append(item)
        return lst
    
    #Problem: default list is created once and shared
    result1: list[int] = bad_append(1) #[1]
    result2: list[int] = bad_append(2) #[1, 2] - NOT [2]!
    
    #If one is not given then make a new empty list
    def good_append(item: int, lst: list[int] | None = None) -> list[int]:
        if lst is None:
            lst = []
        lst.append(item)
        return lst
    
    
    #============================================================
    #*ARGS - Variable positional arguments
    #============================================================
    
    #Any number of parameters
    def sum_all(*numbers: int) -> int:
        total: int = 0
        for num in numbers:
            total += num
        return total
    
    result = sum_all(1, 2, 3) #6
    result = sum_all(1, 2, 3, 4, 5) #15
    result = sum_all() #0
    
    #*args captures arguments as tuple
    def print_args(*args: int) -> None:
        print(type(args)) #<class 'tuple'>
        for arg in args:
            print(arg)
    
    #Combining regular params with *args
    def greet_all(greeting: str, *names: str) -> None:
        for name in names:
            print(f"{greeting}, {name}!")
    
    greet_all("Hello", "Alice", "Bob", "Charlie")
    
    
    #============================================================
    #**KWARGS - Variable keyword arguments
    #============================================================
    
    def print_info(**kwargs: str | int) -> None:
        """Takes any number of keyword arguments"""
        for key, value in kwargs.items():
            print(f"{key}: {value}")
    
    print_info(name="Alice", age=25, city="NYC")
    
    #**kwargs captures arguments as dict
    def show_kwargs(**kwargs: str) -> None:
        print(type(kwargs)) #<class 'dict'>
    
    #Combining all parameter types
    def complex_function(
        required: str,
        default: int = 10,
        *args: int,
        **kwargs: str
    ) -> None:
        pass
    
    #Call order: positional, *args, keyword, **kwargs
    complex_function("hello", 20, 1, 2, 3, name="Alice", city="NYC")
    
    
    #============================================================
    #UNPACKING ARGUMENTS
    #============================================================
    
    def calculate(a: int, b: int, c: int) -> int:
        return a + b + c
    
    #Unpack list/tuple with *
    numbers: list[int] = [1, 2, 3]
    result = calculate(*numbers) #Same as calculate(1, 2, 3)
    
    #Unpack dict with **
    def create_user(name: str, age: int, city: str) -> dict[str, str | int]:
        return {"name": name, "age": age, "city": city}
    
    user_data: dict[str, str | int] = {"name": "Alice", "age": 25, "city": "NYC"}
    user: dict[str, str | int] = create_user(**user_data)
    
    
    #============================================================
    #SCOPE - LEGB Rule (Local, Enclosing, Global, Built-in)
    #============================================================
    
    #Modifying global variable
    count: int = 0
    
    def increment() -> None:
        global count #Declare we're modifying global
        count += 1
    
    def outer_func() -> None:
        counter: int = 0
        
        def inner_func() -> None:
            nonlocal counter #Go one outer layer out
            counter += 1
        
        inner_func()
        print(counter) #1
    
    
    #============================================================
    #DOCSTRINGS
    #============================================================
    
    def calculate_area(length: float, width: float) -> float:
        """
        Calculate the area of a rectangle.
        
        Args:
            length: The length of the rectangle
            width: The width of the rectangle
            
        Returns:
            The area as a float
            
        Raises:
            ValueError: If length or width is negative
        """
        if length < 0 or width < 0:
            raise ValueError("Dimensions must be positive")
        return length * width
    
    #Access docstring
    help(calculate_area) #Shows docstring
    print(calculate_area.__doc__) #Prints docstring


if __name__ == "__main__":
    functions()