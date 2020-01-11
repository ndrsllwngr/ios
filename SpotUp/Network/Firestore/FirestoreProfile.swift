import Foundation
import FirebaseFirestore
import GooglePlaces

class FirestoreProfile: ObservableObject {
    
    @Published var userProfileListener: ListenerRegistration? = nil
    @Published var placeListsListener: ListenerRegistration? = nil
    @Published var listOwnerListeners: [ListenerRegistration?] = []
    
    
    @Published var user: User? = nil
    @Published var placeLists: [PlaceList] = []
    
    
    // Call when entering view (.onAppear()) to create listeners for all data needed
    func addProfileListener(currentUserId: String, isMyProfile: Bool) {
        
        // Listener for my user
        self.userProfileListener = FirestoreConnection.shared.getUsersRef().document(currentUserId).addSnapshotListener { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot else {
                print("Error retrieving user")
                return
            }
            documentSnapshot.data().flatMap({ data in
                self.user = dataToUser(data: data)
            })
        }
        
        let ref = isMyProfile ? FirestoreConnection.shared.getPlaceListsRef().whereField("follower_ids", arrayContains: currentUserId) : FirestoreConnection.shared.getPlaceListsRef().whereField("follower_ids", arrayContains: currentUserId).whereField("is_public", isEqualTo: true)
        // Listener for my lists
        self.placeListsListener = ref.addSnapshotListener { querySnapshot, error in
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
                        self.placeLists[i].owner.username = username
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
        print("Successfully removed listener")
    }
    
}
