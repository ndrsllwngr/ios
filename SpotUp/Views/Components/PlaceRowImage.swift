import SwiftUI

struct PlaceRowImage: View {
    var image: UIImage?
    
    var body: some View {
        Image(uiImage: image != nil ? image! : UIImage(named: "place_image_placeholder")!)
            .renderingMode(.original)
            .resizable()
            .scaledToFill()
            .animation(.easeInOut)
    }
}
