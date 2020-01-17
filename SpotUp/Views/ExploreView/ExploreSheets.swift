import SwiftUI
import GooglePlaces

struct ExplorePlaceMenuSheet: View {
    var place: GMSPlace
    
    @Binding var image: UIImage?
    @Binding var showSheet: Bool

    @State var showAddPlaceToListSheet: Bool = false
    
    var body: some View {
        VStack {
            Text("Place Menu")
            Spacer()
            Button(action: {
                self.showSheet.toggle()
                ExploreModel.shared.removePlaceFromExplore(self.place)
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
            Spacer()
        }
        .sheet(isPresented: $showAddPlaceToListSheet) {
            AddPlaceToListSheet(place: self.place, placeImage: self.$image, showSheet: self.$showAddPlaceToListSheet)
        }
    .padding()
    }
}

struct ExploreSettingsSheet: View {

    @Binding var showSheet: Bool
    
    var body: some View {
        VStack {
            Text("Explore Settings")
            Spacer()
            .padding()
            Button(action: {
                print("Pause Exploring")
            }) {
                Text("Pause Exploring")
            }
        .padding()
            Spacer()
        }
    .padding()
    }
}
