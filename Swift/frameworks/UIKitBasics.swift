import UIKit
import SwiftUI


//============================================================
//WHY KNOW UIKIT
//============================================================
//SwiftUI is the modern framework but UIKit is still relevant because:
//- Many existing apps and libraries are UIKit-based
//- Some UIKit components have no SwiftUI equivalent yet
//- Understanding UIKit helps when reading Apple documentation
//- SwiftUI calls into UIKit under the hood on iOS/iPadOS
//- Some APIs like UIImagePickerController, MFMailComposeViewController still require UIKit


//============================================================
//UIKIT VS SWIFTUI MENTAL MODEL
//============================================================
//UIKit - imperative: you create view objects and mutate them directly
//  label.text = "Hello" / button.isHidden = true
//SwiftUI - declarative: you describe state and let framework update views
//  Text(viewModel.name) / if isVisible { Button(...) }
//
//UIKit uses classes, delegates, and target-action patterns
//SwiftUI uses structs, closures, and property wrappers


//============================================================
//UIVIEWREPRESENTABLE - USING UIKIT IN SWIFTUI
//============================================================
//Wrap a UIKit view to use it in SwiftUI when no SwiftUI equivalent exists

//Example: UIActivityIndicatorView (loading spinner) in SwiftUI
struct ActivityIndicator: UIViewRepresentable {
    var isAnimating: Bool

    //Create the UIKit view - called once
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .medium)
        return indicator
    }

    //Update the UIKit view when SwiftUI state changes - called on every state change
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

//Usage in SwiftUI
struct LoadingView: View {
    @State private var isLoading = true

    var body: some View {
        ActivityIndicator(isAnimating: isLoading)
    }
}


//============================================================
//UIVIEWCONTROLLERREPRESENTABLE - USING UIKIT VIEW CONTROLLERS IN SWIFTUI
//============================================================
//Wrap a UIKit view controller - common for system pickers and sheets

//Example: UIImagePickerController (camera/photo library)
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss

    //Coordinator handles UIKit delegates and callbacks back to SwiftUI
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            parent.selectedImage = info[.originalImage] as? UIImage
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator //Coordinator handles callbacks
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
}

//Usage
struct CameraView: View {
    @State private var showPicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            Button("Pick Photo") { showPicker = true }
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}


//============================================================
//SWIFTUI IN UIKIT - HOSTING SWIFTUI VIEWS
//============================================================
//Use a SwiftUI view inside a UIKit app or view controller
class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        //Wrap SwiftUI view in UIHostingController
        let swiftUIView = ProfileCard(name: "Francisco")
        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
}

struct ProfileCard: View {
    let name: String
    var body: some View { Text("Hello, \(name)") }
}


//============================================================
//COMMON UIKIT CLASSES YOU'LL ENCOUNTER
//============================================================
//UIViewController - base class for screens in UIKit
//UIView - base class for all visual elements
//UILabel - displays text (like Text in SwiftUI)
//UIButton - tappable control (like Button in SwiftUI)
//UIImageView - displays images (like Image in SwiftUI)
//UITableView - scrollable list (like List in SwiftUI)
//UICollectionView - grid/custom layouts (like LazyVGrid in SwiftUI)
//UINavigationController - manages navigation stack
//UITabBarController - manages tab interface
//UITextField - text input (like TextField in SwiftUI)
//UIScrollView - scrollable container (like ScrollView in SwiftUI)
//UIStackView - arranges views (like VStack/HStack in SwiftUI)
//UIAlertController - alerts and action sheets (like .alert in SwiftUI)