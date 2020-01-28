import SwiftUI

struct PlaceRowImage: View {
    var image: UIImage?
    
    var body: some View {
        Image(uiImage: image != nil ? image! : UIImage(named: "placeholder-image-place-500")!)
            .renderingMode(.original)
            .resizable()
            .scaledToFill()
            .animation(.easeInOut)
    }
}
