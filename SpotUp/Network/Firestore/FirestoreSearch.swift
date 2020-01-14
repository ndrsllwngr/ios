import Foundation
import FirebaseFirestore
import GooglePlaces
import Combine

class FirestoreSearch: ObservableObject {
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
        print("Successfully removed allPublicPlaceListsListener")
    }
}
