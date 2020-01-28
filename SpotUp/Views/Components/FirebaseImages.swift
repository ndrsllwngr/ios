import SwiftUI
import SDWebImageSwiftUI
import FirebaseStorage

// Use .renderingMode(.original)! If not used image might show in black if is e.g. inside a button https://stackoverflow.com/questions/58845319/swiftui-button-images-showing-up-black

struct FirebaseProfileImage: View {
    
    var imageUrl: String?
    
    var body: some View {
        
        VStack {
            if (imageUrl != nil) {
                WebImage(url: URL(string: imageUrl!))
                    .onSuccess { image, cacheType in
                        // Success
                }
                .renderingMode(.original)
                    .resizable() // Resizable like SwiftUI.Image
                    .placeholder(Image(systemName: "profile_image_placeholder")) // Placeholder Image
                    // Supports ViewBuilder as well
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                }
                    .animated() // Supports Animated Image
                    .indicator(.activity) // Activity Indicator
                    .animation(.easeInOut(duration: 0.5)) // Animation Duration
                    .transition(.fade) // Fade Transition
                    .scaledToFit()
            } else {
                Image(uiImage: UIImage(named: "profile_image_placeholder")!)
                    .renderingMode(.original)
                    .resizable()
                    .animation(.easeInOut(duration: 0.5))
                    .transition(.fade)
                    .scaledToFit()
            }
        }
    }
}

struct FirebasePlaceListInfoImage: View {
    
    var imageUrl: String?
    
    var body: some View {
        
        VStack {
            if (imageUrl != nil) {
                WebImage(url: URL(string: imageUrl!))
                    .onSuccess { image, cacheType in
                        // Success
                }
                .renderingMode(.original)
                    .resizable() // Resizable like SwiftUI.Image
                    .placeholder(Image(systemName: "placelist_image_placeholder")) // Placeholder Image
                    // Supports ViewBuilder as well
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                }
                    .animated() // Supports Animated Image
                    .indicator(.activity) // Activity Indicator
                    .animation(.easeInOut(duration: 0.5)) // Animation Duration
                    .transition(.fade) // Fade Transition
            } else {
                Image(uiImage: UIImage(named: "placelist_image_placeholder")!)
                    .renderingMode(.original)
                    .resizable()
                    .animation(.easeInOut(duration: 0.5))
                    .transition(.fade)
            }
        }
    }
}

struct FirebasePlaceListRowImage: View {
    
    var imageUrl: String?
    
    var body: some View {
        
        VStack {
            if (imageUrl != nil) {
                WebImage(url: URL(string: imageUrl!))
                    .onSuccess { image, cacheType in
                        // Success
                }
                .renderingMode(.original)
                    .resizable() // Resizable like SwiftUI.Image
                    .placeholder(Image(systemName: "placelist_image_placeholder")) // Placeholder Image
                    // Supports ViewBuilder as well
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                }
                    .animated() // Supports Animated Image
                    .indicator(.activity) // Activity Indicator
                    .animation(.easeInOut(duration: 0.5)) // Animation Duration
                    .transition(.fade) // Fade Transition
            } else {
                Image(uiImage: UIImage(named: "placelist_image_placeholder")!)
                    .renderingMode(.original)
                    .resizable()
                    .animation(.easeInOut(duration: 0.5))
                    .transition(.fade)
            }
        }
    }
}
