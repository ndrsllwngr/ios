//
//  FirestoreConnection.swift
//  SpotUp
//
//  Created by Timo Erdelt on 15.12.19.
//

import Foundation
import FirebaseFirestore

let db = Firestore.firestore()
let dbUsersRef = db.collection("users")
let dbPlaceListsRef = db.collection("place_lists")

func createUserInFirestore(user: User) {
    dbUsersRef.document(user.id).setData(userToData(user: user))
}

func updateUser(newUser: User) {
    let userRef = dbUsersRef.document(newUser.id)
    userRef.updateData([
        "username": newUser.username
    ]) { err in
        if let err = err {
            print("Error updating PlaceList: \(err)")
        } else {
            print("PlaceList successfully updated")
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

func deletePlaceList(placeListId: String) {
    dbPlaceListsRef.document(placeListId).delete() { err in
        if let err = err {
            print("Error deleting PlaceList: \(err)")
        } else {
            print("PlaceList successfully deleted")
        }
    }
    
}

class FirestoreProfile: ObservableObject {
    
    @Published var userProfileListener: ListenerRegistration? = nil
    @Published var ownedListsListener: ListenerRegistration? = nil
    //@Published var followedListsListener: ListenerRegistration? = nil
    @Published var listOwnerListeners: [ListenerRegistration?] = []

    
    @Published var user: User? = nil
    @Published var ownedPlaceLists: [PlaceList] = []
    //@Published var followedPlaceLists: [PlaceList] = []
    
    
    // Call when entering view (.onAppear()) to create listeners for all data needed
    func addProfileListener(currentUserId: String) {
        
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
        
        // Listener for my owned lists
        self.ownedListsListener = dbPlaceListsRef.whereField("owner_id", isEqualTo: currentUserId).addSnapshotListener { querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                print("Error retrieving Lists")
                return
            }
            self.ownedPlaceLists = querySnapshot.documents.map { (documentSnapshot) in
                let data = documentSnapshot.data()
                return dataToPlaceList(data: data)
            }
            for (i, placeList) in self.ownedPlaceLists.enumerated() {
                // Listener for owners of these lists (basically myself)
                self.listOwnerListeners.append(dbUsersRef.document(placeList.owner.id).addSnapshotListener { documentSnapshot, error in
                    guard let documentSnapshot = documentSnapshot else {
                        print("Error retrieving user")
                        return
                    }
                    documentSnapshot.data().flatMap({ data in
                        let username = data["username"] as! String
                        self.ownedPlaceLists[i].owner.username = username
                    })
                })
            }
        }
        
        //        self.followedListsListener = dbPlaceListsRef.whereField("follower_ids", arrayContains: currentUserId).addSnapshotListener { (querySnapshot, error) in
        //            guard let querySnapshot = querySnapshot else {
        //                print("Error retrieving Lists")
        //                return
        //            }
        //            self.followedPlaceLists = querySnapshot.documents.map { (documentSnapshot) in
        //                let data = documentSnapshot.data()
        //                var placeList =
        //                return PlaceList(id: data["id"] as! String,
        //                                 name: data["name"] as! String,
        //                                 ownerId: data["owner_id"] as! String,
        //                                 followerIds: data["follower_ids"] as! [String],
        //                                 isPublic: data["is_public"] as! Bool,
        //                                 placeIds: data["place_ids"] as! [String])
        //            }
        //        }
    }
    
    // Should be called when leaving view (.onDisappear) to remove the listeners again!
    func removeProfileListener(){
        self.userProfileListener?.remove()
        self.ownedListsListener?.remove()
        //self.followedListsListener?.remove()
        self.listOwnerListeners.forEach{ listener in
            listener?.remove()
        }
        print("Successfully removed listener")
    }
    
}

