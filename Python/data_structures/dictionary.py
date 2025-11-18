#Covers: dict creation, methods, defaultdict, Counter, OrderedDict

from collections import defaultdict, Counter, OrderedDict

def dict_basics() -> None:
    
    #============================================================
    #CREATION
    #============================================================
    
    #Empty dict
    empty: dict = {}
    empty = dict()
    
    #Initialized dict
    person: dict[str, int | str] = {"name": "Alice", "age": 25, "city": "NYC"}
    
    #Dict comprehension
    squares: dict[int, int] = {x: x**2 for x in range(5)} #{0: 0, 1: 1, 2: 4, 3: 9, 4: 16}
    
    
    #============================================================
    #ACCESSING ELEMENTS
    #============================================================
    
    person = {"name": "Alice", "age": 25, "city": "NYC"}
    
    #Access by key
    name: str = person["name"] #"Alice"
    #value = person["missing"] #KeyError
    
    #Get with default
    age: int = person.get("age")
    country: str | None = person.get("country") #Returns None (no error)
    country = person.get("country", "USA") #"USA" (custom default)
    
    
    #============================================================
    #ADDING/MODIFYING
    #============================================================
    
    person = {"name": "Alice", "age": 25}
    
    #Add or update key
    person["city"] = "NYC" #{"name": "Alice", "age": 25, "city": "NYC"}
    person["age"] = 26 #Updates existing key
    
    #Update multiple keys
    person.update({"age": 27, "country": "USA"})
    
    #Setdefault - add key only if doesn't exist
    person.setdefault("name", "Bob") #"Alice" (key exists, no change)
    person.setdefault("job", "Engineer") #Adds "job": "Engineer"
    
    
    #============================================================
    #REMOVING ELEMENTS
    #============================================================
    
    person = {"name": "Alice", "age": 25, "city": "NYC"}
    
    #Pop - remove and return value
    age: int = person.pop("age") #25, removes "age" key
    #value = person.pop("missing") #KeyError
    value = person.pop("missing", None) #None (default if key missing)
    
    #Delete key
    del person["city"]
    
    #Clear all
    person.clear() #{}
    
    
    #============================================================
    #CHECKING KEYS
    #============================================================
    
    person = {"name": "Alice", "age": 25}
    
    #Check if key exists
    exists: bool = "name" in person #True
    exists = "city" not in person #True
    
    
    #============================================================
    #ITERATING
    #============================================================
    
    person = {"name": "Alice", "age": 25, "city": "NYC"}
    
    #Iterate keys (default)
    for key in person:
        print(key) #name, age, city
    
    #Iterate keys explicitly
    for key in person.keys():
        print(key)
    
    #Iterate values
    for value in person.values():
        print(value) #Alice, 25, NYC
    
    #Iterate key-value pairs
    for key, value in person.items():
        print(f"{key}: {value}")
    
    
    #============================================================
    #OTHER METHODS
    #============================================================
    
    person = {"name": "Alice", "age": 25}
    
    #Copy
    copy: dict = person.copy()
    
    #Length
    length: int = len(person) 


def defaultdict_usage() -> None:
    
    #============================================================
    #DEFAULTDICT WITH LIST
    #============================================================
    
    #Regular dict - need to check if key exists
    groups: dict[str, list[str]] = {}
    if "A" not in groups:
        groups["A"] = []
    groups["A"].append("Alice")
    
    #With defaultdict - automatic default
    groups = defaultdict(list) #Automatically creates empty list
    groups["A"].append("Alice") 
    groups["A"].append("Andy")
    groups["B"].append("Bob")
    #Result: {'A': ['Alice', 'Andy'], 'B': ['Bob']}
    
    #Common use: group items
    words: list[str] = ["apple", "banana", "apricot", "blueberry", "avocado"]
    grouped: defaultdict[str, list[str]] = defaultdict(list)
    for word in words:
        grouped[word[0]].append(word)
    #Result: {'a': ['apple', 'apricot', 'avocado'], 'b': ['banana', 'blueberry']}
    
    
    #============================================================
    #DEFAULTDICT WITH INT (counting)
    #============================================================
    
    #Count occurrences
    counts: defaultdict[str, int] = defaultdict(int) #Default value is 0
    text: str = "hello"
    for char in text:
        counts[char] += 1 #No need to check if key exists
    #Result: {'h': 1, 'e': 1, 'l': 2, 'o': 1}
    
    
    #============================================================
    #DEFAULTDICT WITH SET
    #============================================================
    
    #Group unique items
    groups_set: defaultdict[str, set[str]] = defaultdict(set)
    groups_set["vowels"].add("a")
    groups_set["vowels"].add("e")
    groups_set["vowels"].add("a") #Duplicate ignored (set behavior)
    #Result: {'vowels': {'a', 'e'}}




if __name__ == "__main__":
    print("=== Dict Basics ===")
    dict_basics()
    
    print("\n=== DefaultDict ===")
    defaultdict_usage()