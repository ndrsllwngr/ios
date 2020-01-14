import Foundation
import SwiftUI
import Combine
import FirebaseStorage

class FirebaseStorageImageLoader: ObservableObject {
    
    @Published var image: UIImage? = nil
    
    init(id: String) {
        let ref = FirebaseStorage.shared.getImagesRef().child("\(id).png")
        
        ref.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            guard let data = data else {
                print("Error downloading data")
                return
            }
            self.image = UIImage(data: data)
        }
    }
}
