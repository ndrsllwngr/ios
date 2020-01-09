//
//  SignUpView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject private var signUpViewModel = SignUpViewModel()
    @State var presentAlert = false
    
    
    var body: some View {
        VStack {
            Text("Sign Up")
            Form {
                Section(footer: Text(signUpViewModel.usernameMessage).foregroundColor(.red)) {
                    TextField("Username", text: $signUpViewModel.username)
                        .autocapitalization(.none)
                }
                Section(footer: Text(signUpViewModel.emailMessage).foregroundColor(.red)) {
                    TextField("Email", text: $signUpViewModel.email)
                        .autocapitalization(.none)
                }
                Section(footer: Text(signUpViewModel.passwordMessage).foregroundColor(.red)) {
                    SecureField("Password", text: $signUpViewModel.password)
                    SecureField("Password again", text: $signUpViewModel.passwordAgain)
                }
                Section {
                    Button(action: { self.signUp() }) {
                        Text("Sign up")
                    }.disabled(!self.signUpViewModel.isValid)
                }
            }
            Spacer()
        }
    }
    
    func signUp() {
        FirebaseAuthentication.shared.signUp(username: signUpViewModel.username, email: signUpViewModel.email, password: signUpViewModel.password) { (result, error) in
            if error != nil {
                print("Error")
            } else {
                self.signUpViewModel.username = ""
                self.signUpViewModel.email = ""
                self.signUpViewModel.password = ""
                self.signUpViewModel.passwordAgain = ""
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
