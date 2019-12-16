//
//  FirebaseAuthentication.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth

class FirebaseAuthentication: ObservableObject {
    
    @Published var currentUser: FirebaseUser?
    @Published var isLoggedIn: Bool?
    
    func listen() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.currentUser = FirebaseUser(uid: user.uid, email: user.email!)
                self.isLoggedIn = true
            } else {
                self.isLoggedIn = false
                self.currentUser = nil
            }
        }
    }
    
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func logOut() {
        try! Auth.auth().signOut()
        self.isLoggedIn = false
        self.currentUser = nil
        
    }
    
    func signUp(username: String, email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password) {
            (authResult, error) in
            if let user = authResult?.user {
                createUserInFirestore(uid: user.uid, email: user.email!, username: username)
            }
        }
        
    }
    
}

class FirebaseUser {
    
    var uid: String
    var email: String
    // var displayName: String?
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
        // self.displayName = displayName
    }
}

