//
//  LoginView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import UIKit

struct AuthenticationView: View {
    
    @ObservedObject private var loginViewModel = LoginViewModel()
    @ObservedObject private var signUpViewModel = SignUpViewModel()
    
    @State var loginErrorText: String? = nil
    @State var selection: String = "login"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Spacer()
                    Image(uiImage: UIImage(named: "logo-icon")!)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55.0, height: 70.0, alignment: .center)
                        .padding(.trailing, 15)
                    Text("SpotUp").font(.system(size:32)).fontWeight(.bold)
                    Spacer()
                }
                .offset(y: -70)
                .padding(.bottom, -70)
                .frame(height: 100)
                // TABS
                HStack(alignment: .center, spacing: 0){
                    HStack(alignment: .center, spacing: 0){
                        Spacer()
                        Text("Sign In").font(.system(size:20)).fontWeight(.bold).foregroundColor(.white)
                        Spacer()
                    }
                    .frame(minHeight: 65)
                    .background(Color( "brand-color-primary-soft"))
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .onTapGesture {
                        self.selection = "login"
                    }
                    HStack(alignment: .center, spacing: 0){
                        Spacer()
                        Text("Sign Up").font(.system(size:20)).fontWeight(.bold).foregroundColor(.white)
                        Spacer()
                    }
                    .frame(minHeight: 65)
                    .background(Color("brand-color-secondary"))
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .onTapGesture {
                        self.selection = "signup"
                    }
                }
                .edgesIgnoringSafeArea(.horizontal)
                // FORM
                ZStack {
                    VStack(spacing: 0) {
                        HStack(spacing: 0){
                            Spacer()
                        }
                        Spacer()
                    }
                    .frame(minHeight: 0, maxHeight: .infinity)
                        //                .background(Color.red)
                        .background(Color(selection == "login" ? "brand-color-primary-soft" : "brand-color-secondary"))
                        .edgesIgnoringSafeArea(.all)
                    if self.selection == "login" {
                        VStack(spacing: 0) {
                            
                            // EMAIL
                            Section(footer: VStack {
                                if(self.loginViewModel.emailMessage != "") {
                                    Text(loginViewModel.emailMessage).foregroundColor(.red)
                                }
                            }) {
                                HStack {
                                    TextField("Email", text: $loginViewModel.email)
                                        .textContentType(.username)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .foregroundColor(.primary)
                                }
                                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                .foregroundColor(.secondary)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10.0)
                                .padding(.top)
                            }
                            
                            // PASSWORD
                            Section(footer: VStack {
                                if(self.loginViewModel.passwordMessage != "") {
                                    Text(loginViewModel.passwordMessage).foregroundColor(.red)
                                }
                            }) {
                                HStack {
                                    SecureField("Password", text: $loginViewModel.password)
                                        .textContentType(.password)
                                }
                                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                .foregroundColor(.secondary)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10.0)
                                .padding(.top)
                            }
                            
                            // LOGIN BUTTON
                            Section(footer: VStack {
                                if (self.loginErrorText != nil) {
                                    Text("Wrong credentials").foregroundColor(.red)
                                }
                            }) {
                                Button(action: { self.logIn() }) {
                                    HStack {
                                        Spacer()
                                        Text("Login").foregroundColor(.primary)
                                        Spacer()
                                    }
                                }
                                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                .foregroundColor(.secondary)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10.0)
                                .padding(.top)
                                .disabled(!self.loginViewModel.isValid)
                            }
                            
                            Spacer()
                        }.padding(.horizontal)
                    }
                    if self.selection == "signup" {
                        VStack(spacing: 0) {
                            
                            // USERNAME
                            Section(footer: VStack {
                                if(self.signUpViewModel.usernameMessage != "") {
                                    Text(signUpViewModel.usernameMessage).foregroundColor(.red)
                                }
                            }) {
                                HStack {
                                    TextField("Username", text: $signUpViewModel.username)
                                        .autocapitalization(.none)
                                }
                                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                .foregroundColor(.secondary)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10.0)
                                .padding(.top)
                            }
                            
                            // EMAIL
                            Section(footer: VStack {
                                if(self.signUpViewModel.emailMessage != "") {
                                    Text(signUpViewModel.emailMessage).foregroundColor(.red)
                                }
                            }) {
                                HStack {
                                    TextField("Email", text: $signUpViewModel.email)
                                        .textContentType(.username)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                }
                                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                .foregroundColor(.secondary)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10.0)
                                .padding(.top)
                            }
                            
                            // PASSWORD
                            Section(footer: VStack {
                                if(self.signUpViewModel.passwordMessage != "") {
                                    Text(signUpViewModel.passwordMessage).foregroundColor(.red)
                                }
                            }) {
                                HStack {
                                    SecureField("Password", text: $signUpViewModel.password)
                                        .textContentType(.newPassword)
                                        .autocapitalization(.none)
                                }
                                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                .foregroundColor(.secondary)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10.0)
                                .padding(.top)
                                HStack {
                                    SecureField("Password again", text: $signUpViewModel.passwordAgain)
                                        .textContentType(.password)
                                        .autocapitalization(.none)
                                }
                                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                .foregroundColor(.secondary)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10.0)
                                .padding(.top)
                            }
                            
                            // SIGN UP BUTTON
                            Section {
                                Button(action: { self.signUp() }) {
                                    HStack {
                                        Spacer()
                                        Text("Sign up").foregroundColor(.primary)
                                        Spacer()
                                    }
                                }
                                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                .foregroundColor(.secondary)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10.0)
                                .padding(.top)
                                .disabled(!self.signUpViewModel.isValid)
                            }
                            Spacer()
                        }.padding(.horizontal)
                    }
                }
            }
        }.navigationBarTitle(Text(""), displayMode: .inline).navigationBarHidden(true)
    }
    
    func logIn() {
        FirebaseAuthentication.shared.logIn(email: loginViewModel.email, password: loginViewModel.password) { (result, error) in
            if let error = error {
                print("Error during login: \(error)")
                self.loginErrorText = "\(error)"
            } else {
                print("success")
                self.loginViewModel.email = ""
                self.loginViewModel.password = ""
            }
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}