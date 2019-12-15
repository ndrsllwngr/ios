//
//  DatabaseConnection.swift
//  SpotUp
//
//  Created by Timo Erdelt on 15.12.19.
//

import Foundation
import FirebaseFirestore



let db = Firestore.firestore()

func createUser(uid: String, email: String?) {
    
    let db = Firestore.firestore()
    db.collection("users").document(uid).setData([
        "email": email,
        "lists": []
    ])
}



func createLocationList(currentUserId: String, listName: String) {
    let db = Firestore.firestore()
    // Add a new document with a generated ID
    var ref: DocumentReference? = nil
    
    ref = db.collection("location_list").addDocument(data: [
        "name": listName,
        "owner_id": currentUserId
    ]) { err in
        if let err = err {
            print("Error adding document: \(err)")
        } else {
            let listId = ref!.documentID
            print("Document added with ID: \(listId)")
            // add list_id to current_user
            db.collection("users").document(currentUserId).updateData(["lists": FieldValue.arrayUnion([listId])])
        }
    }
}

