import SwiftUI

struct GPViewControllerWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<GPViewControllerWrapper>) -> UIViewController {
        let v = GPViewController()
        return v
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<GPViewControllerWrapper>) {
        //
    }
}
