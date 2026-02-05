//TYPE ANNOTATIONS - Basic type system syntax

function mainSummaryAnnotations() {
    annotationsPrimitiveTypes();
    annotationsArrayTypes();
    annotationsObjectTypes();
    annotationsFunctionTypes();
    annotationsLiteralTypes();
    annotationsTypeAssertion();
}

function annotationsPrimitiveTypes() {
    let isDone: boolean = false;
    let age: number = 25;
    let firstName: string = "John";
    let notSure: any = 4; //Opt out of type checking
    let unused: unknown = 4; //Type-safe any, requires type checking before use
    let nothing: void = undefined; //Function returns nothing
    let neverReturns: never; //Function never returns (throws or infinite loop)
    
    //Union: value can be one of multiple types
    let id: number | string;
    id = 123;
    id = "ABC123";

    function printId(id: number | string) {
        if (typeof id === "string") {
            console.log(id.toUpperCase());
        } else {
            console.log(id);
        }
    }

    //Intersection: combines multiple types
    type Person = { name: string };
    type Employee = { employeeId: number };
    type Worker = Person & Employee;

    let worker: Worker = {
        name: "John",
        employeeId: 123
    };
}

function annotationsArrayTypes() {
    let numbers: number[] = [1, 2, 3];
    let strings: Array<string> = ["a", "b", "c"]; //Generic array type
    let matrix: number[][] = [[1, 2], [3, 4]];
    let mixed: (number | string)[] = [1, "two", 3];
}

function annotationsObjectTypes() {
    //Inline object type
    let user: { name: string; age: number } = {
        name: "John",
        age: 30
    };

    //Optional properties
    let config: { host: string; port?: number } = {
        host: "localhost"
    };

    //Readonly properties
    let point: { readonly x: number; readonly y: number } = {
        x: 10,
        y: 20
    };
    //point.x = 5; //Error: Cannot assign to 'x' because it is a read-only property

    //Index signatures
    let scores: { [key: string]: number } = {
        math: 95,
        science: 88
    };
}

function annotationsFunctionTypes() {
    //Function declaration with annotations
    function add(x: number, y: number): number {
        return x + y;
    }

    //Function expression
    let multiply: (x: number, y: number) => number = function(x, y) {
        return x * y;
    };

    //Arrow function
    let subtract = (x: number, y: number): number => x - y;

    //Optional and default parameters
    function greet(name: string = "No Name", greeting?: string): string {
        return `${greeting || "Hello"}, ${name}`;
    }

    //Rest parameters
    function sum(...numbers: number[]): number {
        return numbers.reduce((a, b) => a + b, 0);
    }
}

function annotationsLiteralTypes() {
    //String literals
    let direction: "north" | "south" | "east" | "west";
    direction = "north";
    //direction = "up"; //Error: Type '"up"' is not assignable

    //Numeric literals
    let diceRoll: 1 | 2 | 3 | 4 | 5 | 6;
    diceRoll = 3;

    //Boolean literals
    let isTrue: true = true;
    //let isFalse: true = false; //Error

    //Mixed literals
    type Status = "success" | "error" | 200 | 404;
    let result: Status = "success";
    result = 200;
}

function annotationsTypeAssertion() {
    let someValue: unknown = "this is a string";
    let strLength: number = (someValue as string).length;

    //Const assertion (makes properties readonly and literal)
    let config = {
        host: "localhost",
        port: 8080
    } as const;
    //config.port = 3000; //Error: Cannot assign to 'port' because it is a read-only property
}