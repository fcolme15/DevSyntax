function mainSummaryGenerics() {
    genericsBasicGenericFunction();
    genericsGenericClasses();
    genericsGenericConstraints();
    genericsGenericUtilityPatterns();
}

function genericsBasicGenericFunction() {
    //Generic function
    function identity<T>(arg: T): T {
        return arg;
    }

    let num = identity<number>(5);
    let str = identity<string>("hello");
    let auto = identity(42); //Type inference

    //Generic arrow function
    const wrap = <T>(value: T): T[] => [value];

    //fn is a function with item of type T and return something of type U
    function map<T, U>(arr: T[], fn: (item: T) => U): U[] {
        return arr.map(fn);
    }
}

function genericsGenericClasses() {
    //Generic class
    class Box<T> {
        private value: T;

        constructor(value: T) {
            this.value = value;
        }

        getValue(): T {
            return this.value;
        }

        setValue(value: T): void {
            this.value = value;
        }
    }

    //Generic interface
    interface Container<T> {
        value: T;
        getValue(): T;
    }

    //Generic with default type
    interface Response<T = string> {
        data: T;
        status: number;
    }
}

function genericsGenericConstraints() {
    //Constrain to types with length property
    interface HasLength {
        length: number;
    }

    //We know that classes like string/array have a type called length so our interface verifies
    function logLength<T extends HasLength>(arg: T): T {
        console.log(arg.length);
        return arg;
    }

    logLength("hello"); //string has length
    logLength([1, 2, 3]); //array has length
    //logLength(123); //Error: number doesn't have length

    //Constrain to object keys
    function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
        return obj[key];
    }

    let person = { name: "John", age: 30 };
    let name = getProperty(person, "name"); //string
    let age = getProperty(person, "age"); //number
    //let invalid = getProperty(person, "invalid"); //Error

    //Constrain to constructor
    function create<T>(constructor: new () => T): T {
        return new constructor();
    }

    class Person {
        name = "John";
    }

    let p = create(Person);

    //Multiple constraints
    interface Named {
        name: string;
    }
    interface Aged {
        age: number;
    }
    function describe<T extends Named & Aged>(obj: T): string {
        return `${obj.name} is ${obj.age} years old`;
    }
}

function genericsGenericUtilityPatterns() {
    //Generic promise wrapper
    async function fetchData<T>(url: string): Promise<T> {
        const response = await fetch(url);
        return response.json();
    }
    //let user = await fetchData<User>("/api/user");

    //Generic with conditional return type
    function process<T extends string | number>(value: T): T extends string ? string : number {
        if (typeof value === "string") {
            return value.toUpperCase() as any;
        }
        return (2 * (value as number)) as any;
    }
}