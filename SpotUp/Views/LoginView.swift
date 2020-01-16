//
//  LoginView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import UIKit

struct LoginView: View {
    
    @ObservedObject private var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Login")
                Form {
                    Section(footer: Text(loginViewModel.emailMessage).foregroundColor(.red)) {
                        TextField("Email", text: $loginViewModel.email)
                            .autocapitalization(.none)
                    }
                    Section(footer: Text(loginViewModel.passwordMessage).foregroundColor(.red)) {
                        SecureField("Password", text: $loginViewModel.password)
                    }
                    Section {
                        Button(action: { self.logIn() }) {
                            Text("Login")
                        }.disabled(!self.loginViewModel.isValid)
                    }
                    Section {
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    func logIn() {
        FirebaseAuthentication.shared.logIn(email: loginViewModel.email, password: loginViewModel.password) { (result, error) in
            if let error = error {
                print("Error during login: \(error)")
            } else {
                print("success")
                self.loginViewModel.email = ""
                self.loginViewModel.password = ""
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
