import SwiftUI
import GooglePlaces

struct ItemAddSheet: View {
    var place: GMSPlace
    @Binding var placeImage: UIImage?
    
    @Binding var showSheet: Bool
    
    @State var showAddPlaceToListSheet: Bool = false
    
    var body: some View {
        VStack {
            Text("Add place to")
            Spacer()
            Button(action: {
                self.showAddPlaceToListSheet.toggle()
            }) {
                Text("Spot List")
            }.padding()
            Button(action: {
                ExploreModel.shared.addPlaceToExplore(self.place)
                self.showSheet.toggle()
                
            }) {
                Text("Explore")
            }.padding()
            Spacer()
        }
        .sheet(isPresented: $showAddPlaceToListSheet) {
            AddPlaceToListSheet(place: self.place, placeImage: self.$placeImage, showSheet: self.$showAddPlaceToListSheet)
        }
        .padding()
    }
}
