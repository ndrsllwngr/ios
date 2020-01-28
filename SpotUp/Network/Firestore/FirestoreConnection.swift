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
        // When a user deletes his account it is not enough to just delete his reference from firestore
        // To delete a user thoroughly we have to
        let dispatchGroup = DispatchGroup()
        let userRef = dbUsersRef.document(userId)
        userRef.getDocument { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot else {
                print("UserDeletion: Error retrieving user")
                return
            }
            documentSnapshot.data().flatMap({ data in
                let user = dataToUser(data: data)
                
                // 1. Remove him from all users that were following him
                if(!user.isFollowedBy.isEmpty) {
                    dispatchGroup.enter()
                    user.isFollowedBy.forEach { isFollowedById in                      self.dbUsersRef.document(isFollowedById).updateData([
                        "is_following": FieldValue.arrayRemove([userId])
                    ]) { err in
                        if let err = err {
                            print("UserDeletion: Error removing user from is_following: \(err)")
                        } else {
                            print("UserDeletion: successfully removed user from is_following")
                        }
                        dispatchGroup.leave()
                        }
                    }
                }
                // 2. Remove him from all users that were followed by him
                if(!user.isFollowing.isEmpty) {
                    dispatchGroup.enter()
                    user.isFollowing.forEach { isFollowingId in                            self.dbUsersRef.document(isFollowingId).updateData([
                        "is_followed_by": FieldValue.arrayRemove([userId])
                    ]) { err in
                        if let err = err {
                            print("UserDeletion: Error removing user from is_followed_by: \(err)")
                        } else {
                            print("UserDeletion: successfully removed user from is_followed_by")
                        }
                        dispatchGroup.enter()
                        }
                    }
                }
                //3. Remove him from all placelists that he was following
                dispatchGroup.enter()
                self.dbPlaceListsRef.whereField("follower_ids", arrayContains: userId).getDocuments { querySnapshot, error in
                    guard let querySnapshot = querySnapshot else {
                        print("UserDeletion Error retrieving followed PlaceLists")
                        return
                    }
                    dispatchGroup.leave()
                    querySnapshot.documents.forEach { documentSnapshot in
                        dispatchGroup.enter()
                        let placeList = dataToPlaceList(data: documentSnapshot.data())
                        self.dbPlaceListsRef.document(placeList.id).updateData([
                            "follower_ids": FieldValue.arrayRemove([userId])
                        ]) { err in
                            if let err = err {
                                print("UserDeletion: Error removing user from followed PlaceList: \(err)")
                            } else {
                                print("UserDeletion: User successfully removed from followed PlaceList")
                            }
                            dispatchGroup.leave()
                        }
                        
                    }
                }
                //4. Remove all placelists created by that user
                dispatchGroup.enter()
                self.dbPlaceListsRef.whereField("owner_id", isEqualTo: userId).getDocuments { querySnapshot, error in
                    guard let querySnapshot = querySnapshot else {
                        print("UserDeletion: Error retrieving owned PlaceLists")
                        return
                    }
                    dispatchGroup.leave()
                    querySnapshot.documents.forEach { documentSnapshot in
                        dispatchGroup.enter()
                        let placeList = dataToPlaceList(data: documentSnapshot.data())
                        self.dbPlaceListsRef.document(placeList.id).delete() { err in
                            if let err = err {
                                print("UserDeletion: Error deleting owned PlaceList: \(err)")
                            } else {
                                print("UserDeletion: Owned PlaceList successfully deleted")
                            }
                            dispatchGroup.leave()
                        }
                    }
                }
                // 5. Delete user itself
                dispatchGroup.enter()
                userRef.delete() { err in
                    if let err = err {
                        print("UserDeletion: Error removing user: \(err)")
                    } else {
                        print("UserDeletion: User successfuly deleted")
                    }
                    dispatchGroup.leave()
                }
            })
        }
        // Wait till all tasks are finished
        dispatchGroup.wait()
        print("Finished deleteUserInFirestore: User thoroughly removed from firestore")
    }
    
    func updateUserName(userId: String, newUserName: String) {
        let userRef = dbUsersRef.document(userId)
        userRef.updateData([
            "username": newUserName
        ]) { err in
            if let err = err {
                print("Error updating user username: \(err)")
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
                print("Error updating user email: \(err)")
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
                print("Error adding PlaceList: \(err)")
            } else {
                print("PlaceList added with ID: \(placeList.id)")
            }
        }
    }
    
    func updatePlaceList(placeListId: String, newName: String? = nil, isPublic: Bool? = nil,  ownerId: String? = nil, isCollaborative: Bool? = nil) {
        let listRef = dbPlaceListsRef.document(placeListId)
        var data: Dictionary<String, Any> = [:]
        if let newName = newName {
            data["name"] = newName
        }
        if let isPublic = isPublic {
            data["is_public"] = isPublic
            // remove all followers on setting list private
            if let ownerId = ownerId, !isPublic {
                data["follower_ids"] = [ownerId]
            }
            
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
                print("Place successfully added to PlaceList")
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
                print("Place successfully removed from PlaceList")
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
