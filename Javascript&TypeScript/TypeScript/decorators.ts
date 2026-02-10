function mainSummaryDecorators() {
    decoratorsClassDecorators();
    decoratorsMethodDecorators();
    decoratorsPropertyDecorators();
    decoratorsParameterDecorators();
}

//DECORATORS - Metadata and code modification (experimental feature)
//Enable with: "experimentalDecorators": true in tsconfig.json
//
//What decorators are:
//Functions that modify or attach metadata to classes, methods, properties, or parameters
//Syntax: @decoratorName above the target (similar to Java annotations)
//
//Common uses:
//- Frameworks: Angular uses decorators heavily (@Component, @Injectable, etc.)
//- Logging: Automatically log method calls without changing method code
//- Validation: Mark parameters/properties for automatic validation
//- Caching: Store method results to avoid re-computation
//- Access control: Check permissions before method execution
//- Metadata: Attach information for reflection or dependency injection
//
//Execution: Decorators run at class definition time (when code loads), not when methods are called
//Order: Multiple decorators execute bottom-to-top
//
//Note: Experimental feature - syntax may change. Widely used in frameworks like Angular and NestJS.

function decoratorsClassDecorators() {
    //Class decorator - modifies or replaces class
    function sealed(constructor: Function) {
        Object.seal(constructor);
        Object.seal(constructor.prototype);
    }

    //@sealed
    class Greeter {
        greeting: string;
        constructor(message: string) {
            this.greeting = message;
        }
    }

    //Decorator factory - returns decorator with parameters
    function logged(prefix: string) {
        return function(constructor: Function) {
            console.log(`${prefix}: ${constructor.name}`);
        };
    }

    //@logged("Created")
    class User {
        constructor(public name: string) {}
    }

    //Class decorator that replaces constructor
    //Adds a created at date property
    function timestamp<T extends { new(...args: any[]): {} }>(constructor: T) {
        return class extends constructor {
            createdAt = new Date();
        };
    }

    //@timestamp
    class Document {
        constructor(public title: string) {}
    }
}

function decoratorsMethodDecorators() {
    //Method decorator - modifies method
    function enumerable(value: boolean) {
        return function(target: any, propertyKey: string, descriptor: PropertyDescriptor) {
            descriptor.enumerable = value;
        };
    }

    class Person {
        constructor(public name: string) {}

        //@enumerable(false)
        greet() {
            return `Hello, ${this.name}`;
        }
    }

    //Log method calls
    function log(target: any, propertyKey: string, descriptor: PropertyDescriptor) {
        const originalMethod = descriptor.value;
        descriptor.value = function(...args: any[]) {
            console.log(`Calling ${propertyKey} with`, args);
            return originalMethod.apply(this, args);
        };
    }

    class Calculator {
        //@log
        add(x: number, y: number): number {
            return x + y;
        }
    }
}

function decoratorsPropertyDecorators() {
    //Property decorator
    function format(formatString: string) {
        return function(target: any, propertyKey: string) {
            let value: string;

            const getter = () => value;
            const setter = (newVal: string) => {
                value = `${formatString}${newVal}`;
            };

            Object.defineProperty(target, propertyKey, {
                get: getter,
                set: setter,
                enumerable: true,
                configurable: true
            });
        };
    }

    class Greeter {
        //@format("Hello, ")
        greeting: string;

        constructor(message: string) {
            this.greeting = message;
        }
    }

    //Readonly decorator
    function readonly(target: any, propertyKey: string) {
        Object.defineProperty(target, propertyKey, {
            writable: false
        });
    }

    class Config {
        //@readonly
        apiKey: string = "secret";
    }
}

function decoratorsParameterDecorators() {
    //Parameter decorator - metadata about parameters
    function required(target: any, propertyKey: string, parameterIndex: number) {
        console.log(`Parameter ${parameterIndex} in ${propertyKey} is required`);
    }

    class User {
        greet(/*@required*/ name: string) {
            return `Hello, ${name}`;
        }
    }

    //Validation decorator
    function validate(target: any, propertyKey: string, parameterIndex: number) {
        //Store metadata about which parameters need validation
        //Used with method decorator to perform actual validation
    }

    //DECORATOR ORDER
    //Multiple decorators execute bottom-to-top
    //@first
    //@second
    //method() {} //second executes first, then first
}