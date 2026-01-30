function mainSummary() {
	namedExports();
	defaultExports();
	importingSyntax();
	reexporting();
	dynamicImports();
}

function namedExports() {
	//Export during declaration
	//export const PI = 3.14159;
	//export function add(a, b) { return a + b; }
	//export class Calculator { }
	
	//Export after declaration
	const MAX = 100;
	function multiply(a, b) { return a * b; }
	class Counter { }
	//export { MAX, multiply, Counter };
	
	//Export with rename
	const value = 42;
	//export { value as answer };
}

function defaultExports() {
	//Default export - function
	//export default function greet(name) {
	//	return `Hello ${name}`;
	//}
	
	//Default export - class
	//export default class Person {
	//	constructor(name) { this.name = name; }
	//}
	
	//Default export - value
	//export default 42;
	
	//Default export - anonymous function
	//export default function(x) { return x * 2; }
	
	//Default export after declaration
	//function calculate(a, b) { return a + b; }
	//export default calculate;
	
	//Only one default export per module
	//Cannot have multiple default exports
}

function importingSyntax() {
	//Import named exports
	//import { add, multiply } from './math.js';
	
	//Import all named exports as namespace
	//import * as math from './math.js';
	//math.add(2, 3);
	
	//Import default export
	//import greet from './greet.js';
	
	//Import default with named exports
	//import Person, { age, city } from './person.js';
	
	//Import with rename
	//import { add as sum } from './math.js';
	
	//Import for side effects only (no bindings)
	//import './config.js'; //Executes code but doesn't import anything
	
	//Dynamic import (returns Promise)
	//const module = await import('./math.js');
	//module.add(2, 3);
	
	//Destructure dynamic import
	//const { add, multiply } = await import('./math.js');
}

function reexporting() {
	//Re-export all named exports from another module
	//export * from './math.js';
	
	//Re-export specific named exports
	//export { add, multiply } from './math.js';
	
	//Re-export with rename
	//export { add as sum } from './math.js';
	
	//Re-export default as named
	//export { default as Calculator } from './calculator.js';
	
	//Re-export named as default
	//export { add as default } from './math.js';
	
	//Common pattern: index.js barrel file
	//export * from './module1.js';
	//export * from './module2.js';
	//export * from './module3.js';
	//Allows: import { func1, func2 } from './folder'; instead of separate imports
}

function dynamicImports() {
	//Dynamic import returns Promise
	//import('./math.js').then(module => {
	//	console.log(module.add(2, 3));
	//});
	
	//With async/await
	//async function loadModule() {
	//	const math = await import('./math.js');
	//	console.log(math.add(2, 3));
	//}
	
	//Conditional loading
	//if (condition) {
	//	const module = await import('./heavy-module.js');
	//	module.doSomething();
	//}
	
	//Dynamic path
	//const moduleName = 'math';
	//const module = await import(`./${moduleName}.js`);
	
	//Error handling
	//try {
	//	const module = await import('./module.js');
	//} catch (error) {
	//	console.log('Module failed to load');
	//}
	
	//Note: Dynamic imports work in modules and scripts
	//Static imports only work in modules
}

//Example file structure:
//
// math.js:
// export const PI = 3.14159;
// export function add(a, b) { return a + b; }
// export function multiply(a, b) { return a * b; }
//
// greet.js:
// export default function greet(name) { return `Hello ${name}`; }
//
// person.js:
// export default class Person {
//   constructor(name) { this.name = name; }
// }
// export const age = 30;
// export const city = "NYC";
//
// main.js:
// import { add, multiply } from './math.js';
// import greet from './greet.js';
// import Person, { age, city } from './person.js';
//
// console.log(add(2, 3));
// console.log(greet("John"));
// const p = new Person("Jane");