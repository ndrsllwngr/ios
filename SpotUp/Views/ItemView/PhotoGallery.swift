import Foundation
import GooglePlaces
import SwiftUI


class Gallery: ObservableObject, Identifiable {
    @Published var gallery: [UIImage] = []
    
    func getGallery (images: [GMSPlacePhotoMetadata]?) {
        if let images = images{
            for (index, image) in images.enumerated() {
                guard index <= 5 else {
                    break
        
                }
                getPlaceFoto(photoMetadata: image) { (photo: UIImage?, error: Error?) in
                    if let error = error {
                        print("Error loading photo metadata: \(error.localizedDescription)")
                        return
                    }
                    if let photo = photo {
                        print("added photo Gallery!")
                        self.gallery.append(photo)
                    }
                }
            }
        }
    }
}
