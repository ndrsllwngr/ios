import SwiftUI
import FirebaseFirestore

struct ProfileSettingsView: View {
    
    @EnvironmentObject var firestoreProfile: FirestoreProfile
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject private var profileSettingsViewModel = ProfileSettingsViewModel()
    
    var body: some View {
        VStack (alignment: .leading) {
            Form {
                // 1)
                Section(footer: Text(profileSettingsViewModel.usernameMessage).foregroundColor(.red)) {
                    TextField("Username", text: $profileSettingsViewModel.newUserName)
                        .autocapitalization(.none)
                    Button(action: {
                        FirestoreConnection.shared.updateUserName(userId: self.firebaseAuthentication.currentUser!.uid, newUserName: self.profileSettingsViewModel.newUserName)
                        UIApplication.shared.endEditing(true)
                    }) {
                        Text("Change username")
                    }.disabled(!self.profileSettingsViewModel.isValidUsername)
                }
                // 2)
                Section(footer: Text(profileSettingsViewModel.emailMessage).foregroundColor(.red)) {
                    TextField("Email", text: $profileSettingsViewModel.newEmail)
                        .autocapitalization(.none)
                    SecureField("Current password", text: $profileSettingsViewModel.currentPasswordChangeEmail)
                    Button(action: { FirebaseAuthentication.shared.changeEmail(currentEmail: self.self.firebaseAuthentication.currentUser!.email, currentPassword: self.profileSettingsViewModel.currentPasswordChangeEmail, newEmail: self.profileSettingsViewModel.newEmail)
                    }) {
                        Text("Change email")
                    }.disabled(!self.profileSettingsViewModel.isValidEmail)
                }
                // 3)
                Section(footer: Text(profileSettingsViewModel.passwordMessage).foregroundColor(.red)) {
                    SecureField("Password", text: $profileSettingsViewModel.newPassword)
                    SecureField("Password again", text: $profileSettingsViewModel.currentPasswordChangePassword)
                    Button(action: { FirebaseAuthentication.shared.changePassword(currentEmail: self.self.firebaseAuthentication.currentUser!.email, currentPassword: self.profileSettingsViewModel.currentPasswordChangePassword, newPassword: self.profileSettingsViewModel.newPassword)
                    }) {
                        Text("Change password")
                    }.disabled(!self.profileSettingsViewModel.isValidPassword)
                }
                // 4)
                Section(footer: Text(profileSettingsViewModel.deleteAccMessage).foregroundColor(.red)) {
                    SecureField("Password", text: $profileSettingsViewModel.currentPasswordDeleteAccount)
                    Button(action: {
                        self.firestoreProfile.removeProfileListener()
                        FirebaseAuthentication.shared.deleteAccount(currentEmail: self.firebaseAuthentication.currentUser!.email, currentPassword: self.profileSettingsViewModel.currentPasswordDeleteAccount)
                    }) {
                        Text("Delete account").foregroundColor(.red)
                    }.disabled(!self.profileSettingsViewModel.isValidDeleteAcc)
                }
                // 5)
                Section {
                    Button(action: {
                        FirebaseAuthentication.shared.logOut()
                    }) {
                        Text("Sign out").foregroundColor(.red)
                    }
                }
            }
        }
        .navigationBarTitle(Text("Settings"))
        .onAppear {
            self.profileSettingsViewModel.newUserName = self.firestoreProfile.user.username
            self.profileSettingsViewModel.newEmail = self.firebaseAuthentication.currentUser != nil ? "\(self.firebaseAuthentication.currentUser!.email)" : ""
        }
    }
}
