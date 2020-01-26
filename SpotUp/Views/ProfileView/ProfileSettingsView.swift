import SwiftUI
import FirebaseFirestore

struct ProfileSettingsView: View {
    
    @EnvironmentObject var firestoreProfile: FirestoreProfile
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject private var profileSettingsViewModel = ProfileSettingsViewModel()
    
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
                        FirebaseAuthentication.shared.logOut()
                    }) {
                        Text("Sign out").foregroundColor(.red)
                    }
                }
            }
        .background(Color("bg-profile"))
        }
        .navigationBarTitle(Text("Settings"))
    }
}
