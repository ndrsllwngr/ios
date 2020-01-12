import Foundation

struct User: Identifiable, Decodable, Hashable {
    var id: String
    var email: String
    var username: String
    var isFollowing: [String] = []
    var isFollowedBy: [String] = []
    
    func toListOwner() -> ListOwner {
        return ListOwner(id: self.id, username: self.username)
    }
    
    
}

struct ListOwner: Identifiable, Equatable {
    var id: String
    var username: String
}

