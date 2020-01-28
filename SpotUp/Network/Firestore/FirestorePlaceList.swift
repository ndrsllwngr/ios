import Foundation
import FirebaseFirestore
import GooglePlaces

class FirestorePlaceList: ObservableObject {
    
    @Published var placeList: PlaceList = PlaceList(name: "loading", owner: ListOwner(id: "loading", username: "loading"), followerIds: [], createdAt: Timestamp.init())
    @Published var places: [GMSPlaceWithTimestamp] = []
    @Published var isOwnedPlaceList = false
    @Published var isLoadingPlaces = false
    
    var placeListListener: ListenerRegistration? = nil
    var ownerListener: ListenerRegistration? = nil
    
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
                    //print("placeListListener triggered: \(fetchedPlaceList.name)")
                    self.placeList = fetchedPlaceList
                    self.isOwnedPlaceList = fetchedPlaceList.owner.id == ownUserId
                    
                    // Listener for placeList owner
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
                    // Fetch places from places API
                    self.isLoadingPlaces = true
                    let dispatchGroup = DispatchGroup()
                    self.places = []
                    self.placeList.places
                        .forEach { placeIDWithTimestamp in
                            dispatchGroup.enter()
                            getPlaceSimple(placeID: placeIDWithTimestamp.placeId) { (place: GMSPlace?, error: Error?) in
                                if let error = error {
                                    print("An error occurred : \(error.localizedDescription)")
                                    dispatchGroup.leave()
                                    return
                                }
                                if let place = place {
                                    self.places.append(GMSPlaceWithTimestamp(gmsPlace: place, addedAt: placeIDWithTimestamp.addedAt))
                                    dispatchGroup.leave()
                                }
                            }
                    }
                    dispatchGroup.notify(queue: .main) {
                        self.isLoadingPlaces = false
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
