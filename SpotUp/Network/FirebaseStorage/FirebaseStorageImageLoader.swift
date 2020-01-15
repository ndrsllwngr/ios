import Foundation
import SwiftUI
import Combine
import FirebaseStorage

enum ImageType {
    case profile_image
    case placelist_image
}

func getImageRef(id: String, imageType: ImageType) -> StorageReference {
    var imageRef  = StorageReference()
    switch imageType {
        
    case .profile_image:
        imageRef = FirebaseStorage.shared.getImagesRef().child("profile_images/\(id).jpg")
    case .placelist_image:
        imageRef = FirebaseStorage.shared.getImagesRef().child("placelist_images/\(id).jpg")
    }
    return imageRef
}

class FirebaseStorageImageLoader: ObservableObject {
    
    @Published var image: UIImage? = nil
    
    init(id: String, imageType: ImageType) {
        loadImage(id: id, imageType: imageType)
    }
    
    func loadImage(id: String, imageType: ImageType) {
        getImageRef(id: id, imageType: imageType).getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            guard let data = data else {
                print("Error downloading data")
                return
            }
            self.image = UIImage(data: data)
        }
    }
}
