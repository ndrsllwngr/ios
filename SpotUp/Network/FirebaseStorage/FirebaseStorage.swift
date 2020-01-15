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
        getImageRef(id: id, imageType: imageType).putData(data, metadata: metaData) { metadata, error in
            if let error = error {
                print("Error uplading profile image: \(error)")
            } else {
                print("successfully uploaded")
            }
        }

    }
}
