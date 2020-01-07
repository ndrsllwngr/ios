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
    @State private var showingChildView = false
    @State var showSheet = false
    @State var sheetSelection = "none"
    
    var body: some View {
        NavigationView {
            VStack {
                ProfileInfoView(isMyProfile: isMyProfile, showSheet: self.$showSheet, sheetSelection: self.$sheetSelection).environmentObject(self.profile)
                List {
                    if isMyProfile {
                        CreateNewPlaceListRow(showSheet: self.$showSheet, sheetSelection: self.$sheetSelection)
                        Section(header: Text("Owned Placelists")) {
                            ForEach(profile.placeLists.filter{ $0.owner.id == profileUserId}){ placeList in
                                NavigationLink(
                                    destination: PlaceListView(placeList: placeList, isOwnedPlacelist: true)
                                ) {
                                    PlacesListRow(placeList: placeList)
                                }
                            }
                            .onDelete(perform: delete)
                        }
                        Section(header: Text("Followed Placelists")) {
                            ForEach(profile.placeLists.filter{ $0.owner.id != profileUserId}){ placeList in
                                NavigationLink(
                                    destination: PlaceListView(placeList: placeList, isOwnedPlacelist: false)
                                ) {
                                    PlacesListRow(placeList: placeList)
                                }
                            }
                        }
                    } else {
                        ForEach(profile.placeLists){ placeList in
                            NavigationLink(
                                destination: PlaceListView(placeList: placeList, isOwnedPlacelist: false)
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
                    VStack{
                        Text("1")
                            .font(.system(size: 14))
                            .bold()
                        Text("Follower")
                            .font(.system(size: 12))
                        
                    }
                    Spacer()
                    VStack{
                        Text("1000")
                            .font(.system(size: 14))
                            .bold()
                        Text("Following")
                            .font(.system(size: 12))
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
                    Button(action:  {
                        print("follow")
                    }) {
                        Text("follow")
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }
}
