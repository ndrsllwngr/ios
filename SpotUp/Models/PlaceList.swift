import Foundation
import FirebaseFirestore

struct PlaceList: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var name: String
    var owner: ListOwner
    var followerIds: [String] // the owner is also always a follower
    var isPublic: Bool = true
    var placeIds: [String] = []
    var places: [PlaceIDWithTimestamp] = []
    var isCollaborative: Bool = false // only possible if private
    var modifiedAt: Timestamp
    var createdAt: Timestamp
    //var titleImage: String
    //var location: String
    //var tags: [UUID]
}

