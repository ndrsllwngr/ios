import Foundation

struct PlaceList: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var owner: ListOwner
    var followerIds: [String] // the owner is also always a follower
    var isPublic: Bool = true
    var placeIds: [String] = []
    var isCollaborative: Bool = false // only possible if private
    //var createdAt
    //var modifiedAt
    //var titleImage: String
    //var location: String
    //var tags: [UUID]
}
