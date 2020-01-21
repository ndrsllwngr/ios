import SwiftUI
import GooglePlaces

struct ExplorePlaceMenuSheet: View {
    var place: ExplorePlace
    
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
            AddPlaceToListSheet(place: self.place.place, placeImage: self.$image, showSheet: self.$showAddPlaceToListSheet)
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

struct SelectPlaceListToExploreSheet: View {
    @Binding var showSheet: Bool
    
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject var profile = FirestoreProfile()
    
    var body: some View {
        VStack {
            Text("Which of your Lists do you want to explore?")
            List {
                ForEach(profile.placeLists.filter{ $0.owner.id == firebaseAuthentication.currentUser?.uid || $0.isCollaborative}){ placeList in
                    Button(action: {
                        ExploreModel.shared.startExploreWithPlaceListAndFetchPlaces(placeList: placeList)
                        self.showSheet.toggle()
                    }) {
                        PlacesListRow(placeList: placeList)
                    }
                }
            }
        }
        .onAppear {
            self.profile.addProfileListener(currentUserId: self.firebaseAuthentication.currentUser!.uid)
        }
        .onDisappear {
            self.profile.removeProfileListener()
        }
        .padding()
    }
}
