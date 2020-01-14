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
    
    
    func uploadProfileImageToStorage(userId: String, uiImage: UIImage) {
        
        let imageId = UUID().uuidString
        
        var data = Data()
        data = uiImage.jpegData(compressionQuality: 0.3)!
        let ref = FirebaseStorage.shared.getImagesRef().child("\(imageId).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        ref.putData(data, metadata: metaData) { metadata, error in
            if let error = error {
                print("Error uplading profile image: \(error)")
            } else {
                // ToDo put into firestore here
                print("successfully uploaded")
                FirestoreConnection.shared.addProfileImage(myUserId: userId, profileImageId: imageId)
            }
        }

    }
}
