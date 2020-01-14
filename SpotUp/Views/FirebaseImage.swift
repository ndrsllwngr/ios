import SwiftUI

struct FirebaseImage: View {
    
    var placeholderImage: UIImage
    
    @ObservedObject private var firebaseStorageImageLoader: FirebaseStorageImageLoader
    
    init(id: String, placeholderImageString: String) {
        self.firebaseStorageImageLoader = FirebaseStorageImageLoader(id: id)
        self.placeholderImage = UIImage(named: placeholderImageString)!
        
    }
    
    var body: some View {
        Image(uiImage: firebaseStorageImageLoader.image ?? placeholderImage)
            .resizable()
        .scaledToFit()
        .frame(width: 100, height: 100)
        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        .padding()
    }
}
