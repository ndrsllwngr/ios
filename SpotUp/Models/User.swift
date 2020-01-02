//
//  User.swift
//  SpotUp
//
//  Created by Timo Erdelt on 15.12.19.
//

import Foundation

struct User: Identifiable {
    var id: String
    var email: String
    var username: String
    
    func toListOwner() -> ListOwner {
        return ListOwner(id: self.id, username: self.username)
    }
    
    
}

struct ListOwner {
    var id: String
    var username: String
}

