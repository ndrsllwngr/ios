import Foundation
import FirebaseFirestore

struct PlaceList: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var name: String
    var owner: ListOwner
    var followerIds: [String] // the owner is also always a follower
    var isPublic: Bool = true
    var places: [PlaceIDWithTimestamp] = []
    var isCollaborative: Bool = false // only possible if private
    var modifiedAt: Timestamp? = nil
    var createdAt: Timestamp
    var imageUrl: String? = nil
}

