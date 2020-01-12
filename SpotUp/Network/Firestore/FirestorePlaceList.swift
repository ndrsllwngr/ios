import Foundation
import FirebaseFirestore
import GooglePlaces

class FirestorePlaceList: ObservableObject {
    
    @Published var placeListListener: ListenerRegistration? = nil
    @Published var placeList: PlaceList? = nil
    @Published var places: [GMSPlace] = []
    
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
                self.places = []
                
                fetchedPlaceList.placeIds
                    .forEach {placeId in
                        //dispatchGroup.enter()
                        getPlace(placeID: placeId) { (place: GMSPlace?, error: Error?) in
                            if let error = error {
                                print("An error occurred : \(error.localizedDescription)")
                                return
                            }
                            if let place = place {
                                self.places.append(place)
                            }
                        }
                }
            })
        }
    }
    
    func removePlaceListListener() {
        self.placeListListener?.remove()
        self.placeList = nil
        self.places = []
    }
}
