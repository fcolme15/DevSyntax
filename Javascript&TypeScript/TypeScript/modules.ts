function mainSummaryModules() {
    modulesExportSyntax();
    modulesImportSyntax();
    modulesDefaultExports();
    modulesReExports();
}

function modulesExportSyntax() {
    //Named exports
    //export function add(x: number, y: number): number {
    //    return x + y;
    //}
    //export const PI = 3.14159;
    //export class User {
    //    constructor(public name: string) {}
    //}

    //Export list
    //function multiply(x: number, y: number): number {
    //    return x * y;
    //}
    //const E = 2.71828;
    //export { multiply, E };

    //Export with rename
    //function subtract(x: number, y: number): number {
    //    return x - y;
    //}
    //export { subtract as minus };

    //Export types
    //export interface Config {
    //    host: string;
    //    port: number;
    //}
    //export type ID = string | number;
}

function modulesImportSyntax() {
    //Named imports
    //import { add, PI } from "./math";
    //import { User } from "./user";

    //Import with rename
    //import { multiply as times } from "./math";

    //Import all
    //import * as math from "./math";
    //math.add(1, 2);
    //console.log(math.PI);

    //Import type only (type-only import)
    //import type { Config } from "./config";
    //let config: Config = { host: "localhost", port: 8080 };

    //Import both value and type
    //import { User, type UserConfig } from "./user";
}

function modulesDefaultExports() {
    //Default export (one per file)
    //export default function calculate(x: number, y: number): number {
    //    return x + y;
    //}

    //Or
    //function calculate(x: number, y: number): number {
    //    return x + y;
    //}
    //export default calculate;

    //Default export class
    //export default class User {
    //    constructor(public name: string) {}
    //}

    //Import default export (can use any name)
    //import calculate from "./calculator";
    //import MyUser from "./user"; //Can rename

    //Mix default and named exports
    //export default function main() {}
    //export const VERSION = "1.0.0";

    //import main, { VERSION } from "./app";
}

function modulesReExports() {
    //Re-export from another module
    //export { add, multiply } from "./math";

    //Re-export with rename
    //export { add as sum } from "./math";

    //Re-export all
    //export * from "./math";

    //Re-export all as namespace
    //export * as math from "./math";
    //import { math } from "./index";
    //math.add(1, 2);

    //Re-export default as named
    //export { default as Calculator } from "./calculator";
}