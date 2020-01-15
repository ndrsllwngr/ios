import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    var imageType: ImageType
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                let croppedImage = cropUiImageToBounds(image: uiImage, width: 500.0, height: 500.0)
                FirebaseStorage.shared.uploadImageToStorage(id: self.firebaseAuthentication.currentUser!.uid, imageType: parent.imageType, uiImage: croppedImage)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

// https://stackoverflow.com/questions/32041420/cropping-image-with-swift-and-put-it-on-center-position
func cropUiImageToBounds(image: UIImage, width: Double, height: Double) -> UIImage {

    let cgimage = image.cgImage!
    let contextImage: UIImage = UIImage(cgImage: cgimage)
    let contextSize: CGSize = contextImage.size
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    var cgwidth: CGFloat = CGFloat(width)
    var cgheight: CGFloat = CGFloat(height)

    // See what size is longer and create the center off of that
    if contextSize.width > contextSize.height {
        posX = ((contextSize.width - contextSize.height) / 2)
        posY = 0
        cgwidth = contextSize.height
        cgheight = contextSize.height
    } else {
        posX = 0
        posY = ((contextSize.height - contextSize.width) / 2)
        cgwidth = contextSize.width
        cgheight = contextSize.width
    }

    let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

    // Create bitmap image from context using the rect
    let imageRef: CGImage = cgimage.cropping(to: rect)!

    // Create a new image based on the imageRef and rotate back to the original orientation
    let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

    return image
}
