import Foundation
import Firebase
import FirebaseStorage

class FirebaseStorage: ObservableObject {
    
    static let shared = FirebaseStorage()
    private static let storage = Storage.storage()
    
    private let imagesRef = storage.reference().child("images")
    
    private init() {}
    
    func getImagesRef() -> StorageReference{
        return imagesRef
    }
    
    
    func uploadImageToStorage(id: String, imageType: ImageType, uiImage: UIImage) {
        
        let croppedImage = cropUiImageToBounds(image: uiImage, width: 500.0, height: 500.0)
        
        var data = Data()
        data = croppedImage.jpegData(compressionQuality: 0.3)!
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let imageRef = getImageRef(id: id, imageType: imageType)
        imageRef.putData(data, metadata: metaData) { metadata, error in
            if let error = error {
                print("Error uplading image: \(error)")
            } else {
                print("successfully uploaded")
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    FirestoreConnection.shared.addImageUrlToFirestore(id: id, imageType: imageType, downloadURL: downloadURL)
                }
            }
        }
    }
    
    func deleteImageFromStorage(id: String, imageType: ImageType) {
        let imageRef = getImageRef(id: id, imageType: imageType)
        imageRef.delete { error in
            if let error = error {
                print("Error deleting image: \(error)")
            } else {
                print("Image successfully deleted")
            }
        }
    }
    
    func deleteImageFromStorageWithCallback(id: String, imageType: ImageType, completion: ((Error?) -> Void)? = nil) {
        let imageRef = getImageRef(id: id, imageType: imageType)
        imageRef.delete()
    }
}

enum ImageType {
    case PROFILE_IMAGE
    case PLACELIST_IMAGE
}

func getImageRef(id: String, imageType: ImageType) -> StorageReference {
    var imageRef  = StorageReference()
    switch imageType {
        
    case .PROFILE_IMAGE:
        imageRef = FirebaseStorage.shared.getImagesRef().child("profile_images/\(id).jpg")
    case .PLACELIST_IMAGE:
        imageRef = FirebaseStorage.shared.getImagesRef().child("placelist_images/\(id).jpg")
    }
    return imageRef
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
