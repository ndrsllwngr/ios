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
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error during sign up: \(error)")
                return
            }
            if let user = authResult?.user {
                let user = User(id: user.uid, email: user.email!, username: username)
                createUserInFirestore(user: user)
            }
        }
    }
    
    func changeEmail(newEmail: String) {
        let user = Auth.auth().currentUser
        
        user?.updateEmail(to: newEmail) { (error) in
            if let error = error {
                print("Error during email change: \(error)")
            } else {
                updateUser(newUser: User(id: user?.uid, em))
                print("Email changed to: \(newEmail)")
            }
        }
    }
    
    func changePassword(newPassword: String) {
        Auth.auth().currentUser?.updatePassword(to: newPassword) { (error) in
            if let error = error {
                print("Error during password change: \(error)")
            } else {
                print("Email changed to: \(newPassword)")

            }
        }
    }
    
    func deleteAccount() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print("Error during user deletion: \(error)")
            } else {
                print("Account deleted")
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

