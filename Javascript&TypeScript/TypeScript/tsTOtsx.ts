//TSX VS TS - Differences between .ts and .tsx files
function mainSummaryTsxVsTs() {
    tsxJsxSyntax();
    tsxTypeAssertions();
    tsxGenericArrowFunctions();
    tsxComponentTypes();
}

function tsxJsxSyntax() {
    //.tsx files allow JSX syntax
    //const element = <div>Hello World</div>;
    //const component = <MyComponent prop="value" />;

    //.ts files cannot use JSX - syntax error
    //const element = <div>Hello</div>; //ERROR in .ts file

    //JSX expressions
    //const name = "John";
    //const element = <div>Hello {name}</div>;
}

function tsxTypeAssertions() {
    //.ts files - both syntaxes work
    let value: unknown = "hello";
    //let str1 = <string>value; //Angle bracket syntax - .ts not .tsx
    let str2 = value as string; //As syntax - OK everywhere

    //Rule: Always use 'as' syntax in .tsx files
}

function tsxGenericArrowFunctions() {
    //.ts files - normal generic syntax
    //const identity = <T>(arg: T): T => arg;

    //.tsx files - need trailing comma to avoid JSX ambiguity
    //const identity = <T,>(arg: T): T => arg;
    //                    ^ Comma tells TypeScript this is a generic, not JSX

    //Without comma in .tsx
    //const identity = <T>(arg: T): T => arg; //ERROR - looks like JSX

    //Alternative: Use function syntax instead of arrow
    //function identity<T>(arg: T): T {
    //    return arg;
    //}

    //Multiple type parameters don't need comma
    //const pair = <T, U>(a: T, b: U) => [a, b]; //OK - already has comma
}

function tsxComponentTypes() {
    //React component types (only in .tsx)
    //interface Props {
    //    name: string;
    //    age: number;
    //}

    //Function component
    //const MyComponent: React.FC<Props> = (props) => {
    //    return <div>{props.name}</div>;
    //};

    //Or without React.FC
    //const MyComponent = (props: Props): JSX.Element => {
    //    return <div>{props.name}</div>;
    //};

    //Class component
    //class MyClassComponent extends React.Component<Props> {
    //    render() {
    //        return <div>{this.props.name}</div>;
    //    }
    //}

    //Children prop
    //interface PropsWithChildren {
    //    children: React.ReactNode;
    //}

    //const Container = (props: PropsWithChildren) => {
    //    return <div>{props.children}</div>;
    //};
}