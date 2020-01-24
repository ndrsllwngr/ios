import SwiftUI
import GooglePlaces

struct SelectPlaceListToExploreSheet: View {
    @Binding var showSheet: Bool
    
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject var profile = FirestoreProfile()
    
    var body: some View {
        VStack {
            Text("Which of your Lists do you want to explore?")
            List {
                ForEach(profile.placeLists){ placeList in
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
            self.profile.addProfileListener(profileUserId: self.firebaseAuthentication.currentUser!.uid)
        }
        .onDisappear {
            self.profile.removeProfileListener()
        }
        .padding()
    }
}
