import Foundation
import FirebaseFirestore
import GooglePlaces

class FirestorePlaceList: ObservableObject {
    
    @Published var placeListListener: ListenerRegistration? = nil
    @Published var ownerListener: ListenerRegistration? = nil
    
    @Published var placeList: PlaceList = PlaceList(name: "loading", owner: ListOwner(id: "loading", username: "loading"), followerIds: [])
    @Published var places: [GMSPlace] = []
    @Published var isOwnedPlaceList = false
    
    // Call when entering view (.onAppear()) to create listeners for all data needed
    func addPlaceListListener(placeListId: String, ownUserId: String) {
        
        // Listener for placeList
        self.placeListListener =
            FirestoreConnection.shared.getPlaceListsRef().document(placeListId).addSnapshotListener { documentSnapshot, error in
                guard let documentSnapshot = documentSnapshot else {
                    print("Error retrieving user")
                    return
                }
                documentSnapshot.data().flatMap({ data in
                    let fetchedPlaceList = dataToPlaceList(data: data)
                    print("placeListListener triggered: \(fetchedPlaceList.name)")
                    self.placeList = fetchedPlaceList
                    self.isOwnedPlaceList = fetchedPlaceList.owner.id == ownUserId
                    
                    self.ownerListener =
                        FirestoreConnection.shared.getUsersRef().document(fetchedPlaceList.owner.id).addSnapshotListener { documentSnapshot, error in
                            guard let documentSnapshot = documentSnapshot else {
                                print("Error retrieving user")
                                return
                            }
                            documentSnapshot.data().flatMap({ data in
                                let username = data["username"] as! String
                                self.placeList.owner.username = username
                            })
                    }
                    
                    
                    self.places = []
                    self.placeList.placeIds
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
        self.ownerListener?.remove()
        self.places = []
        print("Successfully removed placeListListener")
    }
}
