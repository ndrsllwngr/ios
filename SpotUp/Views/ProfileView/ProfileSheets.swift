//
//  ProfileSheets.swift
//  SpotUp
//
//  Created by Timo Erdelt on 17.12.19.
//

import SwiftUI

struct EditProfileSheet: View {
    var user: User
    @Binding var showSheet: Bool
    @State private var newUserName: String = ""
    
    var body: some View {
        VStack {
            Text("Edit profile")
            Spacer()
            TextField(self.user.username, text: $newUserName)
            HStack {
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    Text("cancel")
                }
                Spacer()
                Button(action: {
                    updateUserName(userId: self.user.id, newUserName: self.newUserName)
                    self.showSheet.toggle()
                }) {
                    Text("save")
                }
            }
            Spacer()
        }
    }
}

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
                    let newPlaceList = PlaceList(name: self.placeListName, owner: self.user.toListOwner(), followerIds: [self.user.id],modifiedAt:NSDate.now as NSDate, createdAt:NSDate.now as NSDate)
                    createPlaceList(placeList: newPlaceList)
                    self.showSheet.toggle()
                }) {
                    Text("create")
                }
            }
            .frame(width: 300, height: 100)
            Spacer()
        }
    }
}

struct SettingsSheet: View {
    var user: User
    @Binding var showSheet: Bool
    @State private var newEmail: String = ""
    @State private var currentPasswordChangeEmail: String = ""
    @State private var newPassword: String = ""
    @State private var currentPasswordChangePassword: String = ""
    @State private var currentPasswordDeleteAccount: String = ""
    
    
    var body: some View {
        VStack {
            Text("Settings")
            HStack {
                TextField("\(user.email)", text: $newEmail)
                SecureField("current password", text: $currentPasswordChangeEmail)
                Button(action: {
                    FirebaseAuthentication.shared.changeEmail(currentEmail: self.user.email, currentPassword: self.currentPasswordChangeEmail, newEmail: self.newEmail)
                }) {
                    Text("Change Email").foregroundColor(.blue)
                }
            }
            HStack {
                TextField("New password", text: $newPassword)
                SecureField("current password", text: $currentPasswordChangePassword)
                Button(action: {
                    FirebaseAuthentication.shared.changePassword(currentEmail: self.user.email, currentPassword: self.currentPasswordChangePassword, newPassword: self.newPassword)
                }) {
                    Text("Change Password").foregroundColor(.blue)
                }
            }
            Button(action: {
                FirebaseAuthentication.shared.logOut()
            }) {
                Text("Log Out").foregroundColor(.red)
            }
            Spacer()
            HStack {
                SecureField("current password", text: $currentPasswordDeleteAccount)
                Button(action: {
                    FirebaseAuthentication.shared.deleteAccount(currentEmail: self.user.email, currentPassword: self.currentPasswordDeleteAccount)
                }) {
                    Text("Delete Account").foregroundColor(.red)
                }
            }
            
        }
    }
}
