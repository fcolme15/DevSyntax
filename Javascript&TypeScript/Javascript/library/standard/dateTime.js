function mainSummary() {
	dateCreation();
	dateGetters();
	dateSetters();
	dateFormatting();
	dateCalculations();
}

function dateCreation() {
	//Current date and time
	const now = new Date();
	console.log(now); //Current date/time
	
	//From timestamp (milliseconds since Jan 1, 1970)
	const date1 = new Date(0); //Jan 1, 1970
	const date2 = new Date(1000000000000); //Sep 9, 2001
	
	//From date string
	const date3 = new Date("2024-12-25");
	const date4 = new Date("December 25, 2024");
	const date5 = new Date("2024-12-25T10:30:00");
	
	//From components (year, month, day, hour, min, sec, ms)
	const date6 = new Date(2024, 11, 25); //Dec 25, 2024 (month is 0-indexed)
	const date7 = new Date(2024, 11, 25, 10, 30, 0); //With time
	
	//Date.now() - current timestamp
	const timestamp = Date.now(); //Milliseconds since epoch
	console.log(timestamp); //1735142400000
	
	//Date.parse() - parse string to timestamp
	const parsed = Date.parse("2024-12-25");
	console.log(parsed); //1735084800000
}

function dateGetters() {
	const date = new Date("2024-12-25T10:30:45");
	
	//Year, month, day
	console.log(date.getFullYear()); //2024
	console.log(date.getMonth()); //11 (0-indexed, Dec = 11)
	console.log(date.getDate()); //25 (day of month)
	console.log(date.getDay()); //3 (day of week, 0 = Sun)
	
	//Time
	console.log(date.getHours()); //10
	console.log(date.getMinutes()); //30
	console.log(date.getSeconds()); //45
	console.log(date.getMilliseconds()); //0
	
	//Timestamp
	console.log(date.getTime()); //Milliseconds since epoch
	console.log(date.valueOf()); //Same as getTime()
	
	//UTC methods (same as above but in UTC)
	console.log(date.getUTCFullYear()); //2024
	console.log(date.getUTCHours()); //UTC hours
	
	//Timezone offset in minutes
	console.log(date.getTimezoneOffset()); //-300 (for EST)
}

function dateSetters() {
	const date = new Date("2024-12-25");
	
	//Set year, month, day
	date.setFullYear(2025);
	date.setMonth(0); //January (0-indexed)
	date.setDate(15);
	console.log(date); //Jan 15, 2025
	
	//Set time
	date.setHours(14);
	date.setMinutes(30);
	date.setSeconds(45);
	date.setMilliseconds(500);
	
	//Set timestamp
	date.setTime(1000000000000);
	console.log(date); //Sep 9, 2001
	
	//UTC setters also available
	date.setUTCFullYear(2024);
}

function dateFormatting() {
	const date = new Date("2024-12-25T10:30:00");
	
	//toString methods
	console.log(date.toString()); //"Wed Dec 25 2024 10:30:00 GMT-0500"
	console.log(date.toDateString()); //"Wed Dec 25 2024"
	console.log(date.toTimeString()); //"10:30:00 GMT-0500"
	console.log(date.toISOString()); //"2024-12-25T15:30:00.000Z"
	console.log(date.toUTCString()); //"Wed, 25 Dec 2024 15:30:00 GMT"
	console.log(date.toLocaleDateString()); //"12/25/2024" (locale-specific)
	console.log(date.toLocaleTimeString()); //"10:30:00 AM"
	console.log(date.toLocaleString()); //"12/25/2024, 10:30:00 AM"
	
	//Locale-specific formatting
	console.log(date.toLocaleDateString("en-US")); //"12/25/2024"
	console.log(date.toLocaleDateString("en-GB")); //"25/12/2024"
	console.log(date.toLocaleDateString("de-DE")); //"25.12.2024"
	
	//Custom formatting with Intl.DateTimeFormat
	const formatter = new Intl.DateTimeFormat("en-US", {
		year: "numeric",
		month: "long",
		day: "numeric"
	});
	console.log(formatter.format(date)); //"December 25, 2024"
	
	//Manual formatting (common pattern)
	const year = date.getFullYear();
	const month = String(date.getMonth() + 1).padStart(2, "0");
	const day = String(date.getDate()).padStart(2, "0");
	console.log(`${year}-${month}-${day}`); //"2024-12-25"
}