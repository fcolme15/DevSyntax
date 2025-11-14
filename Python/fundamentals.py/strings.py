#Covers: creation, indexing, slicing, methods, formatting, f-strings, raw strings

def strings() -> None:
    
    #============================================================
    #CREATING STRINGS
    #============================================================
    
    #Can use single or double quotes
    text1: str = 'Hello'
    text2: str = "World"
    
    #Multi-line strings
    multi: str = """This is
    a multi-line
    string"""
    
    #Escaping characters
    quote: str = "He said \"Hello\""
    path: str = "C:\\Users\\Name" #Backslash needs escaping
    
    #Raw strings r - (ignore escape sequences)
    raw_path: str = r"C:\Users\Name" #No need to escape
    regex: str = r"\d+\.\d+" #Useful for regex patterns
    
    
    #============================================================
    #INDEXING & SLICING
    #============================================================
    
    text: str = "Python"
    
    #Indexing
    first: str = text[0] #First character 'P'
    last: str = text[-1] #Last character 'n'
    
    #Slicing [start:end:step]
    substring: str = text[0:3] #'Pyt'
    substring = text[:3] #'Pyt' - start defaults to 0
    substring = text[3:] #'hon' - end defaults to length
    substring = text[:] #'Python' - full copy
    
    #Step
    every_other: str = text[0:6:2] #'Pto'
    reversed_text: str = text[::-1] #'nohtyP'
    
    
    #============================================================
    #COMMON METHODS
    #============================================================
    
    text = "  Hello World  "
    text2 = "hello world  "
    
    #Case conversion
    upper: str = text.upper() #'  HELLO WORLD  '
    lower: str = text.lower() #'  hello world  '
    title: str = text.title() #'  Hello World  '
    capitalized: str = text.capitalize() #'Hello world  '
    swapped: str = text.swapcase() #'  hELLO wORLD  '
    
    #Whitespace removal
    stripped: str = text.strip() #'Hello World'
    left_strip: str = text.lstrip() #'Hello World  '
    right_strip: str = text.rstrip() #'  Hello World'
    
    #Searching
    index: int = text.find("World") #Returns index or -1 if not found
    index = text.index("World") #Returns index or raises ValueError
    count: int = text.count("l") #Number of occurrences
    starts: bool = text.startswith("  H") #True
    ends: bool = text.endswith("d  ") #True
    
    #Replacement
    replaced: str = text.replace("World", "Python") #'  Hello Python  '
    replaced = text.replace("l", "L", 1) #Replace first occurrence only
    
    #Splitting & joining
    words: list[str] = "apple,banana,cherry".split(",") #['apple', 'banana', 'cherry']
    words = "one two three".split() #Split on whitespace by default
    lines: list[str] = "line1\nline2\nline3".splitlines() #Split on newlines
    
    joined: str = ",".join(["a", "b", "c"]) #'a,b,c'
    joined = " ".join(["Hello", "World"]) #'Hello World'
    
    #Checking content
    is_alpha: bool = "abc".isalpha() #True - all letters
    is_digit: bool = "123".isdigit() #True - all digits
    is_alnum: bool = "abc123".isalnum() #True - letters or digits
    is_space: bool = "   ".isspace() #True - all whitespace
    is_upper: bool = "ABC".isupper() #True
    is_lower: bool = "abc".islower() #True
    
    #Padding & alignment
    centered: str = "Hi".center(10) #'    Hi    '
    left_just: str = "Hi".ljust(10) #'Hi        '
    right_just: str = "Hi".rjust(10) #'        Hi'
    zero_pad: str = "42".zfill(5) #Padd for 5 characters - '00042'
    
    
    #============================================================
    #FORMATTING
    #============================================================
    
    name: str = "Alice"
    age: int = 25
    pi: float = 3.14159
    
    #f-strings (preferred - Python 3.6+)
    message: str = f"My name is {name} and I'm {age} years old"
    message = f"Pi is approximately {pi:.2f}" #2 decimal places
    message = f"{name:>10}" #Right align in 10 chars
    message = f"{age:05d}" #Zero-pad to 5 digits
    
    #.format() method (older style)
    message = "My name is {} and I'm {} years old".format(name, age)
    message = "My name is {0} and I'm {1} years old".format(name, age)
    message = "My name is {n} and I'm {a} years old".format(n=name, a=age)
    
    #% formatting (oldest style - avoid)
    message = "My name is %s and I'm %d years old" % (name, age)
    
    
    #============================================================
    #CONCATENATION & REPETITION & LENGTH
    #============================================================
    
    #Concatenation
    greeting: str = "Hello" + " " + "World" #'Hello World'
    
    #Repetition
    line: str = "-" * 20 #'--------------------'

    #Length - Returns 20
    len: int = len(line)
    
    
    #============================================================
    #SPECIAL CASES
    #============================================================
    
    #Strings are immutable
    text = "Hello"
    #text[0] = "h" #ERROR - cannot modify
    text = "h" + text[1:] #Must create new string: "hello"
    
    #None vs empty string
    value: str | None = None
    if value is None:
        pass
    if value == "":
        pass


if __name__ == "__main__":
    strings()