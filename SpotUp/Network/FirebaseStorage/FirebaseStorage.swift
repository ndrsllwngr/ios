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
}
