#Covers: if/elif/else, ternary, match/case, comparison operators, logical operators, identity, membership

def control_flow() -> None:
    
    #============================================================
    #IF STATEMENTS
    #============================================================
    
    score: int = 85
    
    #Basic if
    if score >= 90:
        grade: str = "A"
    
    #if-else
    if score >= 60:
        status: str = "Pass"
    else:
        status = "Fail"
    
    #if-elif-else
    if score >= 90:
        grade = "A"
    elif score >= 80:
        grade = "B"
    elif score >= 70:
        grade = "C"
    elif score >= 60:
        grade = "D"
    else:
        grade = "F"
    
    
    #============================================================
    #TERNARY OPERATOR - One-line if-else
    #============================================================
    
    grade = "A" if score >= 90 else "B"
    
    #Can be nested
    grade = "A" if score >= 90 else "B" if score >= 80 else "C"
    
    
    #============================================================
    #MATCH/CASE(switch statement) - Python 3.10+
    #============================================================
    
    #String match 
    command: str = "start"
    match command:
        case "start":
            action: str = "Starting..."
        case "stop":
            action = "Stopping..."
        case "pause":
            action = "Pausing..."
        case _: #Default case
            action = "Unknown command"
    
    #Tuple match
    point: tuple[int, int] = (0, 5)
    match point:
        case (0, 0):
            location: str = "Origin"
        case (0, y):
            location = f"Y-axis at {y}"
        case (x, 0):
            location = f"X-axis at {x}"
        case (x, y):
            location = f"Point at ({x}, {y})"
    
    #Match with conditions
    age = 25
    match age:
        case n if n < 0:
            category: str = "Invalid"
        case n if n < 18:
            category = "Minor"
        case n if n < 65:
            category = "Adult"
        case _:
            category = "Senior"

def operators() -> None:

    #============================================================
    #COMPARISON OPERATORS
    #============================================================
    
    x: int = 10
    y: int = 5
    
    result: bool = (x == y) #Equal to
    result = (x != y) #Not equal to
    result = (x > y) #Greater than
    result = (x < y) #Less than
    result = (x >= y) #Greater than or equal to
    result = (x <= y) #Less than or equal to
    
    
    #============================================================
    #LOGICAL OPERATORS
    #============================================================
    
    a: bool = True
    b: bool = False
    
    result = (a and b) #Both must be True
    result = (a or b) #At least one must be True
    result = (not a) #Negation
    
    
    #============================================================
    #IDENTITY OPERATORS - Check if same object in memory
    #============================================================
    
    list1: list[int] = [1, 2, 3]
    list2: list[int] = [1, 2, 3]
    list3: list[int] = list1
    
    result = (list1 is list2) #False - different objects
    result = (list1 is None) #False it doesn't have value of None
    result = (list1 is not list2) #True

    
    #============================================================
    #MEMBERSHIP OPERATORS
    #============================================================
    
    fruits: list[str] = ["apple", "banana", "cherry"]
    
    result = "apple" in fruits #True
    result = "grape" not in fruits #True
    
    #Works with strings
    text: str = "hello world"
    result = "world" in text #True
    
    #Works with dictionaries (checks keys)
    person: dict[str, int] = {"name": "Alice", "age": 25}
    result = "name" in person #True


if __name__ == "__main__":
    operators()
    control_flow()