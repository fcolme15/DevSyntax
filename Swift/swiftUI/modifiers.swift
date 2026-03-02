import SwiftUI


//============================================================
//MODIFIER MENTAL MODEL
//============================================================
//Modifiers wrap a view in a new view - each modifier returns a modified copy
//Order matters - modifiers apply from inside out
//Think of it as wrapping layers: each .modifier() adds a new wrapper around the result so far


//============================================================
//MODIFIER ORDER
//============================================================
struct ModifierOrderExamples: View {
    var body: some View {
        VStack(spacing: 40) {
            //Background applies to text size, then padding adds space outside background
            Text("Padding outside background")
                .background(Color.yellow)
                .padding()

            //Padding adds space first, then background covers padded area
            Text("Background outside padding")
                .padding()
                .background(Color.yellow)

            //cornerRadius after background clips the background
            Text("Correct corner radius")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10) //Clips background corners

            //cornerRadius before background has no effect on background
            Text("Wrong corner radius order")
                .cornerRadius(10) //Clips text only, not background
                .padding()
                .background(Color.blue)
        }
    }
}


//============================================================
//APPEARANCE MODIFIERS
//============================================================
struct AppearanceModifiers: View {
    var body: some View {
        VStack {
            Text("Styled text")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary) //.primary adapts to light/dark mode
                .opacity(0.8)

            Rectangle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                .overlay( //Layer content on top
                    Text("Overlay")
                        .foregroundColor(.white)
                )
                .border(Color.red, width: 2) //Border outside the view

            Image(systemName: "star.fill")
                .foregroundStyle(.yellow) //Modern replacement for foregroundColor
                .imageScale(.large)
                .symbolEffect(.bounce) //SF Symbol animations (iOS 17+)
        }
    }
}


//============================================================
//LAYOUT MODIFIERS
//============================================================
struct LayoutModifiers: View {
    var body: some View {
        VStack {
            Text("Positioned")
                .position(x: 100, y: 100) //Absolute position in parent - use sparingly
                .offset(x: 10, y: 5) //Relative offset from normal position

            Color.blue
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(45))
                .scaleEffect(1.2)
        }
    }
}


//============================================================
//CONDITIONAL MODIFIERS
//============================================================
struct ConditionalModifiers: View {
    var isHighlighted = true
    var isLarge = false

    var body: some View {
        VStack {
            //Ternary for toggling between two modifier values
            Text("Conditional color")
                .foregroundColor(isHighlighted ? .yellow : .primary)

            //if/else returning views - both branches must return same type
            if isLarge {
                Text("Large").font(.largeTitle)
            } else {
                Text("Normal").font(.body)
            }

            //Custom modifier extension for cleaner syntax
            Text("Clean conditional")
                .modifier(ConditionalModifier(condition: isHighlighted))
        }
    }
}

//Custom ViewModifier - reusable modifier logic
struct ConditionalModifier: ViewModifier {
    let condition: Bool
    func body(content: Content) -> some View {
        content
            .foregroundColor(condition ? .yellow : .primary)
            .bold()
    }
}


//============================================================
//CUSTOM VIEW MODIFIERS
//============================================================
//Grouping modifiers into reusable named styles
struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

//Extension on View for clean call site syntax
extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }

    //Conditional modifier helper - apply modifier only when condition is true
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct CustomModifierUsage: View {
    var isSelected = true

    var body: some View {
        VStack {
            Text("Card style")
                .cardStyle() //Clean call site

            Text("Conditional modifier")
                .if(isSelected) { view in
                    view.background(Color.blue)
                }
        }
    }
}


//============================================================
//@VIEWBUILDER
//============================================================
//@ViewBuilder allows functions and computed properties to return multiple views
//SwiftUI uses this to make body accept if/else, switch, and multiple views
struct ViewBuilderExamples: View {
    var status: String = "active"

    //Custom function returning different views based on condition
    @ViewBuilder
    func statusView() -> some View {
        switch status {
        case "active":
            Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
        case "pending":
            Image(systemName: "clock").foregroundColor(.orange)
        default:
            Image(systemName: "xmark.circle").foregroundColor(.red)
        }
    }

    var body: some View {
        statusView()
    }
}