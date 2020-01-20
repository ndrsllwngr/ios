import Foundation
import FirebaseFirestore
import GooglePlaces

class FirestorePlaceList: ObservableObject {
    
    @Published var placeListListener: ListenerRegistration? = nil
    @Published var ownerListener: ListenerRegistration? = nil
    
    @Published var placeList: PlaceList = PlaceList(name: "loading", owner: ListOwner(id: "loading", username: "loading"), followerIds: [], createdAt: Timestamp.init())
    @Published var places: [GMSPlaceWithTimestamp] = []
    @Published var isOwnedPlaceList = false
    
    init(placeListId: String, ownUserId: String) {
        self.addPlaceListListener(placeListId: placeListId, ownUserId: ownUserId)
    }
    
    
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
                    self.placeList.places
                        .forEach {placeIDWithTimestamp in
                            //dispatchGroup.enter()
                            getPlace(placeID: placeIDWithTimestamp.placeId) { (place: GMSPlace?, error: Error?) in
                                if let error = error {
                                    print("An error occurred : \(error.localizedDescription)")
                                    return
                                }
                                if let place = place {
                                    self.places.append(GMSPlaceWithTimestamp(gmsPlace: place, addedAt: placeIDWithTimestamp.addedAt))
                                    self.places.sort{ $0.addedAt.dateValue() < $1.addedAt.dateValue()}
                                }
                            }
                    }
                })
        }
    }
    
    // ToDo not needed?
    func removePlaceListListener() {
        self.placeListListener?.remove()
        self.ownerListener?.remove()
        self.places = []
        print("Successfully removed placeListListener")
    }
}
