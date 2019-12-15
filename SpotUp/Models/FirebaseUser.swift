//
//  User.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import Foundation

class FirebaseUser {
    
    var uid: String
    var email: String?
    // var displayName: String?
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
        // self.displayName = displayName
    }
}
