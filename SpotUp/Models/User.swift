//
//  User.swift
//  SpotUp
//
//  Created by Timo Erdelt on 15.12.19.
//

import Foundation

struct User {
    var id: String
    var email: String
    var username: String
    
    func toSimpleUser() -> SimpleUser {
        return SimpleUser(id: self.id, username: self.username)
    }
}

struct SimpleUser {
    var id: String
    var username: String
}

