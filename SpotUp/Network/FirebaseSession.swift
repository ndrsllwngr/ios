//
//  Firebase.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth

class FirebaseSession: ObservableObject {
    
    @Published var currentUser: FirebaseUser?
    @Published var isLoggedIn: Bool?
    
    func listen() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.currentUser = FirebaseUser(uid: user.uid, email: user.email)
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
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password) {
            (authResult, error) in
            if let user = authResult?.user {
                createUser(uid: user.uid, email: user.email)
            }
        }
        
    }
    
}
