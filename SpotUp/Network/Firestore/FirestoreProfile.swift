import Foundation
import FirebaseFirestore
import GooglePlaces

class FirestoreProfile: ObservableObject {
    
    var userProfileListener: ListenerRegistration? = nil
    var placeListsListener: ListenerRegistration? = nil
    var listOwnerListeners: [ListenerRegistration?] = []
    
    @Published var user: User = User(id: "loading", email: "loading", username: "loading")
    @Published var placeLists: [PlaceList] = []
    
    // Call when entering view (.onAppear()) to create listeners for all data needed
    func addProfileListener(profileUserId: String) {
        // Listener for my user
        self.userProfileListener = FirestoreConnection.shared.getUsersRef().document(profileUserId).addSnapshotListener { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot else {
                print("Error retrieving user")
                return
            }
            documentSnapshot.data().flatMap({ data in
                let newUser = dataToUser(data: data)
                print("userProfileListener triggered: \(newUser.username)")
                self.user = newUser
            })
        }
        // It would be best to do sorting and only public lists on !isMyProfile here but its not possible with firebase
        let query = FirestoreConnection.shared.getPlaceListsRef().whereField("follower_ids", arrayContains: profileUserId)
        
        // Listener for my lists
        self.placeListsListener = query.addSnapshotListener { querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                print("Error retrieving Lists")
                return
            }
            self.placeLists = querySnapshot.documents.map { (documentSnapshot) in
                let data = documentSnapshot.data()
                return dataToPlaceList(data: data)
            }
            for (i, placeList) in self.placeLists.enumerated() {
                // Listener for owners of these lists (basically myself)
                self.listOwnerListeners.append(FirestoreConnection.shared.getUsersRef().document(placeList.owner.id).addSnapshotListener { documentSnapshot, error in
                    guard let documentSnapshot = documentSnapshot else {
                        print("Error retrieving user")
                        return
                    }
                    documentSnapshot.data().flatMap({ data in
                        let username = data["username"] as! String
                        if self.placeLists.count > i {
                            self.placeLists[i].owner.username = username
                        }
                    })
                })
            }
        }
    }
    
    // Should be called when leaving view (.onDisappear) to remove the listeners again!
    func removeProfileListener(){
        self.userProfileListener?.remove()
        self.placeListsListener?.remove()
        //self.followedListsListener?.remove()
        self.listOwnerListeners.forEach{ listener in
            listener?.remove()
        }
        print("Successfully removed profile listener")
    }
    
}

func sortPlaceLists(placeLists: [PlaceList], sortByCreationDate: Bool) -> [PlaceList] {
    if sortByCreationDate {
        // New Placelists always first!
        return placeLists.sorted{$0.createdAt.dateValue() > $1.createdAt.dateValue()}
    } else {
        return placeLists.sorted{$0.name < $1.name}
    }
}
