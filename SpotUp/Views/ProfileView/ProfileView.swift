import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject var firestoreProfile = FirestoreProfile()
    // PROPS
    var profileUserId: String
    @Binding var tabSelection: Int
    // STATE
    @State var isMyProfile: Bool = true
    @State var showSheet = false
    @State var sheetSelection = "none"
    @State var profileUserIdToNavigateTo: String? = nil
    @State var goToOtherProfile: Int? = nil
    @State var placeListIdToNavigateTo: String? = nil
    @State var goToPlaceList: Int? = nil
    
    var body: some View {
        VStack {
            if (self.profileUserIdToNavigateTo != nil) {
                NavigationLink(destination: ProfileView(profileUserId: self.profileUserIdToNavigateTo!, tabSelection: $tabSelection), tag: 1, selection: self.$goToOtherProfile) {
                    EmptyView()
                }
            }
            
            if (self.placeListIdToNavigateTo != nil) {
                NavigationLink(destination: PlaceListView(placeListId: self.placeListIdToNavigateTo!, tabSelection:self.$tabSelection), tag: 1, selection: self.$goToPlaceList) {
                    EmptyView()
                }
            }
            
            InnerProfileView(profileUserId: profileUserId,
                             isMyProfile: $isMyProfile,
                             tabSelection: $tabSelection,
                             showSheet: $showSheet,
                             sheetSelection: $sheetSelection,
                             placeListIdToNavigateTo: self.$placeListIdToNavigateTo,
                             goToPlaceList: self.$goToPlaceList).environmentObject(firestoreProfile)
        }
        .sheet(isPresented: $showSheet, onDismiss: {
            self.isMyProfile = self.profileUserId == self.firebaseAuthentication.currentUser!.uid
            self.firestoreProfile.addProfileListener(profileUserId: self.profileUserId)
        }) {
            if self.sheetSelection == "create_placelist"{
                CreatePlacelistSheet(user: self.firestoreProfile.user, showSheet: self.$showSheet)
            } else if self.sheetSelection == "follower" {
                FollowSheet(userIds: self.firestoreProfile.user.isFollowedBy,
                            sheetTitle: "Followers",
                            showSheet: self.$showSheet,
                            profileUserIdToNavigateTo: self.$profileUserIdToNavigateTo,
                            goToOtherProfile: self.$goToOtherProfile)
            } else if self.sheetSelection == "following" {
                FollowSheet(userIds: self.firestoreProfile.user.isFollowing,
                            sheetTitle: "Following",
                            showSheet: self.$showSheet,
                            profileUserIdToNavigateTo: self.$profileUserIdToNavigateTo,
                            goToOtherProfile: self.$goToOtherProfile)
            } else if self.sheetSelection == "image_picker" {
                ImagePicker()
            }
        }
        .onAppear {
            print("ProfileView() - onAppear()")
            self.isMyProfile = self.profileUserId == self.firebaseAuthentication.currentUser!.uid
            self.firestoreProfile.addProfileListener(profileUserId: self.profileUserId)
        }
        .onDisappear {
            print("ProfileView() - onDisappear()")
            self.firestoreProfile.removeProfileListener()
        }
    }
}

struct InnerProfileView: View {
    @EnvironmentObject var firestoreProfile: FirestoreProfile
    // PROPS
    var profileUserId: String
    @Binding var isMyProfile: Bool
    @Binding var tabSelection: Int
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    @Binding var placeListIdToNavigateTo: String?
    @Binding var goToPlaceList: Int?
    // LOCAL
    @State var sortByCreationDate: Bool = true
    let bgColor: String = "bg-profile"
    
    var body: some View {
        VStack {
            ProfileInfoView(profileUserId: profileUserId, isMyProfile: isMyProfile, showSheet: self.$showSheet, sheetSelection: self.$sheetSelection).environmentObject(self.firestoreProfile)
            
            VStack {
                if isMyProfile {
                    List {
                        HStack {
                            Text("My Collections")
                                .font(.system(size: 16, weight:.semibold))
                            Spacer()
                            SortButton(sortByDate: self.$sortByCreationDate)
                        }
                        .listRowBackground(Color(bgColor))
                        
                        CreateNewPlaceListRow(showSheet: self.$showSheet, sheetSelection: self.$sheetSelection).environmentObject(self.firestoreProfile)
                            .listRowBackground(Color(bgColor))
                        
                        if(!firestoreProfile.placeLists.isEmpty) {
                            ForEach(sortPlaceLists(placeLists: firestoreProfile.placeLists, sortByCreationDate: self.sortByCreationDate)) { placeList in
                                PlaceListRow(placeList: placeList)
                                    .onTapGesture {
                                        self.placeListIdToNavigateTo = placeList.id
                                        self.goToPlaceList = 1
                                }
                                
                            }
                            .listRowBackground(Color(bgColor))
                        } else {
                            HStack {
                                Spacer()
                                Text("You have no collections")
                                    .foregroundColor(Color("text-secondary"))
                                Spacer()
                                
                            }
                            .listRowBackground(Color(bgColor))
                        }
                    }
                } else {
                    List {
                        HStack {
                            Text("Public collections")
                                .font(.system(size: 16, weight:.semibold))
                            Spacer()
                            SortButton(sortByDate: self.$sortByCreationDate)
                        }
                        .listRowBackground(Color(bgColor))
                        if (!firestoreProfile.placeLists.filter{$0.isPublic}.isEmpty) {
                            ForEach(sortPlaceLists(placeLists: firestoreProfile.placeLists.filter{$0.isPublic}, sortByCreationDate: self.sortByCreationDate)) { placeList in
                                PlaceListRow(placeList: placeList)
                                    .onTapGesture {
                                        self.placeListIdToNavigateTo = placeList.id
                                        self.goToPlaceList = 1
                                }
                            }
                            .listRowBackground(Color(bgColor))
                        } else {
                            HStack {
                                Spacer()
                                Text("User has no public collections")
                                    .foregroundColor(Color("text-secondary"))
                                Spacer()
                            }
                            .listRowBackground(Color(bgColor))
                        }
                    }
                }
            }
            .background(Color(bgColor))
        }
        .navigationBarTitle(Text("\(self.firestoreProfile.user.username)"), displayMode: .inline)
        .navigationBarItems(trailing: HStack{
            if (self.isMyProfile) {
                ProfileSettingsButton().environmentObject(self.firestoreProfile)
            } else if (!self.isMyProfile) {
                ProfileFollowButton(profileUserId: self.profileUserId).environmentObject(self.firestoreProfile)
            }
        })
    }
}

