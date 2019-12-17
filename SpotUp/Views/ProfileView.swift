//
//  ProfileView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    @EnvironmentObject var firebaseAuthentication: FirebaseAuthentication
    @ObservedObject var profile = FirestoreProfile()
    @State private var showingChildView = false
    @State var showSheet = false
    @State var sheetSelection = 0
    
    
    var body: some View {
        NavigationView {
            VStack {
                ProfileInfoView(showSheet: self.$showSheet, sheetSelection: self.$sheetSelection).environmentObject(self.profile)
                List {
                    CreateNewPlaceListRow(showSheet: self.$showSheet, sheetSelection: self.$sheetSelection)
                    ForEach(profile.ownedPlaceLists) { placeList in
                        NavigationLink(
                            destination: ListView(placeList: placeList)
                        ) {
                            ListRow(placeList: placeList)
                        }
                    }
                    .onDelete(perform: delete)
                    Spacer()
                }
                Spacer()
            }
            .sheet(isPresented: $showSheet) {
                if self.sheetSelection == 0 {
                    EditProfileSheet(user: self.profile.user!, showSheet: self.$showSheet)
                } else if self.sheetSelection == 1 {
                    SettingsSheet(showSheet: self.$showSheet)
                } else {
                    CreatePlacelistSheet(user: self.profile.user!, showSheet: self.$showSheet)
                }
            }
            .navigationBarTitle(Text("Profil"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action:  {
                self.sheetSelection = 2
                self.showSheet.toggle()
            }) {
                Image(systemName: "gear")
            })
        }
        .onAppear {
            self.profile.addProfileListener(currentUserId: self.firebaseAuthentication.currentUser!.uid)
        }
        .onDisappear {
            self.profile.removeProfileListener()
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach {index in
            let placeListToDelete = profile.ownedPlaceLists[index]
            deletePlaceList(placeListId: placeListToDelete.id)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct ProfileInfoView: View {
    @EnvironmentObject var profile: FirestoreProfile
    @Binding var showSheet: Bool
    @Binding var sheetSelection: Int
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Image("profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .padding()
                    Button(action: {
                        self.showSheet.toggle()
                        self.sheetSelection = 0
                    }) {
                        HStack {
                            Text(self.profile.user != nil ? "\(self.profile.user!.username)" : "")
                            Image(systemName: "pencil")
                        }
                    }
                    
                }
                
                HStack {
                    VStack{
                        Text("\(self.profile.ownedPlaceLists.count)")
                            .font(.system(size: 12))
                        Text("Placelists")
                            .font(.system(size: 12))
                        
                    }
                    Spacer()
                    VStack{
                        Text("1")
                            .font(.system(size: 12))
                        Text("Follower")
                            .font(.system(size: 12))
                        
                    }
                    Spacer()
                    VStack{
                        Text("1000")
                            .font(.system(size: 12))
                        Text("Following")
                            .font(.system(size: 12))
                        
                    }
                }
            }.padding(.horizontal)
        }
        
    }
}

struct CreateNewPlaceListRow: View {
    @Binding var showSheet: Bool
    @Binding var sheetSelection: Int
    
    var body: some View {
        Button(action: {
            print("buttonPressed")
            self.sheetSelection = 1
            self.showSheet.toggle()
        }) {
            HStack {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text("Create new place list")
            }
        }
    }
}

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
                    let newPlaceList = PlaceList(name: self.placeListName, owner: self.user.toSimpleUser())
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
    
    var body: some View {
        VStack {
            Text("Settings")
            Spacer()
            Button(action: {
                FirebaseAuthentication().logOut()
            }) {
                Text("Log Out").foregroundColor(.red)
            }
        }
    }
}
