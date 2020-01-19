import SwiftUI
import GooglePlaces

struct ItemAddSheet: View {
    var place: GMSPlace
    @Binding var placeImage: UIImage?
    
    @Binding var showSheet: Bool
    
    @State var showAddPlaceToListSheet: Bool = false
    
    var body: some View {
        VStack {
            Text("What do you want to do with this place?")
            Spacer()
            Button(action: {
                self.showAddPlaceToListSheet.toggle()
            }) {
                Text("Add to Placelist")
            }.padding()
            Button(action: {
                ExploreModel.shared.addPlaceToExplore(self.place)
                self.showSheet.toggle()
                
            }) {
                Text("Add to Explore")
            }.padding()
            Spacer()
        }
        .sheet(isPresented: $showAddPlaceToListSheet) {
            AddPlaceToListSheet(place: self.place, placeImage: self.$placeImage, showSheet: self.$showAddPlaceToListSheet)
        }
        .padding()
    }
}
