import SwiftUI

struct ExplorePlaceMenuSheet: View {
    var gmsPlaceWithTimestamp: GMSPlaceWithTimestamp
    
    @Binding var image: UIImage?
    @Binding var showSheet: Bool

    @State var showAddPlaceToListSheet: Bool = false
    
    var body: some View {
        VStack {
            Text("Place Menu")
            Button(action: {
                self.showSheet.toggle()
                print("delete place from explore")
            }) {
                Text("Delete place from Explore")
            }
            .padding()
            Button(action: {
                self.showAddPlaceToListSheet.toggle()
            }) {
                Text("Add to Placelist")
            }
        .padding()
        }
        .sheet(isPresented: $showAddPlaceToListSheet) {
            AddPlaceToListSheet(place: self.gmsPlaceWithTimestamp.gmsPlace, placeImage: self.$image, showSheet: self.$showAddPlaceToListSheet)
        }
    .padding()
    }
}
