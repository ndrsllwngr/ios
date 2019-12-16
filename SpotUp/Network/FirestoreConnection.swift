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

func createUserInFirestore(uid: String, email: String, username: String) {
    dbUsersRef.document(uid).setData([
        "email": email,
        "username": username,
        "lists": []
    ])
}


func createPlaceList(currentUserId: String, listName: String) {
    // 1. Add an empty place_list document with a generated ID
    let listRef = dbPlaceListsRef.document()
    let listId = listRef.documentID
    
    // 2. Add data to place_list document
    listRef.setData([
        "id": listId,
        "name": listName,
        "owner_id": currentUserId
    ]) { err in
        if let err = err {
            print("Error adding document: \(err)")
        } else {
            print("Document added with ID: \(listId)")
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

func deletePlaceList(currentUserId: String, placeListId: String) {
    dbPlaceListsRef.document(placeListId).delete() { err in
        if let err = err {
            print("Error deleting PlaceList: \(err)")
        } else {
            dbUsersRef.document(currentUserId).updateData([
                "lists": FieldValue.arrayRemove([placeListId])
            ])
            print("PlaceList successfully deleted")
        }
    }
    
}

class FirestoreProfile: ObservableObject {
    
    @Published var placeLists: [PlaceList] = []
    @Published var user: User? = nil
    @Published var userListener: ListenerRegistration? = nil
    @Published var listsListener: ListenerRegistration? = nil
    
    func addProfileListener(currentUserId: String) {
        
        self.userListener = dbUsersRef.document(currentUserId).addSnapshotListener { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot else {
                print("Error retrieving user")
                return
            }
            documentSnapshot.data().flatMap({ (data) in
                self.user = User(email: data["email"] as! String, username: data["username"] as! String, lists: data["lists"] as! [String])
            })
        }
        self.listsListener = dbPlaceListsRef.whereField("owner_id", isEqualTo: currentUserId).addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error retrieving Lists")
                return
            }
            self.placeLists = querySnapshot.documents.map { (documentSnapshot) in
                let data = documentSnapshot.data()
                return PlaceList(id: data["id"] as! String, name: data["name"] as! String, ownerId: data["owner_id"] as! String)
            }
        }
        
    }
    
    func removeProfileListener(){
        self.userListener?.remove()
        self.listsListener?.remove()
        print("Successfully removed listener")
    }
    
}

