public class Operators {
    public static void main(String[] args) {
        arithmeticOperators();
        comparisonOperators();
        logicalOperators();
        bitwiseOperators();
        assignmentOperators();
        unaryOperators();
        instanceofOperator();
    }

    //============================================================
    //ARITHMETIC OPERATORS
    //============================================================
    public static void arithmeticOperators() {
        int a = 10;
        int b = 3;
        
        int sum = a + b;
        int difference = a - b;
        int product = a * b;
        int quotient = a / b;
        int remainder = a % b;
        
        //Compound operations
        int value = 5;
        value += 3;
        value -= 2;
        value *= 4;
        value /= 3;
        value %= 5;
    }

    //============================================================
    //COMPARISON OPERATORS
    //============================================================
    public static void comparisonOperators() {
        int a = 5;
        int b = 10;
        
        boolean equal = (a == b);
        boolean notEqual = (a != b);
        boolean lessThan = (a < b);
        boolean greaterThan = (a > b);
        boolean lessOrEqual = (a <= b);
        boolean greaterOrEqual = (a >= b);
    }

    //============================================================
    //LOGICAL OPERATORS
    //============================================================
    public static void logicalOperators() {
        boolean x = true;
        boolean y = false;
        
        boolean and = x && y;
        boolean or = x || y;
        boolean not = !x;
    }

    //============================================================
    //BITWISE OPERATORS
    //============================================================
    public static void bitwiseOperators() {
        int a = 5;
        int b = 3;
        
        int bitwiseAnd = a & b;
        int bitwiseOr = a | b;
        int bitwiseXor = a ^ b;
        int bitwiseNot = ~a;
        
        //Shift operators
        int leftShift = a << 1; //Multiply by 2
        int rightShift = a >> 1; //Divide by 2
        int unsignedRightShift = -8 >>> 1; //Fills with 0s from left
        
        //Compound bitwise
        int value = 12;
        value &= 7;
        value |= 3;
        value ^= 5;
        value <<= 2;
        value >>= 1;
    }

    //============================================================
    //UNARY OPERATORS
    //============================================================
    public static void unaryOperators() {
        int x = 5;
        
        //Increment and decrement
        int postIncrement = x++; //postIncrement
        int preIncrement = ++x; //PreIncrement
        int postDecrement = x--; //PostDecrement
        int preDecrement = --x; //PreDecrement
        
        //Unary plus and minus
        int positive = +x; //5
        int negative = -x; //-5
        
        //Logical NOT
        boolean flag = true;
        boolean notFlag = !flag; //false
        
        //Bitwise complement
        int a = 5;
        int complement = ~a; //-6
    }

    //============================================================
    //INSTANCEOF OPERATOR
    //============================================================
    public static void instanceofOperator() {
        String str = "Hello";
        Integer num = 42;
        Object obj = "Test";
        
        boolean isString = str instanceof String; //true
        boolean isInteger = num instanceof Integer; //true
        boolean isObject = str instanceof Object; //true (String is subclass of Object)
        boolean check = obj instanceof String; //true (runtime type is String)
    }
}