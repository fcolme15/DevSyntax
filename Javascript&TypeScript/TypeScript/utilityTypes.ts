function mainSummaryUtilityTypes() {
    utilityTypesPartialAndRequired();
    utilityTypesReadonlyAndRecord();
    utilityTypesPickAndOmit();
    utilityTypesExtractAndExclude();
    utilityTypesReturnTypeAndParameters();
}

function utilityTypesPartialAndRequired() {
    interface User {
        name: string;
        age: number;
        email: string;
    }

    //Partial<T> - makes all properties optional
    type PartialUser = Partial<User>;
    //Equivalent to: { name?: string; age?: number; email?: string; }

    function updateUser(user: User, updates: Partial<User>): User {
        return { ...user, ...updates };
    }

    let user: User = { name: "John", age: 30, email: "john@example.com" };
    let updated = updateUser(user, { age: 31 }); //Only update age

    //Required<T> - makes all properties required
    interface Config {
        host?: string;
        port?: number;
        timeout?: number;
    }

    type RequiredConfig = Required<Config>;
    //Equivalent to: { host: string; port: number; timeout: number; }
}

function utilityTypesReadonlyAndRecord() {
    interface Point {
        x: number;
        y: number;
    }

    //Readonly<T> - makes all properties readonly
    type ReadonlyPoint = Readonly<Point>;
    //Equivalent to: { readonly x: number; readonly y: number; }

    let point: ReadonlyPoint = { x: 10, y: 20 };
    //point.x = 5; //Error: Cannot assign to 'x' because it is a read-only property

    //Record<K, T> - creates object type with keys K and values T
    type Role = "admin" | "user" | "guest";
    type Permissions = Record<Role, string[]>;
    //Equivalent to: { admin: string[]; user: string[]; guest: string[]; }

    let permissions: Permissions = {
        admin: ["read", "write", "delete"],
        user: ["read", "write"],
        guest: ["read"]
    };

    //Record with string keys
    type StringMap = Record<string, number>;
    let scores: StringMap = {
        math: 95,
        science: 88,
        english: 92
    };
}

function utilityTypesPickAndOmit() {
    interface User {
        id: number;
        name: string;
        email: string;
        password: string;
        createdAt: Date;
    }

    //Pick<T, K> - creates type with only specified properties
    type PublicUser = Pick<User, "id" | "name" | "email">;
    //Equivalent to: { id: number; name: string; email: string; }

    //Omit<T, K> - creates type without specified properties
    type UserWithoutPassword = Omit<User, "password">;
    //Equivalent to: { id: number; name: string; email: string; createdAt: Date; }

    type SafeUser = Omit<User, "password" | "createdAt">;
    //Equivalent to: { id: number; name: string; email: string; }
}

function utilityTypesExtractAndExclude() {
    type Status = "pending" | "approved" | "rejected" | "cancelled";

    //Extract<T, U> - extracts types from union that are assignable to U
    type PositiveStatus = Extract<Status, "approved" | "cancelled">;
    //Equivalent to: "approved" | "cancelled"

    //Exclude<T, U> - removes types from union that are assignable to U
    type ActiveStatus = Exclude<Status, "cancelled" | "rejected">;
    //Equivalent to: "pending" | "approved"

    //With function types
    type AllTypes = string | number | (() => void);
    type NonFunction = Exclude<AllTypes, Function>;
    //Equivalent to: string | number

    //NonNullable<T> - removes null and undefined
    type MaybeString = string | null | undefined;
    type DefiniteString = NonNullable<MaybeString>;
    //Equivalent to: string
}

function utilityTypesReturnTypeAndParameters() {
    //ReturnType<T> - extracts function return type
    function getUser() {
        return { id: 1, name: "John", age: 30 };
    }

    type User = ReturnType<typeof getUser>;
    //Equivalent to: { id: number; name: string; age: number; }

    type MapReturnType = ReturnType<typeof Array.prototype.map>;
    //Type of what .map() returns

    //Parameters<T> - extracts function parameter types as tuple
    function createPost(title: string, content: string, published: boolean) {
        return { title, content, published };
    }

    type CreatePostParams = Parameters<typeof createPost>;
    //Equivalent to: [title: string, content: string, published: boolean]

    //Use spread to call function
    let params: CreatePostParams = ["Title", "Content", true];
    createPost(...params);

    //ConstructorParameters<T> - extracts constructor parameter types
    class Person {
        constructor(public name: string, public age: number) {}
    }

    type PersonParams = ConstructorParameters<typeof Person>;
    //Equivalent to: [name: string, age: number]

    //InstanceType<T> - extracts instance type from constructor
    type PersonInstance = InstanceType<typeof Person>;
    //Equivalent to: Person

    //Awaited<T> - unwraps Promise type
    type PromiseNumber = Promise<number>;
    type UnwrappedNumber = Awaited<PromiseNumber>;
    //Equivalent to: number

    type NestedPromise = Promise<Promise<string>>;
    type UnwrappedString = Awaited<NestedPromise>;
    //Equivalent to: string
}