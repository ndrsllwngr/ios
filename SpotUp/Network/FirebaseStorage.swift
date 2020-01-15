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
        
        var data = Data()
        data = uiImage.jpegData(compressionQuality: 0.3)!
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let imageRef = getImageRef(id: id, imageType: imageType)
        imageRef.putData(data, metadata: metaData) { metadata, error in
            if let error = error {
                print("Error uplading profile image: \(error)")
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
