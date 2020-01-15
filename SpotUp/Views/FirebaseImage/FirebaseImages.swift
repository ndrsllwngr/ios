import SwiftUI
import SDWebImageSwiftUI
import FirebaseStorage

struct FirebaseProfileImage: View {
    
    var imageUrl: String?
    
    var body: some View {
        
        VStack {
            if (imageUrl != nil) {
                WebImage(url: URL(string: imageUrl!))
                    .onSuccess { image, cacheType in
                        // Success
                }
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
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Image(uiImage: UIImage(named: "profile_image_placeholder")!)
                    .resizable()
                    .animation(.easeInOut(duration: 0.5))
                    .transition(.fade)
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }
            
        }
        
    }
}
