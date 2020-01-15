import SwiftUI

struct FirebaseProfileImage: View {
    
    var placeholderImage: UIImage
    @Binding var pickedImage: UIImage?
    
    
    @ObservedObject private var firebaseStorageImageLoader: FirebaseStorageImageLoader
    
    init(imageId: String, pickedImage: Binding<UIImage?>) {
        self.firebaseStorageImageLoader = FirebaseStorageImageLoader(id: imageId, imageType: .profile_image)
        self.placeholderImage = UIImage(named: "profile")!
        self._pickedImage = pickedImage
    }
    
    var body: some View {
        VStack {
            if pickedImage != nil {
                Image(uiImage: pickedImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .padding()
                    .animation(.linear)
            }
            else {
                Image(uiImage:firebaseStorageImageLoader.image ?? placeholderImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .padding()
                    .animation(.linear)
            }
        }
    }
}
