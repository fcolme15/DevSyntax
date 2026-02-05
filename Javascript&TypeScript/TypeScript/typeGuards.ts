//TYPE GUARDS - Runtime type checking and narrowing

function mainSummaryTypeGuards() {
    typeGuardsBuiltInGuards();
    typeGuardsCustomTypeGuards();
    typeGuardsDiscriminatedUnions();
}

function typeGuardsBuiltInGuards() {
    //typeof - for primitives
    function process(value: string | number) {
        if (typeof value === "string") {
            return value.toUpperCase();
        } else {
            return value * 2;
        }
    }
    //typeof works with: "string", "number", "boolean", "symbol", "undefined", "object", "function"

    //instanceof - for classes
    class Dog {
        bark() {}
    }
    class Cat {
        meow() {}
    }

    function makeSound(animal: Dog | Cat) {
        if (animal instanceof Dog) {
            animal.bark();
        } else {
            animal.meow();
        }
    }

    //in operator - check if property exists
    type Response = { data: string } | { error: string };
    function handleResponse(response: Response) {
        if ("data" in response) {
            console.log(response.data);
        } else {
            console.log(response.error);
        }
    }
}

function typeGuardsDiscriminatedUnions() {
    //Union with common discriminant property
    type Shape =
        | { kind: "circle"; radius: number }
        | { kind: "rectangle"; width: number; height: number }
        | { kind: "square"; size: number };

    function area(shape: Shape): number {
        switch (shape.kind) {
            case "circle":
                return Math.PI * shape.radius ** 2;
            case "rectangle":
                return shape.width * shape.height;
            case "square":
                return shape.size ** 2;
        }
    }
}

function typeGuardsCustomTypeGuards() {
    //For when we dont know if its of a cetain interface but we would like to verify to the
    //best of our ability. Discriminant property is prefered.
    //Type predicate: value is Type
    interface User {
        id: number;
        name: string;
    }

    function isUser(obj: any): obj is User {
        return (
            typeof obj === "object" &&
            obj !== null &&
            typeof obj.id === "number" &&
            typeof obj.name === "string"
        );
    }

    function processData(data: unknown) {
        if (isUser(data)) {
            console.log(data.name); //data is User here
        }
    }
}