import Foundation
import FirebaseFirestore
import GooglePlaces

class FirestoreProfile: ObservableObject {
    
    @Published var user: User = User(id: "loading", email: "loading", username: "loading")
    @Published var placeLists: [PlaceList] = []
    
    var userProfileListener: ListenerRegistration? = nil
    var placeListsListener: ListenerRegistration? = nil
    var listOwnerListeners: [ListenerRegistration?] = []
    
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
        // It would be best to do sorting and only public lists on !isMyProfile here but its not possible with firestore
        let query = FirestoreConnection.shared.getPlaceListsRef().whereField("follower_ids", arrayContains: profileUserId)
        
        // Listener for placelists
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
                // Listener for owners of these lists
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
    
    func removeProfileListener(){
        self.userProfileListener?.remove()
        self.placeListsListener?.remove()
        self.listOwnerListeners.forEach{ listener in
            listener?.remove()
        }
        print("Successfully removed profile listener")
    }
    
}
