import Foundation
import FirebaseFirestore

// Define conversions swift object -> firestore data & firestore data -> swift objects here

// LOCAL OBJECT TO FIRESTORE DATA
func userToData(user: User) -> Dictionary<String, Any> {
    return [
        "id": user.id,
        "email": user.email,
        "username": user.username,
        "is_following": user.isFollowing,
        "is_followed_by": user.isFollowedBy,
        "image_url": user.imageUrl // Warning "Expression implicitly coerced from 'String?' to 'Any'" can be ignored
    ]
}

func placeListToData(placeList: PlaceList) -> Dictionary<String, Any> {
    return [
        "id": placeList.id,
        "name": placeList.name,
        "owner_id": placeList.owner.id,
        "follower_ids": placeList.followerIds,
        "is_public": placeList.isPublic,
        "places": placeIDsWithTimestampsToDatas(places: placeList.places),
        "is_collaborative": placeList.isCollaborative,
        "modified_at": placeList.modifiedAt, // Warning "Expression implicitly coerced from 'Timestamp?' to 'Any" can be ignored
        "created_at": placeList.createdAt,
        "image_url": placeList.imageUrl // Warning "Expression implicitly coerced from 'String?' to 'Any'" can be ignored
    ]
}

func placeIDWithTimestampToData(place: PlaceIDWithTimestamp) -> Dictionary<String, Any> {
    return [
        "place_id": place.placeId,
        "added_at": place.addedAt
    ]
}

func placeIDsWithTimestampsToDatas(places: [PlaceIDWithTimestamp]) -> [Dictionary<String, Any>] {
    return places.map{ place in
        return placeIDWithTimestampToData(place: place)
    }
}

// FIRESTORE DATA TO LOCAL OBJECT
func dataToUser(data: Dictionary<String, Any>) -> User {  
    return User(id: data["id"] as! String,
                email: data["email"] as! String,
                username: data["username"] as! String,
                isFollowing: data["is_following"] as! [String],
                isFollowedBy: data["is_followed_by"] as! [String],
                imageUrl: data["image_url"] as? String)
}


func dataToPlaceList(data: Dictionary<String, Any>) -> PlaceList {
    return PlaceList(id: data["id"] as! String,
                     name: data["name"] as! String,
                     owner: ListOwner(id: data["owner_id"] as! String, username: ""),
                     followerIds: data["follower_ids"] as! [String],
                     isPublic: data["is_public"] as! Bool,
                     places: datasToPlaceIDwithTimestamps(datas: data["places"] as! [Dictionary<String, Any>]),
                     isCollaborative: data["is_collaborative"] as! Bool,
                     modifiedAt: data["modified_at"] as? Timestamp,
                     createdAt: data["created_at"] as! Timestamp,
                     imageUrl: data["image_url"] as? String)
}

func dataToPlaceIDWithTimestamp(data: Dictionary<String, Any>) -> PlaceIDWithTimestamp {
    return PlaceIDWithTimestamp(placeId: data["place_id"] as! String,
                                addedAt: data["added_at"] as! Timestamp)
}

func datasToPlaceIDwithTimestamps(datas: [Dictionary<String, Any>]) -> [PlaceIDWithTimestamp] {
    return datas.map{ data in
        return dataToPlaceIDWithTimestamp(data: data)
    }
}


