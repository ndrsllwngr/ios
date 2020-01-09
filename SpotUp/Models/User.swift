//
//  User.swift
//  SpotUp
//
//  Created by Timo Erdelt on 15.12.19.
//

import Foundation

struct User: Identifiable, Decodable {
    var id: String
    var email: String
    var username: String
    var isFollowing: [String] = []
    var isFollowedBy: [String] = []
    
    func toListOwner() -> ListOwner {
        return ListOwner(id: self.id, username: self.username)
    }
    
    
}

struct ListOwner {
    var id: String
    var username: String
}

