function mainSummaryInterfaces() {
    interfacesBasicInterface();
    interfacesFunctionProperties();
}

function interfacesBasicInterface() {
    interface User {
        name: string;
        age: number;
    }

    let user: User = {
        name: "John",
        age: 30
    };

    function printUser(user: User): void {
        console.log(`${user.name}, ${user.age}`);
    }
    
    //Optional and read only example:
    interface Config {
        host: string;
        port?: number; //Optional
        readonly apiKey: string; //Cannot be modified after creation
    }
    //Readonly array
    //data: readonly number[]; //Can't reassing a new list or the list values

    //Interfaces can inherit other interfaces
    interface contact extends User{
        phone: number;
    }

    
}

function interfacesFunctionProperties() {
    interface Calculator {
        add(x: number, y: number): number; //Method signature
        subtract: (x: number, y: number) => number; //Property signature
    }

    let calc: Calculator = {
        add(x, y) {
            return x + y;
        },
        subtract: (x, y) => x - y
    };

    //Function interface (callable)
    interface SearchFunc {
        (source: string, substring: string): boolean;
    }
    let search: SearchFunc = function(source, substring) {
        return source.includes(substring);
    };

    //Same as above
    let search2: (source: string, substring: string) => boolean = function(source, substring) {
        return source.includes(substring);
    };

    //Constructor interface
    interface ClockConstructor {
        new (hour: number, minute: number): ClockInterface;
    }
    interface ClockInterface {
        tick(): void;
    }
    class Clock implements ClockInterface {
        constructor(h: number, m: number) {}
        tick() {
            console.log("tick");
        }
    }
    function createClock(ctor: ClockConstructor, hour: number, minute: number): ClockInterface {
        return new ctor(hour, minute);
    }
}