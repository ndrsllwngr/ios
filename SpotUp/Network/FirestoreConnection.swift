//
//  UserLists.swift
//  SpotUp
//
//  Created by Timo Erdelt on 15.12.19.
//

import Foundation
import FirebaseFirestore

let db = Firestore.firestore()
let dbUsersRef = db.collection("users")
let dbLocationListsRef = db.collection("location_lists")

func createUser(uid: String, email: String?) {
    dbUsersRef.document(uid).setData([
        "email": email,
        "lists": []
    ])
}


func createLocationList(currentUserId: String, listName: String) {
    // 1. Add an empty location_list document with a generated ID
    let listRef = dbLocationListsRef.document()
    let listId = listRef.documentID
    
    // 2. Add data to location_list document
    listRef.setData([
        "id": listId,
        "name": listName,
        "owner_id": currentUserId
    ]) { err in
        if let err = err {
            print("Error adding document: \(err)")
        } else {
            print("Document added with ID: \(listId)")
            // add list_id to current_user
            db.collection("users").document(currentUserId).updateData(["lists": FieldValue.arrayUnion([listId])])
        }
    }
}


class FirestoreProfile: ObservableObject {
    
    @Published var locationLists: [LocationList] = []
    @Published var userListener: ListenerRegistration? = nil
    @Published var listsListener: ListenerRegistration? = nil
    
    func addProfileListener(currentUserId: String) {
        // 1. get listIds from user profile
        self.userListener = dbUsersRef.document(currentUserId).addSnapshotListener { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot else {
                print("Error retrieving user")
                return
            }
            documentSnapshot.data().flatMap({ (data) in
                let user = User(email: data["email"] as! String, lists: data["lists"] as! [String])
                let listIds = user.lists
                
                // 2. use retrieved listIds to get lists of user
                if !listIds.isEmpty {
                    self.listsListener = dbLocationListsRef.whereField("id", in: listIds).addSnapshotListener { (querySnapshot, error) in
                        guard let querySnapshot = querySnapshot else {
                            print("Error retrieving Lists")
                            return
                        }
                        self.locationLists = querySnapshot.documents.map { (documentSnapshot) in
                            let data = documentSnapshot.data()
                            return LocationList(id: data["id"] as! String, name: data["name"] as! String, ownerId: data["owner_id"] as! String)
                        }
                    }
                }
            })
        }
    }
    
    func removeProfileListener(){
        self.userListener?.remove()
        self.listsListener?.remove()
        print("Successfully removed listener")
    }
    
}

