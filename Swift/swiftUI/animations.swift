import SwiftUI


//============================================================
//ANIMATION MENTAL MODEL
//============================================================
//SwiftUI animates the difference between two states
//You change a value, wrap it in withAnimation, SwiftUI interpolates the in-between frames
//Two approaches: implicit (.animation modifier) and explicit (withAnimation block)


//============================================================
//IMPLICIT ANIMATIONS
//============================================================
//.animation modifier - animates any change to the specified value
struct ImplicitAnimations: View {
    @State private var isLarge = false

    var body: some View {
        VStack {
            Circle()
                .fill(isLarge ? Color.blue : Color.red)
                .frame(width: isLarge ? 200 : 100, height: isLarge ? 200 : 100)
                .animation(.easeInOut(duration: 0.3), value: isLarge) //Animate when isLarge changes

            Button("Toggle") { isLarge.toggle() }
        }
    }
}


//============================================================
//EXPLICIT ANIMATIONS
//============================================================
//withAnimation block - animates all state changes inside the block
struct ExplicitAnimations: View {
    @State private var offset: CGFloat = 0
    @State private var opacity = 1.0
    @State private var rotation = 0.0

    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .offset(x: offset)
                .opacity(opacity)
                .rotationEffect(.degrees(rotation))

            Button("Animate") {
                withAnimation(.spring(duration: 0.5)) {
                    offset = offset == 0 ? 100 : 0 //All changes in block animate together
                    opacity = opacity == 1 ? 0.3 : 1
                    rotation += 45
                }
            }
        }
    }
}


//============================================================
//ANIMATION CURVES
//============================================================
struct AnimationCurves: View {
    @State private var moved = false

    var body: some View {
        VStack(spacing: 20) {
            animatedCircle(.linear(duration: 0.5), label: "Linear")
            animatedCircle(.easeIn(duration: 0.5), label: "Ease In")
            animatedCircle(.easeOut(duration: 0.5), label: "Ease Out")
            animatedCircle(.easeInOut(duration: 0.5), label: "Ease In Out")
            animatedCircle(.spring(duration: 0.5, bounce: 0.3), label: "Spring")
            animatedCircle(.bouncy, label: "Bouncy") //Preset spring

            Button("Animate") { moved.toggle() }
        }
    }

    func animatedCircle(_ animation: Animation, label: String) -> some View {
        HStack {
            Text(label).frame(width: 100)
            Circle()
                .fill(Color.blue)
                .frame(width: 30, height: 30)
                .offset(x: moved ? 100 : 0)
                .animation(animation, value: moved)
        }
    }
}


//============================================================
//TRANSITIONS
//============================================================
//Transitions animate views appearing and disappearing
struct TransitionExamples: View {
    @State private var showBox = true

    var body: some View {
        VStack {
            Button("Toggle") {
                withAnimation(.easeInOut) {
                    showBox.toggle()
                }
            }

            if showBox {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 100, height: 100)
                    .transition(.slide) //Slides in from leading edge

                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
                    .transition(.scale) //Scales from center

                Rectangle()
                    .fill(Color.green)
                    .frame(width: 100, height: 100)
                    .transition(.opacity) //Fades in/out

                Rectangle()
                    .fill(Color.orange)
                    .frame(width: 100, height: 100)
                    .transition(.move(edge: .bottom)) //Slides from bottom

                //Asymmetric - different transition for insert vs removal
                Rectangle()
                    .fill(Color.purple)
                    .frame(width: 100, height: 100)
                    .transition(.asymmetric(insertion: .slide, removal: .opacity))
            }
        }
    }
}


//============================================================
//MATCHED GEOMETRY EFFECT
//============================================================
//Smoothly animate a view moving between two locations in the hierarchy
struct MatchedGeometryExample: View {
    @Namespace private var animation //Shared namespace for matching
    @State private var isExpanded = false

    var body: some View {
        VStack {
            if isExpanded {
                //Large card
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue)
                    .matchedGeometryEffect(id: "card", in: animation) //Same id = same view
                    .frame(width: 300, height: 300)
            } else {
                //Small thumbnail
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .matchedGeometryEffect(id: "card", in: animation)
                    .frame(width: 80, height: 80)
            }
        }
        .onTapGesture {
            withAnimation(.spring(duration: 0.4)) {
                isExpanded.toggle() //SwiftUI animates the size/position change
            }
        }
    }
}


//============================================================
//REPEATING AND CONTINUOUS ANIMATIONS
//============================================================
struct RepeatingAnimations: View {
    @State private var isAnimating = false

    var body: some View {
        VStack {
            //Pulse effect
            Circle()
                .fill(Color.blue)
                .frame(width: 50, height: 50)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(
                    .easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                    value: isAnimating
                )

            //Rotation
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.largeTitle)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    .linear(duration: 1.0).repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
        .onAppear { isAnimating = true } //Start on appear
    }
}