//
//  UserLists.swift
//  SpotUp
//
//  Created by Timo Erdelt on 15.12.19.
//

import Foundation

class LocationListsForUser: ObservableObject {
    
    @Published var locationLists: [LocationList] = []
    
    func getLocationListsForUser(currentUserId: String) {
        let docRef = db.collection("users").document(currentUserId)
        docRef.getDocument { (document, error) in
            if let user = document.flatMap({
                $0.data().flatMap({ (data) in
                    return User(email: data["email"] as! String, lists: data["lists"] as! [String])
                })
            }) {
                print("User: \(user)")
                let listIds = user.lists
                if !listIds.isEmpty {
                    db.collection("location_lists").whereField("id", in: listIds).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
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
    
}

