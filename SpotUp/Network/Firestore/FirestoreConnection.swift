import Foundation
import FirebaseFirestore
import GooglePlaces


class FirestoreConnection: ObservableObject {
    static let shared = FirestoreConnection()
    private static let db: Firestore = Firestore.firestore()
    
    private let dbUsersRef = db.collection("users")
    private let dbPlaceListsRef = db.collection("place_lists")
    
    
    private init(){
        FirestoreConnection.db.clearPersistence()
    }
    
    // GET REFs
    func getUsersRef() -> CollectionReference {
        return dbUsersRef
    }
    
    func getPlaceListsRef() -> CollectionReference {
        return dbPlaceListsRef
    }
    
    // FUNCTIONS
    func createUserInFirestore(user: User) {
        dbUsersRef.document(user.id).setData(userToData(user: user))
    }
    
    func deleteUserInFirestore(userId: String) {
        let dispatchGroup = DispatchGroup()
        let userRef = dbUsersRef.document(userId)
        userRef.getDocument{ documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot else {
                print("Error retrieving user")
                return
            }
            documentSnapshot.data().flatMap({ data in
                let user = dataToUser(data: data)
                //bei meinen Followers mich raus löschen
                if(!user.isFollowedBy.isEmpty){
                    for byOtherId in user.isFollowedBy {
                        dispatchGroup.enter()
                        self.dbUsersRef.document(byOtherId).updateData([
                            "is_following": FieldValue.arrayUnion([userId])
                        ]) { err in
                            if let err = err {
                                print("Error following user: \(err)")
                            } else {
                                dispatchGroup.leave()
                                print("User successfully unfollowed is_following")
                            }
                        }
                    }
                }
                //bei den Leuten, denen ich folge, MICH raus löschen
                if(!user.isFollowing.isEmpty) {
                    for isOtherId in user.isFollowing {
                        dispatchGroup.enter()
                        self.dbUsersRef.document(isOtherId).updateData([
                            "is_followed_by": FieldValue.arrayUnion([userId])
                        ]) { err in
                            if let err = err {
                                print("Error following user: \(err)")
                            } else {
                                dispatchGroup.leave()
                                print("User successfully unfollowed is_followed_by")
                            }
                        }
                    }
                }
            })

        }
            
        dispatchGroup.notify(queue: .main) {
            userRef.delete() { err in
                if let err = err {
                    print("Error removing user: \(err)")
                } else {
                    print("User successfuly deleted from firestore")
                }
            }
        }
    }
        
    
    func updateUserName(userId: String, newUserName: String) {
        let userRef = dbUsersRef.document(userId)
        userRef.updateData([
            "username": newUserName
        ]) { err in
            if let err = err {
                print("Error updating User username: \(err)")
            } else {
                print("User username successfully updated")
            }
        }
    }
    
    func updateUserEmail(userId: String, newEmail: String) {
        let userRef = dbUsersRef.document(userId)
        userRef.updateData([
            "email": newEmail
        ]) { err in
            if let err = err {
                print("Error updating User email: \(err)")
            } else {
                print("User email successfully updated")
            }
        }
    }
    
