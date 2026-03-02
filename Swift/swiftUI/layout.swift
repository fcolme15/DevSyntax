import SwiftUI


//============================================================
//LAYOUT MENTAL MODEL
//============================================================
//SwiftUI layout is a negotiation between parent and child
//1. Parent offers available space to child
//2. Child decides its own size based on content
//3. Parent positions child within its space
//Children cannot exceed the space offered - parents do not force size


//============================================================
//STACKS
//============================================================
struct StackExamples: View {
    var body: some View {
        //VStack - vertical arrangement
        VStack(alignment: .leading, spacing: 10) {
            Text("First")
            Text("Second")
            Text("Third")
        }

        //HStack - horizontal arrangement
        HStack(alignment: .center, spacing: 20) {
            Image(systemName: "star")
            Text("Rating")
            Spacer()
            Text("4.5")
        }

        //ZStack - layered, back to front
        ZStack(alignment: .bottomTrailing) {
            Image("background")
            Text("Overlay text")
                .padding()
                .background(Color.black.opacity(0.5))
        }

        //Nested stacks - common pattern
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Title").font(.headline)
                    Text("Subtitle").font(.subheadline)
                }
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            Divider()
        }
    }
}


//============================================================
//FRAME AND SIZING
//============================================================
struct FrameExamples: View {
    var body: some View {
        VStack {
            //Fixed frame
            Text("Fixed")
                .frame(width: 200, height: 50)

            //Flexible frame - min/max constraints
            Text("Flexible")
                .frame(minWidth: 100, maxWidth: .infinity) //Expand to fill available width
                .frame(minHeight: 44)

            //Alignment within frame
            Text("Aligned")
                .frame(width: 200, height: 100, alignment: .topLeading)

            //Fill available width - common pattern
            Button("Full Width") { }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
        }
    }
}


//============================================================
//PADDING AND SPACING
//============================================================
struct PaddingExamples: View {
    var body: some View {
        VStack {
            Text("All sides")
                .padding() //Default padding all sides

            Text("Horizontal")
                .padding(.horizontal, 20)

            Text("Specific")
                .padding(.top, 10)
                .padding(.bottom, 5)
                .padding(.leading, 15)

            Text("Custom all")
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        }
    }
}


//============================================================
//GRID LAYOUTS
//============================================================
struct GridExamples: View {
    let items = Array(1...12)

    var body: some View {
        ScrollView {
            //LazyVGrid - vertical grid with defined columns
            LazyVGrid(columns: [
                GridItem(.flexible()), //Equal width columns
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                ForEach(items, id: \.self) { item in
                    Text("\(item)")
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.3))
                }
            }
            .padding()

            //Fixed size columns
            LazyVGrid(columns: [
                GridItem(.fixed(100)),
                GridItem(.fixed(100)),
                GridItem(.adaptive(minimum: 80)) //As many as fit at minimum size
            ]) {
                ForEach(items, id: \.self) { item in
                    Text("\(item)")
                }
            }
        }
    }
}


//============================================================
//GEOMETRY READER
//============================================================
struct GeometryExamples: View {
    var body: some View {
        //GeometryReader provides access to parent's size and coordinate space
        //Use sparingly - prefer flexible frames and stacks when possible
        GeometryReader { geometry in
            VStack {
                Text("Width: \(geometry.size.width)")
                Text("Height: \(geometry.size.height)")

                //Size relative to parent
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * 0.8) //80% of parent width
            }
        }
    }
}


//============================================================
//SAFE AREA
//============================================================
struct SafeAreaExamples: View {
    var body: some View {
        VStack {
            Text("Respects safe area by default")
        }
        //Extend into safe area - useful for background colors
        .background(Color.blue.ignoresSafeArea())

        ZStack {
            Color.red.ignoresSafeArea() //Full screen background
            Text("Content stays in safe area")
        }
    }
}