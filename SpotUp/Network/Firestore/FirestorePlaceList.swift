import Foundation
import FirebaseFirestore
import GooglePlaces

class FirestorePlaceList: ObservableObject {
    
    @Published var placeListListener: ListenerRegistration? = nil
    @Published var placeList: PlaceList? = nil
    @Published var gmsPlaces: [GMSPlaceWithTimestamp] = []
    
    func addPlaceListListener(placeListId: String) {
        FirestoreConnection.shared.getPlaceListsRef().document(placeListId).addSnapshotListener { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot else {
                print("Error retrieving user")
                return
            }
            documentSnapshot.data().flatMap({ data in
                print("addPlaceListListener triggered")
                let fetchedPlaceList = dataToPlaceList(data: data)
                self.placeList = fetchedPlaceList
                self.gmsPlaces = []
                
                fetchedPlaceList.places
                    .forEach {placeWithTimestamp in
                        //dispatchGroup.enter()
                        getPlace(placeID: placeWithTimestamp.placeId) { (place: GMSPlace?, error: Error?) in
                            if let error = error {
                                print("An error occurred : \(error.localizedDescription)")
                                return
                            }
                            if let place = place {
                                self.gmsPlaces.append(GMSPlaceWithTimestamp(gmsPlace: place, addedAt: placeWithTimestamp.addedAt))
                            }
                        }
                }
            })
        }
    }
    
    func removePlaceListListener() {
        self.placeListListener?.remove()
        self.placeList = nil
        self.gmsPlaces = []
    }
}
