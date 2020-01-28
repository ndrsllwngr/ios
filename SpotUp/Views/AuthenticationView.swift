import SwiftUI
import UIKit

struct AuthenticationView: View {
    // LOCAL
    @ObservedObject private var loginViewModel = LoginViewModel()
    @ObservedObject private var signUpViewModel = SignUpViewModel()
    @State var loginErrorText: String? = nil
    @State var selection: String = "login"
    @State private var offsetValue: CGFloat = 0.0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // LOGO
                HStack(alignment: .center) {
                    Spacer()
                    Image(uiImage: UIImage(named: "logo-icon-70")!)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 72.0, alignment: .center)
                    Text("SpotUp")
                        .font(.system(size:32))
                        .fontWeight(.bold)
                        .padding(.leading, 15)
                    Spacer()
                }
                .offset(y: -70)
                .padding(.bottom, -70)
                .frame(height: 100)
                // TABS
                HStack(alignment: .center, spacing: 0){
                    HStack(alignment: .center, spacing: 0){
                        Spacer()
                        Text("Sign in")
                            .font(.system(size:20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(minHeight: 65)
                    .background(self.selection == "login" ? Color("brand-color-primary") : Color("brand-color-secondary"))
                    .animation(.linear)
                    .transition(.fade)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .onTapGesture {
                        self.selection = "login"
                    }
                    HStack(alignment: .center, spacing: 0){
                        Spacer()
                        Text("Sign up")
                            .font(.system(size:20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(minHeight: 65)
                    .background(self.selection != "login" ? Color("brand-color-primary") : Color("brand-color-secondary"))
                    .animation(.linear)
                    .transition(.fade)
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
                    .background(Color("brand-color-primary"))
                    .edgesIgnoringSafeArea(.all)
                    if self.selection == "login" {
                        VStack(spacing: 0) {
                            // EMAIL
                            Section(footer: HStack {
                                if(self.loginViewModel.emailMessage != "") {
                                    Text(loginViewModel.emailMessage)
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                        .multilineTextAlignment(.leading)
                                        .padding(.top, 5)
                                        .padding(.leading, 6)
                                    Spacer()
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
                                .background(Color("bg-primary"))
                                .cornerRadius(10.0)
                                .padding(.top)
                            }
                            // PASSWORD
                            Section(footer: HStack {
                                if(self.loginViewModel.passwordMessage != "") {
                                    Text(loginViewModel.passwordMessage)
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                        .multilineTextAlignment(.leading)
                                        .padding(.top, 5)
                                        .padding(.leading, 6)
                                }
                                Spacer()
                            }) {
                                HStack {
                                    SecureField("Password", text: $loginViewModel.password)
                                        .textContentType(.password)
                                }
                                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                .foregroundColor(.secondary)
                                .background(Color("bg-primary"))
                                .cornerRadius(10.0)
                                .padding(.top)
                            }
                            // LOGIN BUTTON
                            HStack{
                                Spacer()
                                Section(footer: HStack {
                                    if (self.loginErrorText != nil) {
                                        Text("Wrong credentials")
                                            .foregroundColor(.white)
                                            .font(.footnote)
                                            .multilineTextAlignment(.leading)
                                            .padding(.top, 5)
                                            .padding(.leading, 6)
                                        Spacer()
                                    }
                                }) {
                                    Button(action: { self.logIn() }) {
                                        HStack {
                                            Text("Sign in")
                                                .fontWeight(.bold)
                                                .foregroundColor(self.loginViewModel.isValid ? Color("brand-color-primary") : Color("brand-color-secondary"))
                                        }
                                    }
                                    .padding(.horizontal)
                                    .frame(height: 42)
                                    .background(Color("bg-primary"))
                                    .mask(Rectangle().cornerRadius(.infinity))
                                    .disabled(!self.loginViewModel.isValid)
                                    .padding(.top)
                                }
                            }
                            Spacer()
                        }.padding(.horizontal)
                        .animation(.linear)
                        .transition(.fade)
                    }
                    if self.selection == "signup" {
                        VStack(spacing: 0) {
                            // USERNAME
                            Section(footer: HStack {
                                if(self.signUpViewModel.usernameMessage != "") {
                                    Text(signUpViewModel.usernameMessage)
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                        .multilineTextAlignment(.leading)
                                        .padding(.top, 5)
                                        .padding(.leading, 6)
                                    Spacer()
                                }
                            }) {
                                HStack {
                                    TextField("Username", text: $signUpViewModel.username)
                                        .autocapitalization(.none)
                                }
                                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                .foregroundColor(.primary)
                                .background(Color("bg-primary"))
                                .cornerRadius(10.0)
                                .padding(.top)
                            }
                            // EMAIL
                            Section(footer: HStack {
                                if(self.signUpViewModel.emailMessage != "") {
                                    Text(signUpViewModel.emailMessage)
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                        .multilineTextAlignment(.leading)
                                        .padding(.top, 5)
                                        .padding(.leading, 6)
                                    Spacer()
                                }
                            }) {
                                HStack {
                                    TextField("Email", text: $signUpViewModel.email)
                                        .textContentType(.username)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                }
                                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                .foregroundColor(.primary)
                                .background(Color("bg-primary"))
                                .cornerRadius(10.0)
                                .padding(.top)
                            }
                            // PASSWORD
                            Section(footer: HStack {
                                if(self.signUpViewModel.passwordMessage != "") {
                                    Text(signUpViewModel.passwordMessage)
                                        .foregroundColor(.white)
                                        .font(.footnote)
                                        .multilineTextAlignment(.leading)
                                        .padding(.top, 5)
                                        .padding(.leading, 6)
                                    Spacer()
                                }
                            }) {
                                HStack {
                                    SecureField("Password", text: $signUpViewModel.password)
                                        .textContentType(.newPassword)
                                        .autocapitalization(.none)
                                }
                                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                .foregroundColor(.primary)
                                .background(Color("bg-primary"))
                                .cornerRadius(10.0)
                                .padding(.top)
                                HStack {
                                    SecureField("Password again", text: $signUpViewModel.passwordAgain)
                                        .textContentType(.password)
                                        .autocapitalization(.none)
                                }
                                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                .foregroundColor(.primary)
                                .background(Color("bg-primary"))
                                .cornerRadius(10.0)
                                .padding(.top)
                            }
                            // SIGN UP BUTTON
                            HStack{
                                Spacer()
                                Section {
                                    Button(action: { self.signUp() }) {
                                        HStack {
                                            Text("Sign up")
                                                .fontWeight(.bold)
                                                .foregroundColor(self.signUpViewModel.isValid ? Color("brand-color-primary") : Color("brand-color-secondary"))
                                        }
                                    }
                                    .padding(.horizontal)
                                    .frame(height: 42)
                                    .background(Color("bg-primary"))
                                    .mask(Rectangle().cornerRadius(.infinity))
                                    .disabled(!self.signUpViewModel.isValid)
                                    .padding(.top)
                                }
                            }
                            Spacer()
                        }.padding(.horizontal)
                        .animation(.linear)
                        .transition(.fade)
                    }
                }
            }
                .keyboardSensible($offsetValue) // Scroll input fields to visible area while keyboard is opened
        }
        .navigationBarTitle(Text(""), displayMode: .inline).navigationBarHidden(true)
    }
    
    func logIn() {
        FirebaseAuthentication.shared.logIn(email: loginViewModel.email, password: loginViewModel.password) { (result, error) in
            if let error = error {
                print("Error during logixn: \(error)")
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
    // PROPS
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
