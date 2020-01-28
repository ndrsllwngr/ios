import Foundation
import FirebaseFirestore
import GooglePlaces
import Combine

class FirestoreSearch: ObservableObject {
    var allAllUsersListener: ListenerRegistration? = nil
    var allPublicPlaceListsListener: ListenerRegistration? = nil
    var listOwnerListeners: [ListenerRegistration?] = []
    
    let objectWillChange = ObservableObjectPublisher()
    @Published var allUsers: [User] = [] {
        didSet {
            objectWillChange.send()
        }
    }
    @Published var allPublicPlaceLists: [PlaceList] = [] {
        didSet {
            objectWillChange.send()
        }
    }
    
    
    func addAllUsersListener() {
        let ref = FirestoreConnection.shared.getUsersRef()
        self.allAllUsersListener = ref.addSnapshotListener{ querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                print("Error retrieving all users")
                return
            }
            self.allUsers = querySnapshot.documents.map{(documentSnapshot) in
                let data = documentSnapshot.data()
                return dataToUser(data: data)
            }
        }
        
    }
    
    func addAllPublicPlaceListsListener() {
        let ref =
            FirestoreConnection.shared.getPlaceListsRef().whereField("is_public", isEqualTo: true)
        self.allPublicPlaceListsListener = ref.addSnapshotListener { querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                print("Error retrieving all public place lists")
                return
            }
            self.allPublicPlaceLists = querySnapshot.documents.map{(documentSnapshot) in
                let data = documentSnapshot.data()
                return dataToPlaceList(data: data)
            }
            for (i, placeList) in self.allPublicPlaceLists.enumerated() {
                // Listener for owners of these lists (basically myself)
                self.listOwnerListeners.append(FirestoreConnection.shared.getUsersRef().document(placeList.owner.id).addSnapshotListener { documentSnapshot, error in
                    guard let documentSnapshot = documentSnapshot else {
                        print("Error retrieving user")
                        return
                    }
                    documentSnapshot.data().flatMap({ data in
                        let username = data["username"] as! String
                        if self.allPublicPlaceLists.count > i {
                            self.allPublicPlaceLists[i].owner.username = username
                        }
                    })
                })
            }
        }
        
    }
    
    func removeAllUsersListener() {
        print("removeAllUsersListener()")
        self.allAllUsersListener?.remove()
        //self.allUsers = []
    }
    
    func removeAllPublicPlaceListsListener() {
        print("removeAllPublicPlaceListsListener()")
        self.allPublicPlaceListsListener?.remove()
        self.listOwnerListeners.forEach{ listener in
            listener?.remove()
        }
    }
}
