import Foundation
import FirebaseFirestore
import GooglePlaces

class FirestoreFollowSheet: ObservableObject {
    @Published var usersThatIAmFollowingListener: ListenerRegistration?
    @Published var usersThatAreFollowingMeListener: ListenerRegistration?
    @Published var usersThatIAmFollowing: [User] = []
    @Published var usersThatAreFollowingMe: [User] = []
    
    
    // To find all users that are following me we have to find all users in which my user is saved in is_following
    func addUsersThatAreFollowingMeListener(userId: String) {
        let ref = FirestoreConnection.shared.getUsersRef().whereField("is_following", arrayContains: userId)
        self.usersThatAreFollowingMeListener = ref.addSnapshotListener{ querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                print("Error retrieving users")
                return
            }
            self.usersThatAreFollowingMe = querySnapshot.documents.map { (documentSnapshot) in
                let user = dataToUser(data: documentSnapshot.data())
                return user
            }
        }
    }
    
    func removeUsersThatAreFollowingMeListener() {
        self.usersThatAreFollowingMeListener?.remove()
        self.usersThatAreFollowingMe = []
    }
    
    // To find all users that I am following we have find all users in which my user is saved in is_followed_by
    func addUsersThatIAmFollowingListener(userId: String) {
        let ref = FirestoreConnection.shared.getUsersRef().whereField("is_followed_by", arrayContains: userId)
        self.usersThatIAmFollowingListener = ref.addSnapshotListener{ querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                print("Error retrieving users")
                return
            }
            self.usersThatIAmFollowing = querySnapshot.documents.map { (documentSnapshot) in
                let user = dataToUser(data: documentSnapshot.data())
                return user
            }
        }
    }
    
    func removeUsersThatIAmFollowingListener() {
        self.usersThatIAmFollowingListener?.remove()
        self.usersThatIAmFollowing = []
    }
}