struct ProfileInfoView: View {
    @EnvironmentObject var profile: FirestoreProfile
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    // PROPS
    var profileUserId: String
    var isMyProfile: Bool
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    // LOCAL
    @State var showingImagePicker = false
    
    var body: some View {
        VStack {
            ZStack{
                VStack {
                    FirebaseProfileImage(imageUrl: self.profile.user.imageUrl).frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.top)
                }
                .frame(width: 110, height: 100)
                if (self.isMyProfile) {
                    VStack {
                        Spacer()
                        HStack{
                            Spacer()
                            
                            Button(action: {
                                self.profile.removeProfileListener()
                                self.showSheet.toggle()
                                self.sheetSelection = "image_picker"
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 18)
                                        .foregroundColor(Color.white)
                                }
                                .frame(width: 32, height: 32)
                                .background(Color("brand-color-primary"))
                                .mask(Circle())
                                .overlay(Circle().stroke(Color("bg-primary"), lineWidth: 2))
                            }
                            
                        }
                    }
                    .frame(width: 110, height: 100)
                }
            }
            Spacer()
            GeometryReader { metrics in
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        Text("\(self.profile.placeLists.count)")
                            .font(.system(size: 14))
                            .bold()
                        Text("COLLECTIONS")
                            .font(.system(size: 12))
                        
                    }
                    .frame(width: metrics.size.width * 0.3)
                    Button(action: {
                        self.profile.removeProfileListener()
                        self.sheetSelection = "follower"
                        self.showSheet.toggle()
                    }) {
                        VStack(alignment: .center) {
                            Text("\(self.profile.user.isFollowedBy.count)")
                                .font(.system(size: 14))
                                .bold()
                            Text("FOLLOWERS")
                                .font(.system(size: 12))
                        }
                    }
                    .frame(width: metrics.size.width * 0.3)
                    Button(action: {
                        self.profile.removeProfileListener()
                        self.sheetSelection = "following"
                        self.showSheet.toggle()
                    }) {
                        VStack(alignment: .center) {
                            Text("\(self.profile.user.isFollowing.count)")
                                .font(.system(size: 14))
                                .bold()
                            Text("FOLLOWING")
                                .font(.system(size: 12))
                        }
                    }
                    .frame(width: metrics.size.width * 0.3)
                    Spacer()
                }
                .foregroundColor(Color("text-primary"))
            }
            .frame(height: 50)
            Spacer()
        }
        .frame(height: 150)
        .padding(.top, 10)
    }
}

struct ProfileFollowButton: View {
    @EnvironmentObject var firestoreProfile: FirestoreProfile
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    // PROPS
    var profileUserId: String
    
    var body: some View {
        HStack {
            Spacer()
            if(self.firebaseAuthentication.currentUser != nil) {
                if (!self.firestoreProfile.user.isFollowedBy.contains(self.firebaseAuthentication.currentUser!.uid)) {
                    Button(action: {
                        FirestoreConnection.shared.followUser(myUserId: self.firebaseAuthentication.currentUser!.uid, userIdToFollow: self.profileUserId)
                    }) {
                        VStack (alignment: .trailing) {
                            Text("FOLLOW")
                                .font(.system(size: 12))
                                .foregroundColor(Color(.white))
                                .padding(.vertical, 4)
                            
                        }
                        .frame(width: 90)
                        .background(Color("brand-color-primary"))
                        .mask(Rectangle().cornerRadius(8))
                    }
                } else if (self.firestoreProfile.user.isFollowedBy.contains(self.firebaseAuthentication.currentUser!.uid)) {
                    Button(action: {
                        FirestoreConnection.shared.unfollowUser(myUserId: self.firebaseAuthentication.currentUser!.uid, userIdToFollow: self.profileUserId)
                    }) {
                        VStack (alignment: .trailing){
                            Text("FOLLOWING")
                                .font(.system(size: 12))
                                .foregroundColor(Color(.gray))
                                .padding(.vertical, 4)
                            
                        }
                        .frame(width: 90)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.lightGray), lineWidth: 1))
                    }
                }
            }
        }
        .padding(.trailing, -2)
    }
}

struct ProfileSettingsButton: View {
    @EnvironmentObject var firestoreProfile: FirestoreProfile
    
    var body: some View {
        NavigationLink(destination: ProfileSettingsView().environmentObject(self.firestoreProfile)) {
            HStack {
                Spacer()
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("text-primary"))
            }
            .frame(width: 49, height: 49)
        }
    }
}
