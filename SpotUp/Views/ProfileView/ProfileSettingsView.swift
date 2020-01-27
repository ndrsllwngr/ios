import SwiftUI
import FirebaseFirestore
import Combine

struct ProfileSettingsView: View {
    @EnvironmentObject var firestoreProfile: FirestoreProfile
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject private var profileSettingsViewModel = ProfileSettingsViewModel()
    
    @State private var showModal = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            // Avoids that form view scrolls under navbar
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("bg-primary"))
            Form {
                // 1)
                Section(header: Text("Change username").fontWeight(.bold), footer: Text(profileSettingsViewModel.usernameMessage).foregroundColor(.red)) {
                    TextField("New username", text: $profileSettingsViewModel.newUserName)
                        .autocapitalization(.none)
                    Button(action: {
                        FirestoreConnection.shared.updateUserName(userId: self.firebaseAuthentication.currentUser!.uid, newUserName: self.profileSettingsViewModel.newUserName)
                        UIApplication.shared.endEditing(true)
                    }) {
                        Text("Save")
                    }.disabled(!self.profileSettingsViewModel.isValidUsername)
                }
                // 2)
                Section(header: Text("Change email").fontWeight(.bold), footer: Text(profileSettingsViewModel.emailMessage).foregroundColor(.red)) {
                    TextField("New email", text: $profileSettingsViewModel.newEmail)
                        .autocapitalization(.none)
                    SecureField("Current password", text: $profileSettingsViewModel.currentPasswordChangeEmail)
                    Button(action: { FirebaseAuthentication.shared.changeEmail(currentEmail: self.self.firebaseAuthentication.currentUser!.email, currentPassword: self.profileSettingsViewModel.currentPasswordChangeEmail, newEmail: self.profileSettingsViewModel.newEmail)
                    }) {
                        Text("Save")
                    }.disabled(!self.profileSettingsViewModel.isValidEmail)
                }
                // 3)
                Section(header: Text("Change password").fontWeight(.bold), footer: Text(profileSettingsViewModel.passwordMessage).foregroundColor(.red)) {
                    SecureField("Old password", text: $profileSettingsViewModel.currentPasswordChangePassword)
                    SecureField("New password", text: $profileSettingsViewModel.newPassword)
                    Button(action: { FirebaseAuthentication.shared.changePassword(currentEmail: self.self.firebaseAuthentication.currentUser!.email, currentPassword: self.profileSettingsViewModel.currentPasswordChangePassword, newPassword: self.profileSettingsViewModel.newPassword)
                    }) {
                        Text("Save")
                    }.disabled(!self.profileSettingsViewModel.isValidPassword)
                }
                // 4)
                Section(header: Text("Delete account").fontWeight(.bold), footer: Text(profileSettingsViewModel.deleteAccMessage).foregroundColor(.red)) {
                    SecureField("Current password", text: $profileSettingsViewModel.currentPasswordDeleteAccount)
                    Button(action: {
                        self.firestoreProfile.removeProfileListener()
                        FirebaseAuthentication.shared.deleteAccount(currentEmail: self.firebaseAuthentication.currentUser!.email, currentPassword: self.profileSettingsViewModel.currentPasswordDeleteAccount)
                    }) {
                        Text("Delete").foregroundColor(.red)
                    }.disabled(!self.profileSettingsViewModel.isValidDeleteAcc)
                }
                // 5)
                Section {
                    Button(action: {
                        ExploreModel.shared.quitExplore()
                        SearchViewModel.shared.resetSearch()
                        FirebaseAuthentication.shared.logOut()
                    }) {
                        Text("Sign out").foregroundColor(.red)
                    }
                }
                Section {
                    Button("Credits") {
                        self.showModal = true
                    }
                }
            }
            .background(Color("bg-profile"))
        }
        .navigationBarTitle(Text("Settings"))
        .sheet(isPresented: $showModal, onDismiss: {
            print(self.showModal)
        }) {
            ModalView(message: "This is Modal view")
        }
    }
}

struct ModalView: View {
    @Environment(\.presentationMode) var presentation
    let message: String
    
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 30, height: 3)
                .padding(10)
            VStack {
                HStack {
                    Text("Credits").font(.system(size:18)).fontWeight(.bold)
                    Spacer()
                }
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Text("Icons made by ")
                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://www.flaticon.com/authors/freepik")!)
                            
                        }) {
                            Text("Freepik")
                        }
                    }
                    HStack(spacing: 0){
                        Text("from ")
                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://www.flaticon.com/")!)
                            
                        }) {
                            Text("www.flaticon.com")
                            
                        }
                        Text(".")
                    }
                    Text("Icons may be altered in color and shape.").multilineTextAlignment(.leading).padding(.top, 30)
                    Text("App made by Andreas Ellwanger, Timo Erdelt, Havy Ha and Fangli Lu.").multilineTextAlignment(.leading).padding(.top, 30)
                }.padding(.top, 30)
                Spacer()
            }.padding(.horizontal, 30)
        }
    }
}
