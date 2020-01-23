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
    
    @Binding var tabSelection: Int

    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject var firestoreProfile = FirestoreProfile()
    
    @State var isMyProfile: Bool = false
    @State var showSheet = false
    @State var sheetSelection = "none"
    @State var profileUserIdToNavigateTo: String? = nil
    @State var goToOtherProfile: Int? = nil
    
    var body: some View {
        VStack {
            if (self.profileUserIdToNavigateTo != nil) {
                NavigationLink(destination: ProfileView(profileUserId: self.profileUserIdToNavigateTo!, tabSelection: $tabSelection), tag: 1, selection: self.$goToOtherProfile) {
                    Text("")
                }
            }
            InnerProfileView(profileUserId: profileUserId, isMyProfile: $isMyProfile, tabSelection: $tabSelection, showSheet: $showSheet, sheetSelection: $sheetSelection).environmentObject(firestoreProfile)
            Spacer()
        }
        .sheet(isPresented: $showSheet) {
            if self.sheetSelection == "settings" {
                ProfileSettingsSheet(showSheet: self.$showSheet).environmentObject(self.firestoreProfile)
            } else if self.sheetSelection == "create_placelist"{
                CreatePlacelistSheet(user: self.firestoreProfile.user, showSheet: self.$showSheet)
            } else if self.sheetSelection == "follower" {
                FollowSheet(userIds: self.firestoreProfile.user.isFollowedBy,
                            sheetTitle: "Users that are following me",
                            showSheet: self.$showSheet,
                            profileUserIdToNavigateTo: self.$profileUserIdToNavigateTo,
                            goToOtherProfile: self.$goToOtherProfile)
            } else if self.sheetSelection == "following" {
                FollowSheet(userIds: self.firestoreProfile.user.isFollowing,
                            sheetTitle: "Users that I am following:",
                            showSheet: self.$showSheet,
                            profileUserIdToNavigateTo: self.$profileUserIdToNavigateTo,
                            goToOtherProfile: self.$goToOtherProfile)
            } else if self.sheetSelection == "image_picker" {
                ImagePicker(imageType: .PROFILE_IMAGE)
            }
        }
        .onAppear {
            print("On Appear profile")
            self.isMyProfile = self.profileUserId == self.firebaseAuthentication.currentUser!.uid
            self.firestoreProfile.addProfileListener(profileUserId: self.profileUserId)
        }
        .onDisappear {
            self.firestoreProfile.removeProfileListener()
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}

struct InnerProfileView: View {
    var profileUserId: String
    
    @Binding var isMyProfile: Bool
    @Binding var tabSelection: Int

    @EnvironmentObject var firestoreProfile: FirestoreProfile
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    var body: some View {
        VStack {
            ProfileInfoView(profileUserId: profileUserId, isMyProfile: isMyProfile, showSheet: self.$showSheet, sheetSelection: self.$sheetSelection).environmentObject(self.firestoreProfile)
            List {
                //TO-DO: woher kommt das padding?
                if isMyProfile {
                    CreateNewPlaceListRow(showSheet: self.$showSheet, sheetSelection: self.$sheetSelection)
                    ForEach(firestoreProfile.placeLists.sorted{$0.createdAt.dateValue() > $1.createdAt.dateValue()}){ placeList in
                        NavigationLink(
                            destination: PlaceListView(placeListId: placeList.id, tabSelection: self.$tabSelection)
                        ) {
                            PlacesListRow(placeList: placeList)
                        }
                    }
                } else {
                    ForEach(firestoreProfile.placeLists.filter{$0.isPublic}.sorted{$0.createdAt.dateValue() > $1.createdAt.dateValue()}){ placeList in
                        NavigationLink(
                            destination: PlaceListView(placeListId: placeList.id, tabSelection: self.$tabSelection)
                        ) {
                            PlacesListRow(placeList: placeList)
                            .frame(height: 120)
                        }
                    }
                }
                Spacer()
            }
        }
        .navigationBarTitle(Text("\(self.firestoreProfile.user.username)"), displayMode: .inline)
        .navigationBarItems(trailing: HStack {
            if (self.isMyProfile) {
                ProfileSettingsButton(showSheet: self.$showSheet, sheetSelection: self.$sheetSelection).environmentObject(self.firestoreProfile)
            } else if (!self.isMyProfile) {
                ProfileFollowButton(profileUserId: self.profileUserId).environmentObject(self.firestoreProfile)
            }
        })
    }
}

struct ProfileInfoView: View {
    var profileUserId: String
    var isMyProfile: Bool
    @EnvironmentObject var profile: FirestoreProfile
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    @State var showingImagePicker = false
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    FirebaseProfileImage(imageUrl: self.profile.user.imageUrl).padding(.top)
                    if (self.isMyProfile) {
                        Button(action: {
                            self.showSheet.toggle()
                            self.sheetSelection = "image_picker"
                        }) {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                }
            }
            GeometryReader { metrics in
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        Text("\(self.profile.placeLists.count)")
                            .font(.system(size: 14))
                            .bold()
                        Text("Placelists")
                            .font(.system(size: 12))
                        
                    }
                    .frame(width: metrics.size.width * 0.3)
                    Button(action: {
                        self.sheetSelection = "follower"
                        self.showSheet.toggle()
                    }) {
                        VStack(alignment: .center) {
                            Text("\(self.profile.user.isFollowedBy.count)")
                                .font(.system(size: 14))
                                .bold()
                            Text("Follower")
                                .font(.system(size: 12))
                        }
                    }
                    .frame(width: metrics.size.width * 0.3)
                    Button(action: {
                        self.sheetSelection = "following"
                        self.showSheet.toggle()
                    }) {
                        VStack(alignment: .center) {
                            Text("\(self.profile.user.isFollowing.count)")
                                .font(.system(size: 14))
                                .bold()
                            Text("I am following")
                                .font(.system(size: 12))
                        }
                    }
                    .frame(width: metrics.size.width * 0.3)
                    Spacer()
                }
            }.frame(height: 50)
            
        }
    }
}

struct ProfileFollowButton: View {
    var profileUserId: String
    
    @EnvironmentObject var firestoreProfile: FirestoreProfile
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    
    var body: some View {
        VStack {
            if (!self.firestoreProfile.user.isFollowedBy.contains(self.firebaseAuthentication.currentUser!.uid)) {
                Button(action: {
                    FirestoreConnection.shared.followUser(myUserId: self.firebaseAuthentication.currentUser!.uid, userIdToFollow: self.profileUserId)
                }) {
                    Image(systemName: "person.badge.plus.fill")
                }
            } else if (self.firestoreProfile.user.isFollowedBy.contains(self.firebaseAuthentication.currentUser!.uid)) {
                Button(action: {
                    FirestoreConnection.shared.unfollowUser(myUserId: self.firebaseAuthentication.currentUser!.uid, userIdToFollow: self.profileUserId)
                }) {
                    Image(systemName: "person.badge.minus.fill")
                }
            }
        }
    }
}
struct ProfileSettingsButton: View {
    @EnvironmentObject var firestoreProfile: FirestoreProfile
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    var body: some View {
        VStack {
            Button(action:  {
                self.sheetSelection = "settings"
                self.showSheet.toggle()
            }) {
                Image(systemName: "gear")
            }
        }
        
    }
}
