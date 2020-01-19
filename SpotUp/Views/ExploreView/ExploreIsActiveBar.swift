import SwiftUI

struct ExploreIsActiveBar: View {
    @ObservedObject var exploreModel = ExploreModel.shared
    var body: some View {
        HStack {
            Image(systemName: "map.fill")
            Text("Exploring... ")
            Spacer()
            if (self.exploreModel.exploreList != nil && self.exploreModel.exploreList!.currentTarget != nil) {
                Text(self.exploreModel.exploreList!.currentTarget!.place.name!)
                ExploreIsActiveCurrentTargetImage(image: self.exploreModel.exploreList!.currentTarget!.image != nil ? self.exploreModel.exploreList!.currentTarget!.image! : UIImage())
            } else {
                Text("No current target")
            }
        }.padding(.trailing).padding(.leading)
    }
}

struct ExploreIsActiveCurrentTargetImage: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .renderingMode(.original)
            .resizable()
            .clipShape(Circle())
            .scaledToFill()
            .frame(width: 35, height: 35)
    }
}
