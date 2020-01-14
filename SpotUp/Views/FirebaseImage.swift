import SwiftUI




struct MyImage: View {
    var someImageId: String?
    var placeHolderImageId: String
    
    var body: some View {
        VStack {
            if (someImageId != nil) {
                FirebaseImage(imageId: someImageId!, placeHolderImageId: placeHolderImageId)
            } else {
                Image(uiImage: UIImage(named: self.placeHolderImageId)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .padding()
            }
        }
    }
}



struct FirebaseImage: View {
    
    var placeholderImage: UIImage
    
    @ObservedObject private var firebaseStorageImageLoader: FirebaseStorageImageLoader
    
    init(imageId: String, placeHolderImageId: String) {
        self.firebaseStorageImageLoader = FirebaseStorageImageLoader(id: imageId)
        self.placeholderImage = UIImage(named: placeHolderImageId)!
        
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
