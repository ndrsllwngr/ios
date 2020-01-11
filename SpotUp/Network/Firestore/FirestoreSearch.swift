import Foundation
import FirebaseFirestore
import GooglePlaces

class FirestoreSearch: ObservableObject {
    @Published var allUsers: [User] = []
    @Published var allPublicPlaceLists: [PlaceList] = []
    @Published var allAllUsersListener: ListenerRegistration? = nil
    @Published var allPublicPlaceListsListener: ListenerRegistration? = nil
    
    
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
        }
    }
    
    func removeAllUsersListener() {
        self.allAllUsersListener?.remove()
        self.allUsers = []
    }
    
    func removeAllPublicPlaceListsListener() {
        self.allPublicPlaceListsListener?.remove()
        self.allPublicPlaceLists = []
    }
}
