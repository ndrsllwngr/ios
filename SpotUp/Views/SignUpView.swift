//
//  SignUpView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject private var userViewModel = UserViewModel()
    @State var presentAlert = false
    
    
    var body: some View {
        VStack {
            Text("Sign Up")
            Form {
                Section(footer: Text(userViewModel.usernameMessage).foregroundColor(.red)) {
                    TextField("Username", text: $userViewModel.username)
                        .autocapitalization(.none)
                }
                Section(footer: Text(userViewModel.emailMessage).foregroundColor(.red)) {
                    TextField("Email", text: $userViewModel.email)
                        .autocapitalization(.none)
                }
                Section(footer: Text(userViewModel.passwordMessage).foregroundColor(.red)) {
                    SecureField("Password", text: $userViewModel.password)
                    SecureField("Password again", text: $userViewModel.passwordAgain)
                }
                Section {
                    Button(action: { self.signUp() }) {
                        Text("Sign up")
                    }.disabled(!self.userViewModel.isValid)
                }
            }
            Spacer()
        }
    }
    
    func signUp() {
        FirebaseAuthentication.shared.signUp(username: userViewModel.username, email: userViewModel.email, password: userViewModel.password) { (result, error) in
            if error != nil {
                print("Error")
            } else {
//                userViewModel.email = ""
//                userViewModel.password = ""
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
