//
//  ProfileSheets.swift
//  SpotUp
//
//  Created by Timo Erdelt on 17.12.19.
//

import SwiftUI
import FirebaseFirestore

struct CreatePlacelistSheet: View {
    var user: User
    @Binding var showSheet: Bool
    @State private var placeListName: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Enter a name for your placelist")
            Spacer()
            TextField("place list name", text: $placeListName)
            HStack {
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    Text("cancel")
                }
                Spacer()
                Button(action: {
                    let newPlaceList = PlaceList(name: self.placeListName, owner: self.user.toListOwner(), followerIds: [self.user.id], createdAt:Timestamp())
                    FirestoreConnection.shared.createPlaceList(placeList: newPlaceList)
                    self.showSheet.toggle()
                }) {
                    Text("create")
                }
            }
            .frame(width: 300, height: 100)
            Spacer()
        }
        .padding()
    }
}

struct ProfileSettingsSheet: View {
    
    @EnvironmentObject var firestoreProfile: FirestoreProfile
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Binding var showSheet: Bool
    
    @State private var newUserName: String = ""
    @State private var newEmail: String = ""
    @State private var currentPasswordChangeEmail: String = ""
    @State private var newPassword: String = ""
    @State private var currentPasswordChangePassword: String = ""
    @State private var currentPasswordDeleteAccount: String = ""
    
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(self.firestoreProfile.user.username)
            Spacer()
            HStack {
                TextField(self.firestoreProfile.user.username, text: $newUserName)
                Spacer()
                Button(action: {
                    FirestoreConnection.shared.updateUserName(userId: self.firebaseAuthentication.currentUser!.uid, newUserName: self.newUserName)
                    UIApplication.shared.endEditing(true)
                }) {
                    Text("Change Username")
                }
            }
            HStack {
                TextField(self.firebaseAuthentication.currentUser != nil ? "\(self.firebaseAuthentication.currentUser!.email)" : "", text: $newEmail)
                SecureField("current password", text: $currentPasswordChangeEmail)
                Button(action: {
                    FirebaseAuthentication.shared.changeEmail(currentEmail: self.self.firebaseAuthentication.currentUser!.email, currentPassword: self.currentPasswordChangeEmail, newEmail: self.newEmail)
                }) {
                    Text("Change Email").foregroundColor(.blue)
                }
            }
            HStack {
                TextField("New password", text: $newPassword)
                SecureField("current password", text: $currentPasswordChangePassword)
                Button(action: {
                    FirebaseAuthentication.shared.changePassword(currentEmail: self.self.firebaseAuthentication.currentUser!.email, currentPassword: self.currentPasswordChangePassword, newPassword: self.newPassword)
                }) {
                    Text("Change Password").foregroundColor(.blue)
                }
            }
            HStack {
                SecureField("current password", text: $currentPasswordDeleteAccount)
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    self.firestoreProfile.removeProfileListener()
                    FirebaseAuthentication.shared.deleteAccount(currentEmail: self.firebaseAuthentication.currentUser!.email, currentPassword: self.currentPasswordDeleteAccount)
                }) {
                    Text("Delete Account").foregroundColor(.red)
                }
            }
            Spacer()
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                FirebaseAuthentication.shared.logOut()
            }) {
                Text("Log Out").foregroundColor(.red)
            }
        }.onAppear {
            self.newUserName = self.firestoreProfile.user.username
        }
        .padding()
    }
}
