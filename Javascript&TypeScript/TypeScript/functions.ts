function mainSummaryFunctions() {
    functionsBasicSyntax();
    functionsFunctionOverloads();
    functionsThisParameter();
    functionsRestAndSpread();
}

//TypeScript-specific function features (not in javascript):
//- Type annotations for parameters and return types
//- Function overloads (multiple type signatures)
//- Explicit 'this' parameter typing
//- never return type (function never returns)
//- void return type enforcement

function functionsBasicSyntax() {
    //Function declaration
    function add(x: number, y: number): number {
        return x + y;
    }

    //Function expression
    let multiply = function(x: number, y: number): number {
        return x * y;
    };

    //Arrow function
    let subtract = (x: number, y: number): number => x - y;

    //Optional parameters
    function greet(name: string, greeting?: string): string {
        return `${greeting || "Hello"}, ${name}`;
    }

    //Default parameters
    function power(base: number, exponent: number = 2): number {
        return Math.pow(base, exponent);
    }

    //Rest parameters
    function sum(...numbers: number[]): number {
        return numbers.reduce((a, b) => a + b, 0);
    }

    //Return type void
    function log(message: string): void {
        console.log(message);
    }

    //Return type never (never returns)
    function throwError(message: string): never {
        throw new Error(message);
    }
}

function functionsFunctionOverloads() {
    //They are needed because it will work with only the implementation signature but then 
    //typescript will allow bad calls like say you want 1 param or 3 params without signatures 
    //and only signature then 2 params would be allowed and with overload signatures then it is not

    //Overload signatures
    function process(value: string): string;
    function process(value: number): number;
    function process(value: boolean): string;
    //Implementation signature
    function process(value: string | number | boolean): string | number {
        if (typeof value === "string") {
            return value.toUpperCase();
        } else if (typeof value === "number") {
            return value * 2;
        } else {
            return value.toString();
        }
    }

    let s = process("hello"); //string
    let n = process(5); //number
    let b = process(true); //string

    //Overload with different parameter counts
    function makeDate(timestamp: number): Date;
    function makeDate(year: number, month: number, day: number): Date;
    function makeDate(yearOrTimestamp: number, month?: number, day?: number): Date {
        if (month !== undefined && day !== undefined) {
            return new Date(yearOrTimestamp, month, day);
        } else {
            return new Date(yearOrTimestamp);
        }
    }
}

function functionsThisParameter() {
    //Explicit this parameter (not a real parameter)
    interface User {
        name: string;
    }

    function greet(this: User, greeting: string): string {
        return `${greeting}, ${this.name}`;
    }

    let user = { name: "John" };
    greet.call(user, "Hello"); //"Hello, John"

    //Arrow functions don't have their own this
    interface Handler {
        onClick(this: void): void; //this is void, can't use this
    }

    let handler: Handler = {
        onClick: () => {
            //this refers to lexical scope, not the object
        }
    };
}

function functionsRestAndSpread() {
    //Rest parameters - gather arguments into array
    function concatenate(...strings: string[]): string {
        return strings.join(" ");
    }

    concatenate("Hello", "world"); //"Hello world"
    concatenate("a", "b", "c", "d"); //"a b c d"

    //Spread arguments - pass array as individual arguments
    function add(x: number, y: number, z: number): number {
        return x + y + z;
    }

    let numbers: [number, number, number] = [1, 2, 3];
    add(...numbers); //Same as add(1, 2, 3)

    //Rest with other parameters
    function log(message: string, ...tags: string[]): void {
        console.log(message, tags);
    }

    log("Error", "critical", "database"); //"Error" ["critical", "database"]
}