    func createPlaceList(placeList: PlaceList) {
        // 1. Add an empty place_list document with a generated ID
        let listRef = dbPlaceListsRef.document(placeList.id)
        
        // 2. Add data to place_list document
        listRef.setData(placeListToData(placeList: placeList)) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("PlaceList added with ID: \(placeList.id)")
            }
        }
    }
    
    // ToDo update with more parameters
    func updatePlaceList(placeListId: String, newName: String? = nil, isPublic: Bool? = nil, isCollaborative: Bool? = nil) {
        let listRef = dbPlaceListsRef.document(placeListId)
        var data: Dictionary<String, Any> = [:]
        if let newName = newName {
            data["name"] = newName
        }
        if let isPublic = isPublic {
            data["is_public"] = isPublic
        }
        if let isCollaborative = isCollaborative {
            data["is_collaborative"] = isCollaborative
        }
        data["modified_at"] = Timestamp()
        listRef.updateData(data) { err in
            if let err = err {
                print("Error updating PlaceList: \(err)")
            } else {
                print("PlaceList successfully updated")
            }
        }
    }
    
    func deletePlaceList(placeListToDelete: PlaceList) {
        dbPlaceListsRef.document(placeListToDelete.id).delete() { err in
            if let err = err {
                print("Error deleting PlaceList: \(err)")
            } else {
                print("PlaceList successfully deleted")
            }
        }
    }
    
    func addPlaceToList(placeList: PlaceList, placeId: String, placeImage: UIImage?) {
        
        let listRef = dbPlaceListsRef.document(placeList.id)
            
        listRef.updateData([
            "places":
                FieldValue.arrayUnion([placeIDWithTimestampToData(place: PlaceIDWithTimestamp(placeId: placeId, addedAt: Timestamp()))]),
            "modified_at": Timestamp()
        ]) { err in
            if let err = err {
                print("Error adding place to PlaceList: \(err)")
            } else {
                print("Place successfully added")
            }
        }
        
        // If this is the first place of the placeList upload placeListImage to Storage
        if let placeImage = placeImage {
            if (placeList.imageUrl == nil || placeList.places.isEmpty) {
                    FirebaseStorage.shared.uploadImageToStorage(id: placeList.id, imageType: .PLACELIST_IMAGE, uiImage: placeImage)
            }
        }
    }
    
    func deletePlaceFromList(placeListId: String, place: GMSPlaceWithTimestamp) {
        
        let listRef = dbPlaceListsRef.document(placeListId)
        let data = placeIDWithTimestampToData(place: place.toPlaceIdWithTimeStamp())
        listRef.updateData([
            "places": FieldValue.arrayRemove([data]),
            "modified_at": Timestamp()
        ]) { err in
            if let err = err {
                print("Error removing place from PlaceList: \(err)")
            } else {
                print("Place successfully removed")
            }
        }
    }
    
    
    
    func followPlaceList(userId: String, placeListId: String) {
        let listRef = dbPlaceListsRef.document(placeListId)
        listRef.updateData([
            "follower_ids": FieldValue.arrayUnion([userId])
        ]) { err in
            if let err = err {
                print("Error following PlaceList: \(err)")
            } else {
                print("PlaceList successfully followed")
            }
        }
    }
    
    func unfollowPlaceList(userId: String, placeListId: String) {
        let listRef = dbPlaceListsRef.document(placeListId)
        listRef.updateData([
            "follower_ids": FieldValue.arrayRemove([userId])
        ]) { err in
            if let err = err {
                print("Error unfollowing PlaceList: \(err)")
            } else {
                print("PlaceList successfully unfollowed")
            }
        }
    }
    
    func followUser(myUserId: String, userIdToFollow: String) {
        dbUsersRef.document(myUserId).updateData([
            "is_following": FieldValue.arrayUnion([userIdToFollow])
        ]) { err in
            if let err = err {
                print("Error following user: \(err)")
            } else {
                print("User successfully followed is_following")
            }
        }
        dbUsersRef.document(userIdToFollow).updateData([
            "is_followed_by": FieldValue.arrayUnion([myUserId])
        ]) { err in
            if let err = err {
                print("Error following user: \(err)")
            } else {
                print("User successfully followed is_followed_by")
            }
        }
    }
    
    func unfollowUser(myUserId: String, userIdToFollow: String) {
        dbUsersRef.document(myUserId).updateData([
            "is_following": FieldValue.arrayRemove([userIdToFollow])
        ]) { err in
            if let err = err {
                print("Error unfollowing user is_following: \(err)")
            } else {
                print("User successfully unfollowed is_following")
            }
        }
        dbUsersRef.document(userIdToFollow).updateData([
            "is_followed_by": FieldValue.arrayRemove([myUserId])
        ]) { err in
            if let err = err {
                print("Error unfollowing user is_followed_by: \(err)")
            } else {
                print("User successfully unfollowed is_followed_by")
            }
        }
    }
    
    func addImageUrlToFirestore(id: String, imageType: ImageType, downloadURL: URL) {
        switch imageType {
        case .PROFILE_IMAGE:
            dbUsersRef.document(id).updateData([
                "image_url": downloadURL.absoluteString
            ]) { err in
                if let err = err {
                    print("Error adding profile imageUrl: \(err)")
                } else {
                    print("profile imageUrl successfully added")
                }
            }
        case .PLACELIST_IMAGE:
            dbPlaceListsRef.document(id).updateData([
                "image_url": downloadURL.absoluteString
            ]) { err in
                if let err = err {
                    print("Error adding placeList imageUrl: \(err)")
                } else {
                    print("placeList imageUrl successfully added")
                }
            }
        }
        
        
    }
}
