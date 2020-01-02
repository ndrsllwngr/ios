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
                    let newUser = User(id: self.user.id, email: self.user.email, username: self.newUserName)
                    updateUser(newUser: newUser)
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
                    let newPlaceList = PlaceList(name: self.placeListName, owner: self.user.toListOwner(), followerIds: [self.user.id])
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
    @Binding var showSheet: Bool
    @State private var newEmail: String = ""
    @State private var newPassword: String = ""
    
    
    var body: some View {
        VStack {
            Text("Settings")
            HStack {
                TextField("New email", text: $newEmail)
                Button(action: {
                    FirebaseAuthentication().changeEmail(newEmail: self.newEmail)
                }) {
                    Text("Change Email").foregroundColor(.blue)
                }
            }
            HStack {
                TextField("New password", text: $newPassword)
                Button(action: {
                    FirebaseAuthentication().changePassword(newPassword: self.newPassword)
                }) {
                    Text("Change Password").foregroundColor(.blue)
                }
            }
            Button(action: {
                FirebaseAuthentication().logOut()
            }) {
                Text("Log Out").foregroundColor(.red)
            }
            Spacer()
            Button(action: {
                FirebaseAuthentication().deleteAccount()
            }) {
                Text("Delete Account").foregroundColor(.red)
            }
        }
    }
}
