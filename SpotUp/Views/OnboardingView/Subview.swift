import SwiftUI

struct Subview: View {
    // PROPS
    var imageString: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            Spacer()
            Image(uiImage: UIImage(named: imageString)!)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(height: 200, alignment: .bottom)
        }
        .frame(width: 250, height: 250, alignment: .center)
    }
}
