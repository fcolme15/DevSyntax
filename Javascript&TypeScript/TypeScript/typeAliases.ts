function mainSummaryAliases() {
    aliasesTypeAlias();
    aliasesFunctionTypes();
    aliasesTupleTypes();
    aliasesMappedTypes();
    aliasesConditionalTypes();
}

function aliasesTypeAlias() {
    //Primitive aliases
    type ID = string | number;
    type Age = number;
    type IsActive = boolean;

    let userId: ID = "abc123";
    userId = 456;

    //Literal union
    type Status = "active" | "inactive" | "pending";
    let status: Status = "active";
    
    //Object types
    type User = {
        name: string;
        age: number;
        email?: string;
    };

    //Union
    type StringOrNumber = string | number;
    type Result = "success" | "error";
    type Response = { data: string } | { error: string };

    //Discriminated unions
    type Shape =
        | { kind: "circle"; radius: number }
        | { kind: "rectangle"; width: number; height: number }
        | { kind: "square"; size: number };

    //Intersection
    type Person = {
        name: string;
        age: number;
    };

    type Employee = {
        employeeId: number;
        department: string;
    };

    type Worker = Person & Employee;
}

function aliasesFunctionTypes() {
    type MathOp = (x: number, y: number) => number;

    let add: MathOp = (x, y) => x + y;
    let multiply: MathOp = (x, y) => x * y;

    //Generic function type
    type Mapper<T, U> = (value: T) => U;

    let toString: Mapper<number, string> = (n) => n.toString();
    let toNumber: Mapper<string, number> = (s) => parseInt(s);

    //Constructor type
    type Constructor<T> = new (...args: any[]) => T;

    class Person {
        constructor(public name: string) {}
    }

    function create<T>(ctor: Constructor<T>, ...args: any[]): T {
        return new ctor(...args);
    }
}

function aliasesTupleTypes() {
    type Coordinate = [number, number];
    type RGB = [number, number, number];
    type Response = [number, string]; //Status code and message

    let point: Coordinate = [10, 20];
    let color: RGB = [255, 0, 128];
    let response: Response = [200, "OK"];

    //Optional elements
    type Point3D = [number, number, number?];
    let point2D: Point3D = [10, 20];
    let point3D: Point3D = [10, 20, 30];

    //Rest elements
    type StringNumberBooleans = [string, number, ...boolean[]];
    let data: StringNumberBooleans = ["hello", 42, true, false, true];

    //Named tuples
    type Range = [start: number, end: number];
    let range: Range = [0, 100];
}

function aliasesMappedTypes() {
    //Make all properties optional
    type Partial<T> = {
        [P in keyof T]?: T[P];
    };

    type User = {
        name: string;
        age: number;
        email: string;
    };

    type PartialUser = Partial<User>;
    //Equivalent to: { name?: string; age?: number; email?: string; }


    //Make all properties readonly
    type Readonly<T> = {
        readonly [P in keyof T]: T[P];
    };

    type ReadonlyUser = Readonly<User>;

    //Pick specific properties
    //How it works:
    //T = User
    //K = "name" | "email"
    //For P = "name": T["name"] = string
    //For P = "email": T["email"] = string
    type Pick<T, K extends keyof T> = {
        [P in K]: T[P];
    };

    type UserSummary = Pick<User, "name" | "email">;
    
    //Equivalent to: { name: string; email: string; }

    //Custom mapped type
    type Getters<T> = {
        [P in keyof T as `get${Capitalize<string & P>}`]: () => T[P];
    };

    type UserGetters = Getters<User>;
    //Equivalent to: { getName: () => string; getAge: () => number; getEmail: () => string; }
}

function aliasesConditionalTypes() {
    //Basic conditional
    type IsString<T> = T extends string ? true : false;

    type A = IsString<string>; //true
    type B = IsString<number>; //false

    //Extracting types
    type TypeName<T> =
        T extends string ? "string" :
        T extends number ? "number" :
        T extends boolean ? "boolean" :
        T extends undefined ? "undefined" :
        T extends Function ? "function" :
        "object";

    type T1 = TypeName<string>; //"string"
    type T2 = TypeName<42>; //"number"

    //Infer keyword
    type ReturnType<T> = T extends (...args: any[]) => infer R ? R : never;

    type Func = () => number;
    type R = ReturnType<Func>; //number

    //Distributive conditional types
    type ToArray<T> = T extends any ? T[] : never;
    type StrOrNumArray = ToArray<string | number>; //string[] | number[]
}