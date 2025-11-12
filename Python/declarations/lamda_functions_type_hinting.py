#Covers: lambda syntax, common uses, advanced type hints
from typing import Callable #A callable function as a function parameter
from typing import TypeVar #Specify the type for a var, Like T type in C
from typing import Protocol #
from typing import Any #Any datatype
from collections.abc import Iterable #The parameter is iterable
from collections.abc import Sequence #The parameter is a sequence of values
from functools import reduce #Reduce the sequence into a single value
from typing import Literal #The parameter needs to be in the specifed literal

def lambdas() -> None:
    
    #============================================================
    #LAMBDA BASICS
    #============================================================
    
    #Basic syntax: lambda parameters: expression
    add = lambda x, y: x + y
    result: int = add(3, 5)
    
    #No parameters
    get_pi = lambda: 3.14159
    result = get_pi()
    
    #Multiple parameters
    multiply = lambda x, y, z: x * y * z
    result = multiply(2, 3, 4)
    
    #With default arguments
    power = lambda x, exp = 2: x ** exp
    result = power(5)
    result = power(5, 3) 
    
    #Returning tuple
    swap = lambda x, y: (y, x)
    result = swap(1, 2)
    
    #Conditional expression (ternary)
    max_val = lambda x, y: x if x > y else y
    result = max_val(10, 5) #10
    
    
    #============================================================
    #LAMBDA WITH MAP - Apply function to each element and return the list
    #============================================================
    
    numbers: list[int] = [1, 2, 3, 4, 5]
    
    #Double each number
    doubled: list[int] = list(map(lambda x: x * 2, numbers))
    
    #Convert to strings
    strings: list[str] = list(map(lambda x: str(x), numbers))
    
    #Multiple iterables
    list1: list[int] = [1, 2, 3]
    list2: list[int] = [10, 20, 30]
    sums: list[int] = list(map(lambda x, y: x + y, list1, list2))
    
    
    #============================================================
    #LAMBDA WITH FILTER - Keep elements that satisfy condition
    #============================================================
    
    numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    #Get even numbers
    evens: list[int] = list(filter(lambda x: x % 2 == 0, numbers))
    
    #Filter strings by length
    words: list[str] = ["cat", "elephant", "dog", "butterfly"]
    long_words: list[str] = list(filter(lambda w: len(w) > 3, words))
    
    
    #============================================================
    #LAMBDA WITH SORTED - Custom sorting
    #============================================================
    
    #Sort by absolute value
    nums: list[int] = [-5, 2, -8, 1, 9, -3]
    sorted_nums: list[int] = sorted(nums, key=lambda x: abs(x))
    
    #Sort strings by length
    words = ["apple", "pie", "banana", "cherry"]
    sorted_words: list[str] = sorted(words, key=lambda w: len(w))
    
    #Sort tuples by second element
    pairs: list[tuple[str, int]] = [("Alice", 25), ("Bob", 30), ("Charlie", 20)]
    sorted_pairs = sorted(pairs, key=lambda p: p[1])
    
    #Sort dictionaries by value
    scores: dict[str, int] = {"Alice": 85, "Bob": 92, "Charlie": 78}
    sorted_items = sorted(scores.items(), key=lambda item: item[1], reverse=True)
    
    #Multi-level sorting (by age then name)
    people: list[tuple[str, int]] = [
        ("Alice", 25),
        ("Bob", 25),
        ("Charlie", 30)
    ]
    sorted_people = sorted(people, key=lambda p: (p[1], p[0]))
    #[('Alice', 25), ('Bob', 25), ('Charlie', 30)]
    
    
    #============================================================
    #LAMBDA WITH REDUCE - Accumulate values
    #============================================================
    
    numbers = [1, 2, 3, 4, 5]
    
    #Sum all numbers. 
    #The last parameter 100 is the starting value and can be left empty for a default of 0
    total: int = reduce(lambda acc, x: acc + x, numbers, 100)
    
    #Find maximum
    maximum: int = reduce(lambda a, b: a if a > b else b, numbers)
    
    
    #============================================================
    #LAMBDA LIMITATIONS
    #============================================================
    
    #Cannot contain statements (only expressions)
    #bad_lambda = lambda x: print(x) #Works but bad practice
    #bad_lambda = lambda x: if x > 0: return x #Syntax error
    
    #Cannot have multiple lines
    #Multi-line logic should use def function
    
    #Cannot have annotations (type hints) on parameters
    #typed_lambda: Callable[[int], int] = lambda x: x * 2 #Type hint on variable, not lambda





