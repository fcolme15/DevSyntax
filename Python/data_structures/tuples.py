#Covers: tuple creation, operations, immutability, namedtuple

from collections import namedtuple

def tuple_basics() -> None:
    
    #============================================================
    #CREATION
    #============================================================
    
    #Empty tuple
    empty: tuple = ()
    empty = tuple()
    
    #Single element tuple
    single: tuple[int] = (5,) #Comma required
    not_tuple: int = (5) #This is just an int, not a tuple
    
    #Multiple elements
    nums: tuple[int, int, int] = (10, 20, 30, 40, 50)
    mixed: tuple = (1, "hello", 3.14, True)
    
    #Without parentheses (tuple packing)
    coords: tuple[int, int] = 10, 20
    
    #From list
    lst: list[int] = [1, 2, 3]
    tup: tuple[int, ...] = tuple(lst)
    
    
    #============================================================
    #INDEXING AND SLICING
    #============================================================
    
    #Indexing - Like lists
    first: int = nums[0] #10
    last: int = nums[-1] #50
    
    #Slicing
    subset: tuple[int, ...] = nums[1:4] #(20, 30, 40)
    subset = nums[:3] #(10, 20, 30)
    subset = nums[::2] #(10, 30, 50)
    
    
    #============================================================
    #IMMUTABILITY
    #============================================================
    
    #Cannot modify
    #nums[0] = 99 #TypeError - tuples are immutable
    #nums.append(4) #AttributeError - no append method
    
    #Can reassign entire tuple
    nums = (4, 5, 6) #Creates new tuple
    
    
    #============================================================
    #TUPLE METHODS (only 2)
    #============================================================
    
    nums = (1, 2, 3, 2, 4, 2)
    
    #Count occurrences
    count: int = nums.count(2) #3
    
    #Find index
    idx: int = nums.index(2) #1 (first occurrence)
    #idx = nums.index(99) #ValueError if not found
    
    
    #============================================================
    #TUPLE UNPACKING
    #============================================================
    
    #Basic unpacking
    point: tuple[int, int] = (10, 20)
    x: int
    y: int
    x, y = point #x=10, y=20
    
    #Multiple values
    person: tuple[str, int, str] = ("Alice", 25, "NYC")
    name: str
    age: int
    city: str
    name, age, city = person
    
    #Swap values using tuple unpacking
    a: int = 1
    b: int = 2
    a, b = b, a #a=2, b=1
    
    #Extended unpacking with *
    nums = (1, 2, 3, 4, 5)
    first, *middle, last = nums #first=1, middle=[2,3,4], last=5
    
    first, *rest = nums #first=1, rest=[2,3,4,5]
    *most, last = nums #most=[1,2,3,4], last=5
    
    
    #============================================================
    #COMMON OPERATIONS
    #============================================================
    
    tuple1: tuple[int, ...] = (1, 2, 3)
    tuple2: tuple[int, ...] = (4, 5, 6)
    
    #Concatenation
    combined: tuple[int, ...] = tuple1 + tuple2 #(1, 2, 3, 4, 5, 6)
    
    #Repetition
    repeated: tuple[int, ...] = tuple1 * 3 #(1, 2, 3, 1, 2, 3, 1, 2, 3)
    
    #Length
    length: int = len(tuple1) #3
    
    #Membership
    exists: bool = 2 in tuple1 #True
    
    #Min/max/sum (for numeric tuples)
    minimum: int = min(tuple1) #1
    maximum: int = max(tuple1) #3
    total: int = sum(tuple1) #6
    
    #Sorted - returns a list
    sorted_list: list[int] = sorted((3, 1, 4, 1, 5))


def namedtuple_usage() -> None:
    
    #============================================================
    #CREATING NAMEDTUPLE
    #============================================================
    
    #Define namedtuple type
    Point = namedtuple('Point', ['x', 'y'])
    
    #Alternative syntax with string
    Point = namedtuple('Point', 'x y') #Only space separated
    Point = namedtuple('Point', 'x, y') #Comma separated
    
    #Create instances
    p1: Point = Point(10, 20)
    p2: Point = Point(x=30, y=40)
    
    
    #============================================================
    #ACCESSING FIELDS
    #============================================================
    
    p: Point = Point(10, 20)
    
    #By name
    x: int = p.x 
    y: int = p.y
    
    #By index 
    x = p[0] 
    y = p[1] 
    
    #Unpacking
    x, y = p
    
    
    #============================================================
    #NAMEDTUPLE METHODS
    #============================================================
    
    p = Point(10, 20)
    
    #Convert to dict
    d: dict[str, int] = p._asdict() #{'x': 10, 'y': 20}
    
    #Replace values - creates new namedtuple
    p2: Point = p._replace(x=30) #Point(x=30, y=20)
    
    #Get fields
    fields: tuple[str, ...] = Point._fields #('x', 'y')


if __name__ == "__main__":
    print("=== Tuple Basics ===")
    tuple_basics()
    
    print("\n=== NamedTuple ===")
    namedtuple_usage()