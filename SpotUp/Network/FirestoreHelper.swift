//
//  FirestoreHelper.swift
//  SpotUp
//
//  Created by Timo Erdelt on 17.12.19.
//

import Foundation
import FirebaseFirestore


// OBJECT TO FIRESTORE DATA
func userToData(user: User) -> Dictionary<String, Any> {
    return [
        "id": user.id,
        "email": user.email,
        "username": user.username
    ]
}

func placeListToData(placeList: PlaceList) -> Dictionary<String, Any> {
    return [
        "id": placeList.id,
        "name": placeList.name,
        "owner_id": placeList.owner.id,
        "follower_ids": placeList.followerIds,
        "is_public": placeList.isPublic,
        "place_ids": placeList.placeIds
    ]
}


// FIRESTORE DATA TO OBJECT
func dataToUser(data: Dictionary<String, Any>) -> User {
    return User(id: data["id"] as! String,
                email: data["email"] as! String,
                username: data["username"] as! String)
}


func dataToPlaceList(data: Dictionary<String, Any>) -> PlaceList {
    return PlaceList(id: data["id"] as! String,
                     name: data["name"] as! String,
                     owner: SimpleUser(id: data["owner_id"] as! String, username: ""),
                     followerIds: data["follower_ids"] as! [String],
                     isPublic: data["is_public"] as! Bool,
                     placeIds: data["place_ids"] as! [String])
}
