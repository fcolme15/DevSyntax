function mainSummary() {
	mathConstants();
	mathRounding();
	mathMinMax();
	mathPowerRoot();
	mathTrigonometry();
	mathRandom();
	mathOther();
}

function mathConstants() {
	console.log(Math.PI); //3.141592653589793
	console.log(Math.E); //2.718281828459045 (Euler's number)
	console.log(Math.LN2); //0.6931471805599453 (ln(2))
	console.log(Math.LN10); //2.302585092994046 (ln(10))
	console.log(Math.LOG2E); //1.4426950408889634 (log2(e))
	console.log(Math.LOG10E); //0.4342944819032518 (log10(e))
	console.log(Math.SQRT2); //1.4142135623730951 (√2)
	console.log(Math.SQRT1_2); //0.7071067811865476 (√(1/2))
}

function mathRounding() {
	//round - rounds to nearest integer
	console.log(Math.round(4.5)); //5
	
	//floor - rounds down
	console.log(Math.floor(4.9)); //4
	
	//ceil - rounds up
	console.log(Math.ceil(4.1)); //5
	
	//trunc - removes decimal part
	console.log(Math.trunc(4.9)); //4
	
	//Rounding to decimal places (not built-in, use toFixed or manual)
	const num = 3.14159;
	console.log(Math.round(num * 100) / 100); //3.14 - 2 decimal places
	console.log(Number(num.toFixed(2))); //3.14
}

function mathMinMax() {
	//min - returns smallest value
	console.log(Math.min(5, 10, 3, 8)); //3
	
	//max - returns largest value
	console.log(Math.max(5, 10, 3, 8)); //10
	
	//With arrays - use spread
	const numbers = [5, 10, 3, 8];
	console.log(Math.min(...numbers)); //3
	console.log(Math.max(...numbers)); //10
	
	//Infinity cases
	console.log(Math.min()); //Infinity
	console.log(Math.max()); //-Infinity
}

function mathPowerRoot() {
	//pow - power/exponentiation
	console.log(Math.pow(2, 3)); //8 (2^3)
	console.log(2 ** 3); //8 - ** operator (preferred)
	
	//sqrt - square root
	console.log(Math.sqrt(16)); //4
	
	//cbrt - cube root
	console.log(Math.cbrt(27)); //3
	
	//exp - e^x
	console.log(Math.exp(1)); //2.718281828459045 (e^1)
	
	//log - natural logarithm (ln)
	console.log(Math.log(Math.E)); //1
	
	//log10 - base 10 logarithm
	console.log(Math.log10(100)); //2
	
	//log2 - base 2 logarithm
	console.log(Math.log2(8)); //3
}

function mathTrigonometry() {
	//sin, cos, tan - input in radians
	console.log(Math.sin(0)); //0
	console.log(Math.cos(0)); //1
	console.log(Math.tan(0)); //0
	
	//asin, acos, atan - inverse trig, returns radians
	console.log(Math.asin(1)); //1.5707963267948966 (π/2)
	console.log(Math.acos(1)); //0
	console.log(Math.atan(1)); //0.7853981633974483 (π/4)
	
	//atan2 - angle from x-axis to point (y, x)
	console.log(Math.atan2(1, 1)); //0.7853981633974483 (π/4)
	
	//sinh, cosh, tanh - hyperbolic functions
	console.log(Math.sinh(0)); //0
	console.log(Math.cosh(0)); //1
	console.log(Math.tanh(0)); //0
	
	//Degrees to radians conversion
	const degrees = 90;
	const radians = degrees * (Math.PI / 180);
	
	//Radians to degrees conversion
	const rad = Math.PI / 2;
	const deg = rad * (180 / Math.PI);
}

function mathRandom() {
	//random - returns 0 (inclusive) to 1 (exclusive)
	console.log(Math.random()); //0.123456... (random)
	
	//Random integer between 0 and max (exclusive)
	const randomInt = Math.floor(Math.random() * 10); //0-9
	
	//Random boolean
	const randomBool = Math.random() < 0.5;
}

function mathOther() {
	//abs - absolute value
	console.log(Math.abs(-5)); //5
	
	//sign - returns -1, 0, or 1
	console.log(Math.sign(-5)); //-1
	
	//hypot - hypotenuse (√(x² + y² + z² + ...))
	console.log(Math.hypot(3, 4)); //5 (3-4-5 triangle)
	
	//clz32 - count leading zero bits in 32-bit binary
	console.log(Math.clz32(1)); //31
	
	//imul - 32-bit integer multiplication
	console.log(Math.imul(2, 4)); //8
	
	//fround - nearest 32-bit float representation
	console.log(Math.fround(1.5)); //1.5
}