func accessControlOverview() {
    accessLevels()
    accessOnTypes()
    accessOnMembers()
    gettersAndSetters()
}


func accessLevels() {
    //Swift has 5 access levels, from most to least restrictive:

    //open - accessible and subclassable/overridable from any module
    //Only applies to classes and class members
    //Use when building a framework and intending external subclassing

    //public - accessible from any module, but cannot subclass/override externally
    //Use when building a framework and exposing API without allowing overrides

    //internal - accessible anywhere within the same module (default if nothing specified)
    //A module is an app target or framework - most code you write is internal

    //fileprivate - accessible only within the same .swift file
    //Useful when multiple types in one file need to share implementation details

    //private - accessible only within the enclosing declaration and its extensions in same file
    //Most restrictive, use for implementation details of a single type
}


func accessOnTypes() {
    //Access level of a type limits the maximum access of its members
    //A public type can have internal, fileprivate, or private members
    //An internal type cannot have public members - would be inaccessible anyway

    public class PublicClass { //Accessible from any module
        public var publicProp = 0 //Accessible from any module
        internal var internalProp = 0 //Default - accessible within module
        fileprivate var fileProp = 0 //Accessible within this file
        private var privateProp = 0 //Accessible within this class only
    }

    internal class InternalClass { //Default - no keyword needed
        var prop = 0 //Also internal by default
    }

    fileprivate class FileClass { } //Only usable in this file

    private class PrivateHelper { } //Only usable within enclosing scope
}


func accessOnMembers() {
    class BankAccount {
        //private - implementation detail, no outside access
        private var transactionHistory: [String] = []

        //internal (default) - accessible within the app module
        var owner: String = ""

        //private method - helper only used internally
        private func logTransaction(_ message: String) {
            transactionHistory.append(message)
        }

        //internal method - accessible within the module
        func deposit(amount: Double) {
            logTransaction("Deposited \(amount)")
        }
    }

    //Extensions respect access control
    extension BankAccount {
        //Can access private members if extension is in the same file
        func printHistory() {
            print(transactionHistory) //OK - same file
        }
    }
}


func gettersAndSetters() {
    //Setter can be more restrictive than getter
    //private(set) - anyone can read, only the type itself can write
    class Player {
        private(set) var score: Int = 0 //Public read, private write
        internal(set) var name: String = "" //Public read, internal write

        func addPoints(_ points: Int) {
            score += points //OK - inside the class
        }
    }

    let player = Player()
    print(player.score) //OK - reading is unrestricted
    //player.score = 100 //Compile error - setter is private
    player.addPoints(10) //OK - method is internal
}