def type_hints() -> None:
    """Demonstrates advanced type hinting patterns"""
    
    #============================================================
    #BASIC TYPE HINTS
    #============================================================
    
    name: str = "Alice"
    age: int = 25
    height: float = 5.8
    is_active: bool = True
    data: None = None
    
    #Collections
    numbers: list[int] = [1, 2, 3]
    coordinates: tuple[int, int] = (10, 20)
    unique_ids: set[str] = {"a", "b", "c"}
    user_data: dict[str, int] = {"age": 25, "score": 100}
    
    #============================================================
    #COMPLEX NESTED TYPES
    #============================================================
    
    #List of dictionaries
    users: list[dict[str, str | int]] = [
        {"name": "Alice", "age": 25},
        {"name": "Bob", "age": 30}
    ]
    
    #Dict of lists
    grades: dict[str, list[int]] = {
        "Alice": [85, 90, 92],
        "Bob": [78, 88, 85]
    }
    
    #Nested collections
    matrix: list[list[int]] = [[1, 2], [3, 4], [5, 6]]
    
    #Dict with tuple keys
    coordinates: dict[tuple[int, int], str] = {
        (0, 0): "origin",
        (1, 0): "right"
    }
    
    #Function returning complex type
    def get_user_scores() -> dict[str, list[tuple[str, int]]]:
        return {
            "Alice": [("Math", 90), ("English", 85)],
            "Bob": [("Math", 85), ("English", 92)]
        }
    

    #============================================================
    #UNION TYPES - Multiple possible types
    #============================================================
    
    #Python 3.10+ syntax (preferred)
    def process(value: int | str | float) -> str:
        return str(value)
    
    #Older syntax (still works)
    from typing import Union
    def process_old(value: Union[int, str]) -> str:
        return str(value)
    
    
    #============================================================
    #OPTIONAL TYPES - Value or None
    #============================================================
    
    #Python 3.10+ syntax
    def find_user(user_id: int) -> str | None:
        if user_id > 0:
            return "Alice"
        return None
    
    #Older syntax
    from typing import Optional
    def find_user_old(user_id: int) -> Optional[str]:
        return "Alice" if user_id > 0 else None
    
    #Multiple optional params
    def create_user(
        name: str,
        email: str | None = None,
        phone: str | None = None
    ) -> dict[str, str | None]:
        return {"name": name, "email": email, "phone": phone}
    
    
    #============================================================
    #CALLABLE - Functions as parameters
    #============================================================
    
    #Basic callable
    def execute(func: Callable[[int], int], value: int) -> int:
        return func(value)
    
    result: int = execute(lambda x: x * 2, 5) 
    
    #Callable with multiple params
    def apply_binary(
        operation: Callable[[int, int], int],
        a: int,
        b: int
    ) -> int:
        return operation(a, b)
    
    result = apply_binary(lambda x, y: x + y, 3, 5)
    
    #Callable with no params
    def run(action: Callable[[], None]) -> None:
        action()
    
    #Callable returning different type
    def transform(
        converter: Callable[[str], int],
        text: str
    ) -> int:
        return converter(text)
    
    result = transform(lambda s: len(s), "hello")
    
    
    #============================================================
    #ANY - Accept any type (avoid when possible)
    #============================================================
    
    def process_anything(data: Any) -> Any:
        return data
    
    
    #============================================================
    #SEQUENCE & ITERABLE - Generic container types
    #============================================================
    
    #Sequence - ordered collection (list, tuple, str)
    def get_first(items: Sequence[int]) -> int:
        return items[0]
    
    #Iterable
    def sum_all(items: Iterable[int]) -> int:
        return sum(items)
    
    
    #============================================================
    #TYPEVAR - Generic types
    #============================================================
    
    T = TypeVar('T') #Generic type variable
    
    #Function that works with any type
    def get_first_generic(items: list[T]) -> T:
        return items[0]
    
    num: int = get_first_generic([1, 2, 3]) #T is int
    word: str = get_first_generic(["a", "b"]) #T is str
    
    #TypeVar with constraints
    NumType = TypeVar('NumType', int, float)
    
    def add_numbers(a: NumType, b: NumType) -> NumType:
        return a + b #type: ignore
    
    result_int: int = add_numbers(1, 2) #Works with int
    result_float: float = add_numbers(1.5, 2.5) #Works with float
    #add_numbers("a", "b") #Type checker error - str not allowed
    
    
    #============================================================
    #PROTOCOL - Structural subtyping (duck typing)
    #============================================================
    
    class Drawable(Protocol):
        def draw(self) -> None: ...
    
    class Circle:
        def draw(self) -> None:
            print("Drawing circle")
    
    class Square:
        def draw(self) -> None:
            print("Drawing square")
    
    #Any class with draw() method works
    def render(shape: Drawable) -> None:
        shape.draw()
    
    render(Circle()) #Works without inheritance
    render(Square()) #Works without inheritance
    
    
    #============================================================
    #TYPE ALIASES - Name complex types
    #============================================================
    
    #Create readable names for complex types
    UserId = int
    UserName = str
    Score = int
    UserScores = dict[UserName, list[Score]]

    Point = tuple[float, float]
    Line = tuple[Point, Point]

    def get_scores() -> UserScores:
        return {"Alice": [90, 85], "Bob": [88, 92]}
    
    
    #============================================================
    #LITERAL TYPES - Specific values only
    #============================================================
    
    def set_mode(mode: Literal["read", "write", "append"]) -> None:
        print(f"Mode: {mode}")
    
    set_mode("read") #OK
    set_mode("write") #OK
    #set_mode("delete") #Type checker error
    
    #With unions
    def process_status(status: Literal["success", "error"] | None) -> None:
        pass


if __name__ == "__main__":
    lambdas()
    type_hints()