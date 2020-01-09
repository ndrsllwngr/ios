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
    var profileUserId: String
    @State var isMyProfile: Bool = false
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject var profile = FirestoreProfile()
    @ObservedObject var firestorePlaceList = FirestorePlaceList()
    
    @State private var showingChildView = false
    @State var showSheet = false
    @State var sheetSelection = "none"
    @State var profileUserIdToNavigateTo: String? = nil
    @State var goToOtherProfile: Int? = nil

    
    var body: some View {
        NavigationView {
            VStack {
                if (self.profileUserIdToNavigateTo != nil) {
                    NavigationLink(destination: ProfileView(profileUserId: self.profileUserIdToNavigateTo!), tag: 1, selection: self.$goToOtherProfile) {
                               Text("")
                    }
                }
       
                ProfileInfoView(isMyProfile: isMyProfile, showSheet: self.$showSheet, sheetSelection: self.$sheetSelection).environmentObject(self.profile)
                List {
                    if isMyProfile {
                        CreateNewPlaceListRow(showSheet: self.$showSheet, sheetSelection: self.$sheetSelection)
                        Section(header: Text("Owned Placelists")) {
                            ForEach(profile.placeLists.filter{ $0.owner.id == profileUserId}){ placeList in
                                NavigationLink(
                                    destination: PlaceListView(placeListId: placeList.id, placeListName: placeList.name, isOwnedPlacelist: true).environmentObject(self.firestorePlaceList)
                                ) {
                                    PlacesListRow(placeList: placeList)
                                }
                            }
                            .onDelete(perform: delete)
                        }
                        Section(header: Text("Followed Placelists")) {
                            ForEach(profile.placeLists.filter{ $0.owner.id != profileUserId}){ placeList in
                                NavigationLink(
                                    destination: PlaceListView(placeListId: placeList.id, placeListName: placeList.name, isOwnedPlacelist: false).environmentObject(self.firestorePlaceList)
                                ) {
                                    PlacesListRow(placeList: placeList)
                                }
                            }
                        }
                    } else {
                        ForEach(profile.placeLists){ placeList in
                            NavigationLink(
                                destination: PlaceListView(placeListId: placeList.id, placeListName: placeList.name, isOwnedPlacelist: false).environmentObject(self.firestorePlaceList)
                            ) {
                                PlacesListRow(placeList: placeList)
                            }
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            .sheet(isPresented: $showSheet) {
                if self.sheetSelection == "edit_profile" {
                    EditProfileSheet(user: self.profile.user!, showSheet: self.$showSheet)
                } else if self.sheetSelection == "settings" {
                    SettingsSheet(user: self.profile.user!, showSheet: self.$showSheet)
                } else if self.sheetSelection == "create_placelist"{
                    CreatePlacelistSheet(user: self.profile.user!, showSheet: self.$showSheet)
                } else if self.sheetSelection == "follower" {
                    UsersThatAreFollowingMeSheet(showSheet: self.$showSheet, userId: self.profile.user!.id, profileUserIdToNavigateTo: self.$profileUserIdToNavigateTo, goToOtherProfile: self.$goToOtherProfile)
                } else if self.sheetSelection == "following" {
                    UsersThatIAmFollowingSheet(showSheet: self.$showSheet, userId: self.profile.user!.id, profileUserIdToNavigateTo: self.$profileUserIdToNavigateTo, goToOtherProfile: self.$goToOtherProfile)
                }
            }
            .navigationBarTitle(Text("Profil"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action:  {
                self.sheetSelection = "settings"
                self.showSheet.toggle()
            }) {
                Image(systemName: "gear")
            })
        }
        .onAppear {
            self.profile.addProfileListener(currentUserId: self.profileUserId, isMyProfile: self.isMyProfile)
            self.isMyProfile = self.profileUserId == self.firebaseAuthentication.currentUser!.uid
        }
        .onDisappear {
            self.profile.removeProfileListener()
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach {index in
            let placeListToDelete = profile.placeLists[index]
            deletePlaceList(placeListToDelete: placeListToDelete)
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}

struct ProfileInfoView: View {
    var isMyProfile: Bool
    @EnvironmentObject var profile: FirestoreProfile
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
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
                }
                HStack {
                    VStack{
                        Text("\(self.profile.placeLists.count)")
                            .font(.system(size: 14))
                            .bold()
                        Text("Placelists")
                            .font(.system(size: 12))
                        
                    }
                    Spacer()
                    
                    Button(action: {
                        self.sheetSelection = "follower"
                        self.showSheet.toggle()
                    }) {
                        VStack {
                            Text(self.profile.user != nil ? "\(self.profile.user!.isFollowedBy.count)" : "")
                                .font(.system(size: 14))
                                .bold()
                            Text("Follower")
                                .font(.system(size: 12))
                        }
                    }
                    
                    Spacer()
                    Button(action: {
                        self.sheetSelection = "following"
                        self.showSheet.toggle()
                    }) {
                        VStack {
                            Text(self.profile.user != nil ? "\(self.profile.user!.isFollowing.count)" : "")
                                .font(.system(size: 14))
                                .bold()
                            Text("I am following")
                                .font(.system(size: 12))
                        }
                    }
                }
            }
            .padding(.horizontal)
            if isMyProfile {
                HStack {
                    Button(action: {
                        self.showSheet.toggle()
                        self.sheetSelection = "edit_profile"
                    }) {
                        HStack {
                            Text(self.profile.user != nil ? "\(self.profile.user!.username)" : "")
                            Image(systemName: "pencil")
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
            } else {
                HStack {
                    Text(self.profile.user != nil ? "\(self.profile.user!.username)" : "")
                    if (self.profile.user == nil) {
                        Text("")
                    } else if (!self.profile.user!.isFollowedBy.contains(self.firebaseAuthentication.currentUser!.uid)) {
                        Button(action: {
                            followUser(myUserId: self.firebaseAuthentication.currentUser!.uid, userIdToFollow: self.profile.user!.id)
                        }) {
                            Text("Follow")
                        }
                    } else if (self.profile.user!.isFollowedBy.contains(self.firebaseAuthentication.currentUser!.uid)) {
                        Button(action: {
                            unfollowUser(myUserId: self.firebaseAuthentication.currentUser!.uid, userIdToFollow: self.profile.user!.id)
                        }) {
                            Text("Unfollow")
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }
}
