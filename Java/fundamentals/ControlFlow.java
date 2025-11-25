public class ControlFlow {
    public static void main(String[] args) {
        ifElseStatements();
        switchStatement();
        switchExpression();
        ternaryOperator();
    }

    //============================================================
    //IF-ELSE STATEMENTS
    //============================================================
    public static void ifElseStatements() {
        int x = 10;
        
        if (x < 5) {
            int result = 1;
        } else if (x < 10) {
            int result = 2;
        } else if (x < 15) {
            int result = 3;
        } else {
            int result = 4;
        }
        
    }

    //============================================================
    //SWITCH STATEMENT
    //============================================================
    public static void switchStatement() {
        int day = 3;
        
        switch (day) {
            case 1:
                String d = "Monday";
                break;
            case 2:
                String d2 = "Tuesday";
                break;
            case 3:
                String d3 = "Wednesday";
                break;
            default:
                String d4 = "Unknown";
                break;
        }
        
        //Fall-through behavior (no break)
        int month = 2;
        int daysInMonth = 0;
        switch (month) {
            case 1: case 3: case 5: case 7: case 8: case 10: case 12:
                daysInMonth = 31;
                break;
            case 4: case 6: case 9: case 11:
                daysInMonth = 30;
                break;
            case 2:
                daysInMonth = 28;
                break;
            default:
                daysInMonth = 0;
        }
        
        //Switch with String (Java 7+)
        String color = "red";
        switch (color) {
            case "red":
                int code = 1;
                break;
            case "green":
                int code2 = 2;
                break;
            case "blue":
                int code3 = 3;
                break;
            default:
                int code4 = 0;
        }
    }

    //============================================================
    //SWITCH EXPRESSION (Java 12+)
    //============================================================
    public static void switchExpression() {
        int day = 3;
        
        //Switch expression with arrow syntax
        String dayName = switch (day) {
            case 1 -> "Monday";
            case 2 -> "Tuesday";
            case 3 -> "Wednesday";
            case 4 -> "Thursday";
            case 5 -> "Friday";
            case 6 -> "Saturday";
            case 7 -> "Sunday";
            case 9, 10, 11, 12 -> "Invalid";
            default -> "Invalid";
        };
        
        //Switch expression with block and yield
        String grade = "B";
        int points = switch (grade) {
            case "A" -> {
                int base = 4;
                yield base;
            }
            case "B" -> {
                int base = 3;
                yield base;
            }
            case "C" -> {
                int base = 2;
                yield base;
            }
            default -> 0;
        };
        
        //Traditional colon syntax with yield (Java 12+)
        int value = 2;
        String result = switch (value) {
            case 1:
                yield "one";
            case 2:
                yield "two";
            case 3:
                yield "three";
            default:
                yield "other";
        };
    }

    //============================================================
    //TERNARY OPERATOR
    //============================================================
    public static void ternaryOperator() {
        int a = 10;
        int b = 20;
        
        //Basic ternary: condition ? valueIfTrue : valueIfFalse
        int max = (a > b) ? a : b;
        
        //Multiple ternaries
        boolean flag1 = true;
        boolean flag2 = false;
        int result = flag1 ? (flag2 ? 1 : 2) : 3;
    }
    
}