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
    
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject var firestoreProfile = FirestoreProfile()
    
    @State var isMyProfile: Bool = false
    @State var showSheet = false
    @State var sheetSelection = "none"
    @State var profileUserIdToNavigateTo: String? = nil
    @State var goToOtherProfile: Int? = nil
    @State var pickedImage: UIImage?
    
    var body: some View {
        VStack {
            if (self.profileUserIdToNavigateTo != nil) {
                NavigationLink(destination: ProfileView(profileUserId: self.profileUserIdToNavigateTo!), tag: 1, selection: self.$goToOtherProfile) {
                    Text("")
                }
            }
            InnerProfileView(profileUserId: profileUserId, isMyProfile: $isMyProfile, showSheet: $showSheet, sheetSelection: $sheetSelection, pickedImage: $pickedImage).environmentObject(firestoreProfile)
                .onAppear {
                    self.firestoreProfile.addProfileListener(currentUserId: self.profileUserId, isMyProfile: self.isMyProfile)
                    self.isMyProfile = self.profileUserId == self.firebaseAuthentication.currentUser!.uid
            }
            .onDisappear {
                self.firestoreProfile.removeProfileListener()
            }
            
            Spacer()
        }
        .sheet(isPresented: $showSheet) {
            if self.sheetSelection == "settings" {
                SettingsSheet(showSheet: self.$showSheet).environmentObject(self.firestoreProfile)
            } else if self.sheetSelection == "create_placelist"{
                CreatePlacelistSheet(user: self.firestoreProfile.user, showSheet: self.$showSheet)
            } else if self.sheetSelection == "follower" {
                UsersThatAreFollowingMeSheet(showSheet: self.$showSheet, userId: self.firestoreProfile.user.id, profileUserIdToNavigateTo: self.$profileUserIdToNavigateTo, goToOtherProfile: self.$goToOtherProfile)
            } else if self.sheetSelection == "following" {
                UsersThatIAmFollowingSheet(showSheet: self.$showSheet, userId: self.firestoreProfile.user.id, profileUserIdToNavigateTo: self.$profileUserIdToNavigateTo, goToOtherProfile: self.$goToOtherProfile)
            } else if self.sheetSelection == "image_picker" {
                ImagePicker(imageType: .profile_image, image: self.$pickedImage)
            }
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
    @EnvironmentObject var firestoreProfile: FirestoreProfile
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    @Binding var pickedImage: UIImage?
    
    var body: some View {
        VStack {
            ProfileInfoView(profileUserId: profileUserId, isMyProfile: isMyProfile, showSheet: self.$showSheet, sheetSelection: self.$sheetSelection, pickedImage: $pickedImage).environmentObject(self.firestoreProfile)
            List {
                if isMyProfile {
                    CreateNewPlaceListRow(showSheet: self.$showSheet, sheetSelection: self.$sheetSelection)
                    Section(header: Text("Owned Placelists")) {
                        ForEach(firestoreProfile.placeLists.filter{ $0.owner.id == profileUserId}.sorted{$0.createdAt.dateValue() > $1.createdAt.dateValue()}){ placeList in
                            NavigationLink(
                                destination: PlaceListView(placeListId: placeList.id)
                            ) {
                                PlacesListRow(placeList: placeList)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    Section(header: Text("Followed Placelists")) {
                        ForEach(firestoreProfile.placeLists.filter{ $0.owner.id != profileUserId}){ placeList in
                            NavigationLink(
                                destination: PlaceListView(placeListId: placeList.id)
                            ) {
                                PlacesListRow(placeList: placeList)
                            }
                        }
                    }
                } else {
                    ForEach(firestoreProfile.placeLists){ placeList in
                        NavigationLink(
                            destination: PlaceListView(placeListId: placeList.id)
                        ) {
                            PlacesListRow(placeList: placeList)
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
    
    func delete(at offsets: IndexSet) {
        offsets.forEach {index in
            let placeListToDelete = firestoreProfile.placeLists[index]
            FirestoreConnection.shared.deletePlaceList(placeListToDelete: placeListToDelete)
        }
    }
}

struct ProfileInfoView: View {
    var profileUserId: String
    var isMyProfile: Bool
    @EnvironmentObject var profile: FirestoreProfile
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    @Binding var pickedImage: UIImage?
    @State var showingImagePicker = false
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    FirebaseProfileImage(imageId: profileUserId, pickedImage: $pickedImage)

                    Button(action: {
                        self.showSheet.toggle()
                        self.sheetSelection = "image_picker"
                    }) {
                        Text("change image")
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
