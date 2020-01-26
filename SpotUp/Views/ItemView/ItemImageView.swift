import SwiftUI
import GooglePlaces

struct ItemImageView: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .renderingMode(.original)
            .resizable()
            .scaledToFill()
            .clipShape(Rectangle())
            .frame(height: 300)
        
    }
}
