function mainSummaryEnums() {
    enumsNumericEnums();
    enumsStringEnums();
    enumsHeterogeneousEnums();
    enumsConstEnums();
}

function enumsNumericEnums() {
    //Default - starts at 0, auto-increments
    enum Direction {
        Up,    //0
        Down,  //1
        Left,  //2
        Right  //3
    }

    let dir: Direction = Direction.Up;
    console.log(dir); //0

    //Custom starting value
    enum Status {
        Pending = 1,
        Approved,  //2
        Rejected   //3
    }

    //All custom values
    enum HttpStatus {
        OK = 200,
        NotFound = 404,
        ServerError = 500
    }

    //Reverse mapping (numeric enums only)
    console.log(Direction[0]); //"Up"
    console.log(Direction.Up); //0
}

function enumsStringEnums() {
    //Must initialize all members
    enum Color {
        Red = "RED",
        Green = "GREEN",
        Blue = "BLUE"
    }

    let color: Color = Color.Red;
    console.log(color); //"RED"

    //No reverse mapping for string enums
    //console.log(Color["RED"]); //Undefined

    //Used for type-safe string constants
    enum LogLevel {
        Error = "ERROR",
        Warning = "WARNING",
        Info = "INFO",
        Debug = "DEBUG"
    }

    function log(level: LogLevel, message: string): void {
        console.log(`[${level}] ${message}`);
    }

    log(LogLevel.Error, "Something went wrong");
}

function enumsHeterogeneousEnums() {
    //Mix of string and numeric (not recommended)
    enum Mixed {
        No = 0,
        Yes = "YES"
    }

    //Computed members
    enum FileAccess {
        None = 0,
        Read = 1 << 0,     //1
        Write = 1 << 1,    //2
        ReadWrite = Read | Write  //3
    }

    let access: FileAccess = FileAccess.ReadWrite;
}

function enumsConstEnums() {
    //Const enums are inlined at compile time
    const enum Size {
        Small,
        Medium,
        Large
    }

    let size = Size.Medium; //Compiled to: let size = 1;

    //No reverse mapping, more efficient
    //console.log(Size[1]); //Error in const enum

    //When to use:
    //Regular enum: Need runtime object and reverse mapping
    //Const enum: Only need compile-time constants, more efficient
}