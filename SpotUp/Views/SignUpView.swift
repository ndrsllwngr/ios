//
//  SignUpView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    
    var body: some View {
        Group {
            VStack {
                Text("SignUpView")
                HStack {
                    Text("Username")
                    TextField("Enter username", text: $username)
                }
                .padding()
                HStack {
                    Text("Email")
                    TextField("Enter Email Address", text: $email)
                }
                .padding()
                
                HStack {
                    Text("Password")
                    SecureField("Enter Password", text: $password)
                }
                .padding()
                Button(action: signUp) {
                    Text("Sign Up")
                }
                Spacer()
            }
        }
        .padding()
    }
    
    func signUp() {
        if !username.isEmpty && !email.isEmpty && !password.isEmpty {
            FirebaseAuthentication.shared.signUp(username: username, email: email, password: password) { (result, error) in
                if error != nil {
                    print("Error")
                } else {
                    self.email = ""
                    self.password = ""
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
