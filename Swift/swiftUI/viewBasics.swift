import SwiftUI

//============================================================
//SWIFTUI MENTAL MODEL
//============================================================
//Views are structs that describe what to display - not objects you manipulate
//You never say "change this label's text" - you change state and SwiftUI redraws
//Every time state changes, body is called again and SwiftUI diffs the result
//Similar to React - declare what UI should look like given current state


func viewBasicsOverview() {
    //Cannot demonstrate SwiftUI views in plain functions
    //Each section below is a standalone struct - read as independent examples
}


//============================================================
//THE VIEW PROTOCOL
//============================================================
//Every SwiftUI view conforms to View - requires one computed property: body
//body returns some View - opaque type, compiler knows the concrete type
struct BasicView: View {
    var body: some View {
        Text("Hello, World!")
    }
}


//============================================================
//TEXT
//============================================================
struct TextExamples: View {
    var body: some View {
        VStack {
            Text("Plain text")
            Text("Bold").bold()
            Text("Italic").italic()
            Text("Large").font(.largeTitle)
            Text("Custom font").font(.system(size: 24, weight: .semibold))
            Text("Colored").foregroundColor(.blue)
            Text("Multiline text that wraps automatically when it exceeds the available width")
                .multilineTextAlignment(.center)
                .lineLimit(3) //Max lines, nil for unlimited
            Text("Formatted \(42) and \(3.14, specifier: "%.2f")") //String interpolation with format
        }
    }
}


//============================================================
//IMAGE
//============================================================
struct ImageExamples: View {
    var body: some View {
        VStack {
            //SF Symbols - Apple's built-in icon library, thousands of icons
            Image(systemName: "star.fill")
            Image(systemName: "heart")
                .foregroundColor(.red)
                .font(.largeTitle) //SF Symbols scale with font size

            //Asset catalog image - image added to Xcode project
            Image("profilePhoto")
                .resizable() //Must call resizable() before scaling
                .scaledToFit() //Maintain aspect ratio, fit within frame
                .frame(width: 100, height: 100)

            Image("photo")
                .resizable()
                .scaledToFill() //Fill frame, may crop
                .frame(width: 100, height: 100)
                .clipped() //Clip overflow from scaledToFill
        }
    }
}


//============================================================
//BUTTON
//============================================================
struct ButtonExamples: View {
    var body: some View {
        VStack {
            //Basic button - label and action
            Button("Tap me") {
                print("Tapped")
            }

            //Button with custom label
            Button {
                print("Tapped")
            } label: {
                Text("Custom Label")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            //Button styles
            Button("Bordered") { }
                .buttonStyle(.bordered)

            Button("Prominent") { }
                .buttonStyle(.borderedProminent)
        }
    }
}


//============================================================
//COMMON INPUT VIEWS
//============================================================
struct InputExamples: View {
    @State private var text = ""
    @State private var isOn = false
    @State private var sliderValue = 0.5
    @State private var selectedDate = Date()

    var body: some View {
        Form {
            //TextField - text input
            TextField("Enter name", text: $text) //$ passes Binding, covered in State.swift
            TextField("Multiline", text: $text, axis: .vertical)
                .lineLimit(3...6)

            //SecureField - hides input
            SecureField("Password", text: $text)

            //Toggle
            Toggle("Enable notifications", isOn: $isOn)

            //Slider
            Slider(value: $sliderValue, in: 0...1)
            Slider(value: $sliderValue, in: 0...100, step: 1)

            //DatePicker
            DatePicker("Select date", selection: $selectedDate)
            DatePicker("Date only", selection: $selectedDate, displayedComponents: .date)
        }
    }
}


//============================================================
//SHAPES
//============================================================
struct ShapeExamples: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 100, height: 50)

            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green)
                .frame(width: 100, height: 50)

            Circle()
                .fill(Color.red)
                .frame(width: 60, height: 60)

            Capsule()
                .stroke(Color.purple, lineWidth: 2) //Outline only
                .frame(width: 100, height: 40)

            Ellipse()
                .fill(Color.orange)
                .frame(width: 120, height: 60)
        }
    }
}


//============================================================
//SPACER AND DIVIDER
//============================================================
struct SpacerDividerExamples: View {
    var body: some View {
        VStack {
            Text("Top")
            Spacer() //Flexible space - pushes content to edges
            Text("Bottom")

            Divider() //Horizontal line

            HStack {
                Text("Left")
                Spacer()
                Text("Right")
            }
        }
    }
}