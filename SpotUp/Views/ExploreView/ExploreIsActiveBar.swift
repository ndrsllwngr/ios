import SwiftUI

struct ExploreIsActiveBar: View {
    @ObservedObject var exploreModel = ExploreModel.shared
    // PROPS
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            HStack {
                if (self.exploreModel.exploreList != nil && self.exploreModel.exploreList!.currentTarget != nil) {
                    PlaceRowImage(image: self.exploreModel.exploreList!.currentTarget!.image)
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                    VStack (alignment: .leading) {
                        Text(self.exploreModel.exploreList!.currentTarget!.place.name!)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        Text(self.exploreModel.exploreList!.currentTarget!.place.formattedAddress != nil ? self.exploreModel.exploreList!.currentTarget!.place.formattedAddress! : "")
                            .font(.system(size: 12))
                            .lineLimit(1)
                    }
                    Spacer()
                } else {
                    Image(uiImage: UIImage(named: "explore-empty-target-bw-40")!)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40, alignment: .center)
                    Spacer()
                    Text("No target selected")
                    Spacer()
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 50)
        .background(Color("brand-color-primary-soft"))
        .foregroundColor(Color.white)
        .onTapGesture {
            self.tabSelection = 0
        }
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
