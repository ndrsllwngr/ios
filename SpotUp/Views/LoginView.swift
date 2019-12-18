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
    
    @State var email: String = ""
    @State var password: String = ""
    
    @EnvironmentObject var session: FirebaseAuthentication
    
    var body: some View {
        NavigationView {
            VStack {
                Text("LogInView")
                Spacer()
                TextField("Email", text: $email)
                
                SecureField("Password", text: $password)
                Button(action: logIn) {
                    Text("Sign In")
                }
                .padding()
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                }
            }
                
            .padding()
        }
        
    }
    
    func logIn() {
        session.logIn(email: email, password: password) { (result, error) in
            if error != nil {
                print("Error")
            } else {
                print("success")
                self.email = ""
                self.password = ""
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
