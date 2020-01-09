//
//  FirestoreConnection.swift
//  SpotUp
//
//  Created by Timo Erdelt on 15.12.19.
//

import Foundation
import FirebaseFirestore
import GooglePlaces

let db = Firestore.firestore()
let dbUsersRef = db.collection("users")
let dbPlaceListsRef = db.collection("place_lists")

func createUserInFirestore(user: User) {
    dbUsersRef.document(user.id).setData(userToData(user: user))
}

func deleteUserInFirestore(userId: String) {
    let userRef = dbUsersRef.document(userId)
    userRef.delete() { err in
        if let err = err {
            print("Error removing user: \(err)")
        } else {
            print("User successfuly deleted from firestore")
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
func updatePlaceList(placeListId: String, newName: String) {
    let listRef = dbPlaceListsRef.document(placeListId)
    listRef.updateData([
        "name": newName
    ]) { err in
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

func addPlaceToList(placeID: String, placeListId: String) {
    let listRef = dbPlaceListsRef.document(placeListId)
    listRef.updateData([
        "place_ids": FieldValue.arrayUnion([placeID])
    ]) { err in
        if let err = err {
            print("Error adding place to PlaceList: \(err)")
        } else {
            print("Place successfully added")
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


class FirestoreProfile: ObservableObject {
    
    @Published var userProfileListener: ListenerRegistration? = nil
    @Published var placeListsListener: ListenerRegistration? = nil
    @Published var listOwnerListeners: [ListenerRegistration?] = []
    
    
    @Published var user: User? = nil
    @Published var placeLists: [PlaceList] = []
    
    
    // Call when entering view (.onAppear()) to create listeners for all data needed
    func addProfileListener(currentUserId: String, isMyProfile: Bool) {
        
        // Listener for my user
        self.userProfileListener = dbUsersRef.document(currentUserId).addSnapshotListener { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot else {
                print("Error retrieving user")
                return
            }
            documentSnapshot.data().flatMap({ data in
                self.user = dataToUser(data: data)
            })
        }
        
        let ref = isMyProfile ? dbPlaceListsRef.whereField("follower_ids", arrayContains: currentUserId) : dbPlaceListsRef.whereField("follower_ids", arrayContains: currentUserId).whereField("is_public", isEqualTo: true)
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
                self.listOwnerListeners.append(dbUsersRef.document(placeList.owner.id).addSnapshotListener { documentSnapshot, error in
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

class FirestorePlaceList: ObservableObject {
    
    @Published var placeListListener: ListenerRegistration? = nil
    @Published var placeList: PlaceList? = nil
    @Published var places: [GMSPlace] = []
    
    func addPlaceListListener(placeListId: String) {
        dbPlaceListsRef.document(placeListId).addSnapshotListener { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot else {
                print("Error retrieving user")
                return
            }
            documentSnapshot.data().flatMap({ data in
                print("ListenerTriggered")
                let fetchedPlaceList = dataToPlaceList(data: data)
                self.placeList = fetchedPlaceList
                self.places = []
                
                fetchedPlaceList.placeIds
                    .forEach {placeId in
                        //dispatchGroup.enter()
                        getPlace(placeID: placeId) { (place: GMSPlace?, error: Error?) in
                            if let error = error {
                                print("An error occurred : \(error.localizedDescription)")
                                return
                            }
                            if let place = place {
                                self.places.append(place)
                            }
                        }
                }
            })
        }
    }
    
    func removePlaceListListener() {
        self.placeListListener?.remove()
        self.placeList = nil
        self.places = []
    }
}

class FirestoreSearch: ObservableObject {
    // TODO use listeners
    @Published var allUsers: [User] = []
    @Published var allPublicPlaceLists: [PlaceList] = []
    
    func getAllUsers() {
        let ref = dbUsersRef
        ref.getDocuments{ querySnapshot, error in
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
    
    func getAllPublicPlaceLists() {
        let ref = dbPlaceListsRef.whereField("is_public", isEqualTo: true)
        ref.getDocuments{ querySnapshot, error in
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
    
    func cleanAllUsers() {
        self.allUsers = []
    }
    
    func cleanAllPublicPlaceLists() {
        self.allPublicPlaceLists = []
    }
}

