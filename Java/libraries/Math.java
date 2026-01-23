public class MathReference {
    public static void main(String[] args) {
        basicOperationsUsage();
        roundingUsage();
        exponentialUsage();
        trigonometryUsage();
        randomUsage();
        constantsUsage();
    }

    //============================================================
    //BASIC OPERATIONS - USAGE
    //============================================================
    public static void basicOperationsUsage() {
        //Absolute value
        int absInt = Math.abs(-5); //5
        double absDouble = Math.abs(-3.14); //3.14
        
        //Max and min
        int max = Math.max(10, 20); //20
        int min = Math.min(10, 20); //10
        double maxDouble = Math.max(3.5, 2.8); //3.5
        
        //Power
        double squared = Math.pow(5, 2); //25.0
        double cubed = Math.pow(2, 3); //8.0
        
        //Square root
        double sqrt = Math.sqrt(25); //5.0
        double sqrt2 = Math.sqrt(2); //1.414...
        
        //Cube root
        double cbrt = Math.cbrt(27); //3.0
    }

    //============================================================
    //ROUNDING - USAGE
    //============================================================
    public static void roundingUsage() {
        //Round to nearest integer
        long rounded = Math.round(3.6); //4
        long rounded2 = Math.round(3.4); //3
        
        //Ceiling - round up
        double ceil = Math.ceil(3.1); //4.0
        double ceil2 = Math.ceil(-3.9); //-3.0
        
        //Floor - round down
        double floor = Math.floor(3.9); //3.0
        double floor2 = Math.floor(-3.1); //-4.0
        
        //Truncate (toward zero)
        int truncated = (int) 3.9; //3
        int truncated2 = (int) -3.9; //-3
    }

    //============================================================
    //EXPONENTIAL AND LOGARITHM - USAGE
    //============================================================
    public static void exponentialUsage() {
        //Exponential (e^x)
        double exp = Math.exp(1); //2.718... (e)
        double exp2 = Math.exp(2); //7.389...
        
        //Natural logarithm (ln)
        double log = Math.log(Math.E); //1.0
        double log2 = Math.log(10); //2.302...
        
        //Base-10 logarithm
        double log10 = Math.log10(100); //2.0
        double log10_2 = Math.log10(1000); //3.0
        
        //Hypotenuse - sqrt(x² + y²)
        double hypotenuse = Math.hypot(3, 4); //5.0
    }

    //============================================================
    //TRIGONOMETRY - USAGE (Radians)
    //============================================================
    public static void trigonometryUsage() {
        //Convert degrees to radians
        double radians = Math.toRadians(90); //1.57... (π/2)
        double radians2 = Math.toRadians(180); //3.14... (π)
        
        //Convert radians to degrees
        double degrees = Math.toDegrees(Math.PI); //180.0
        double degrees2 = Math.toDegrees(Math.PI / 2); //90.0
        
        //Sine
        double sin90 = Math.sin(Math.toRadians(90)); //1.0
        double sin0 = Math.sin(0); //0.0
        
        //Cosine
        double cos0 = Math.cos(0); //1.0
        double cos90 = Math.cos(Math.toRadians(90)); //0.0 (approx)
        
        //Tangent
        double tan45 = Math.tan(Math.toRadians(45)); //1.0
        
        //Inverse functions
        double asin = Math.asin(1); //π/2 (90 degrees in radians)
        double acos = Math.acos(1); //0.0
        double atan = Math.atan(1); //π/4 (45 degrees in radians)
    }

    //============================================================
    //RANDOM - USAGE
    //============================================================
    public static void randomUsage() {
        //Random double [0.0, 1.0)
        double random = Math.random(); //0.0 <= x < 1.0
        
        //Random int in range [min, max]
        int min = 1;
        int max = 100;
        int randomInt = (int) (Math.random() * (max - min + 1)) + min;
        
        //Random int [0, n)
        int randomUpTo10 = (int) (Math.random() * 10); //0-9
        
        //Random boolean
        boolean randomBool = Math.random() < 0.5;
        
        //Random from array
        String[] items = {"apple", "banana", "cherry"};
        String randomItem = items[(int) (Math.random() * items.length)];
    }

    //============================================================
    //CONSTANTS - USAGE
    //============================================================
    public static void constantsUsage() {
        //Pi (π) - 3.14159...
        double pi = Math.PI;
        
        //Euler's number (e) - 2.71828...
        double e = Math.E;
    }
}

//============================================================
//MATH METHODS SUMMARY
//============================================================
//Basic:
//- abs(x) - absolute value
//- max(a, b) - maximum of two values
//- min(a, b) - minimum of two values
//- pow(a, b) - a raised to power b
//- sqrt(x) - square root
//- cbrt(x) - cube root

//Rounding:
//- round(x) - round to nearest integer
//- ceil(x) - round up
//- floor(x) - round down

//Exponential/Logarithm:
//- exp(x) - e raised to power x
//- log(x) - natural logarithm (base e)
//- log10(x) - base-10 logarithm
//- hypot(x, y) - sqrt(x² + y²)

//Trigonometry (radians):
//- sin(x), cos(x), tan(x) - trig functions
//- asin(x), acos(x), atan(x) - inverse trig
//- toRadians(degrees) - convert to radians
//- toDegrees(radians) - convert to degrees

//Random:
//- random() - random double [0.0, 1.0)

//Constants:
//- PI - 3.14159...
//- E - 2.71828...

//============================================================
//ADDITIONAL METHODS
//============================================================
//signum(x) - sign of number (-1, 0, or 1)
//copySign(magnitude, sign) - magnitude with sign
//nextAfter(start, direction) - next floating-point value
//nextUp(x) - next value toward positive infinity
//nextDown(x) - next value toward negative infinity
//ulp(x) - size of unit in last place
//scalb(x, scaleFactor) - x * 2^scaleFactor
//IEEEremainder(f1, f2) - IEEE 754 remainder
//rint(x) - round to nearest integer (as double)
//sinh(x), cosh(x), tanh(x) - hyperbolic trig functions

//============================================================
//COMMON PATTERNS
//============================================================
//Random integer in range [min, max]:
//int random = (int)(Math.random() * (max - min + 1)) + min;

//Distance between two points:
//double distance = Math.hypot(x2 - x1, y2 - y1);

//Clamp value to range:
//int clamped = Math.max(min, Math.min(max, value));

//Check if number is power of 2:
//boolean isPowerOf2 = (n > 0) && ((n & (n - 1)) == 0);

//Round to N decimal places:
//double rounded = Math.round(value * 100.0) / 100.0; //2 decimals