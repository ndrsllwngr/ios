import SwiftUI
import Firebase
import FirebaseAuth

class FirebaseUser {
    var uid: String
    var email: String
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}

class FirebaseAuthentication: ObservableObject {
    
    static let shared = FirebaseAuthentication()
    
    @Published var currentUser: FirebaseUser?
    @Published var startUpInProgress: Bool = true
    
    private init(){}
    
    func listen() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.currentUser = FirebaseUser(uid: user.uid, email: user.email!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.startUpInProgress = false
                }
            } else {
                self.currentUser = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.startUpInProgress = false
                }
            }
        }
    }
    
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func logOut() {
        try! Auth.auth().signOut()
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
                FirestoreConnection.shared.createUserInFirestore(user: user)
            }
        }
    }
    
    func changeEmail(currentEmail: String, currentPassword: String, newEmail: String) {
        // If we don't authorize again here we might get "This operation is sensitive and requires recent authentication" error from Firebase
        self.logIn(email: currentEmail, password: currentPassword) { (result, error) in
            if let error = error {
                print("Error during authentication for email change: \(error)")
            } else if let result = result {
                let user = result.user
                user.updateEmail(to: newEmail) { (error) in
                    if let error = error {
                        print("Error during email change: \(error)")
                    } else {
                        FirestoreConnection.shared.updateUserEmail(userId: user.uid, newEmail: newEmail)
                        print("Email changed to: \(newEmail)")
                    }
                }
            }
        }
        
    }
    
    func changePassword(currentEmail: String, currentPassword: String, newPassword: String) {
        // If we don't authorize again here we might get "This operation is sensitive and requires recent authentication" error from Firebase
        self.logIn(email: currentEmail, password: currentPassword) { (result, error) in
            if let error = error {
                print("Error during authentication for password change: \(error)")
            } else if let result = result {
                let user = result.user
                user.updatePassword(to: newPassword) { (error) in
                    if let error = error {
                        print("Error during password change: \(error)")
                    } else {
                        print("Password changed to: \(newPassword)")
                    }
                }
            }
        }
    }
    
    func deleteAccount(currentEmail: String, currentPassword: String) {
        // If we don't authorize again here we might get "This operation is sensitive and requires recent authentication" error from Firebase
        self.logIn(email: currentEmail, password: currentPassword) { (result, error) in
            if let error = error {
                print("Error during authentication for account deletion: \(error)")
            } else if let result = result {
                let user = result.user
                // delete user in firestore first, afterwards I am not authenticated anymore TODO think about this again
                FirestoreConnection.shared.deleteUserInFirestore(userId: user.uid)
                user.delete { error in
                    if let error = error {
                        print("Error during account deletion: \(error)")
                    } else {
                        print("Account deleted")
                    }
                }
            }
        }
    }
}

