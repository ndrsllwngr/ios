//
//  UserLists.swift
//  SpotUp
//
//  Created by Timo Erdelt on 15.12.19.
//

import Foundation
import FirebaseFirestore

class FirestoreProfile: ObservableObject {
    
    @Published var locationLists: [LocationList] = []
    @Published var userListener: ListenerRegistration? = nil
    @Published var listsListener: ListenerRegistration? = nil

    
    
    func addProfileListener(currentUserId: String) {
        let docRefUsers = db.collection("users").document(currentUserId)
        
        self.userListener = docRefUsers.addSnapshotListener { documentSnapshot, error in
            if let user = documentSnapshot.flatMap({
                $0.data().flatMap({ (data) in
                    return User(email: data["email"] as! String, lists: data["lists"] as! [String])
                })
            }) {
                print("User: \(user)")
                let listIds = user.lists
                if !listIds.isEmpty {
                    self.listsListener = db.collection("location_lists").whereField("id", in: listIds).addSnapshotListener { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                        } else {
                            self.locationLists = querySnapshot!.documents.map {
                                let data = $0.data()
                                let locationList = LocationList(id: data["id"] as! String, name: data["name"] as! String, ownerId: data["owner_id"] as! String)
                                print(locationList)
                                return locationList
                            }
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
            
        }
    }
    func removeProfileListener(){
        self.userListener?.remove()
        self.listsListener?.remove()
        print("Successfully removed listener")
    }
    
}

