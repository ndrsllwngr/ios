//
//  ListView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct PlaceListView: View {
    
    var placeListId: String
    
    @Binding var tabSelection: Int
    
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject var firestorePlaceList = FirestorePlaceList()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var showSheet = false
    @State var sheetSelection = "none"
    
    @State var placeIdToNavigateTo: String? = nil
    @State var goToPlace: Int? = nil
    
    @State var profileUserIdToNavigateTo: String? = nil
    @State var goToOtherProfile: Int? = nil
    
    @State var placeForAddPlaceToListSheet: GMSPlaceWithTimestamp? = nil
    @State var imageForAddPlaceToListSheet: UIImage? = nil
    
    
    var body: some View {
        VStack {
            if (self.placeIdToNavigateTo != nil) {
                NavigationLink(destination: ItemView(placeId: self.placeIdToNavigateTo!), tag: 1, selection: self.$goToPlace) {
                    Text("")
                }
            }
            if (self.profileUserIdToNavigateTo != nil) {
                NavigationLink(destination: ProfileView(profileUserId: self.profileUserIdToNavigateTo!, tabSelection: $tabSelection), tag: 1, selection: self.$goToOtherProfile) {
                    Text("")
                }
            }
            InnerPlaceListView(placeListId: placeListId,
                               showSheet: $showSheet,
                               sheetSelection: $sheetSelection,
                               placeIdToNavigateTo: $placeIdToNavigateTo,
                               goToPlace: $goToPlace,
                               placeForAddPlaceToListSheet: self.$placeForAddPlaceToListSheet,
                               imageForAddPlaceToListSheet: self.$imageForAddPlaceToListSheet,
                               tabSelection: self.$tabSelection)
                .environmentObject(firestorePlaceList)
        }
        .sheet(isPresented: $showSheet) {
            if self.sheetSelection == "settings" {
                PlaceListSettingsSheet(presentationMode: self.presentationMode,
                                       showSheet: self.$showSheet)
                    .environmentObject(self.firestorePlaceList)
            } else if self.sheetSelection == "follower" {
                FollowSheet(userIds: self.firestorePlaceList.placeList.followerIds.filter{$0 != self.firestorePlaceList.placeList.owner.id},
                            sheetTitle: "Followers",
                            showSheet: self.$showSheet,
                            profileUserIdToNavigateTo: self.$profileUserIdToNavigateTo,
                            goToOtherProfile: self.$goToOtherProfile)
            } else if (self.sheetSelection == "add_to_placelist"){
                AddPlaceToListSheet(place: self.placeForAddPlaceToListSheet!.gmsPlace,
                                    placeImage: self.imageForAddPlaceToListSheet,
                                    showSheet: self.$showSheet)
            }
        }
        .onAppear {
            print("PlaceListView() - onAppear()")
            self.firestorePlaceList.addPlaceListListener(placeListId: self.placeListId, ownUserId: self.firebaseAuthentication.currentUser!.uid)
        }
        .onDisappear {
            // ToDo: If don't remove the listener, the places in the list wouldn't reload on navigate back from itemView
            //self.firestorePlaceList.removePlaceListListener()
        }
    }
}

struct InnerPlaceListView: View {
    
    var placeListId: String
    
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    @Binding var placeIdToNavigateTo: String?
    @Binding var goToPlace: Int?
    
    @Binding var placeForAddPlaceToListSheet: GMSPlaceWithTimestamp?
    @Binding var imageForAddPlaceToListSheet: UIImage?
    
    @Binding var tabSelection: Int
    
    @State private var selection = 0
    
    var body: some View {
        VStack (alignment: .leading){
            VStack {
                if selection == 0 {
                    // Follow button only on foreign user profiles
                    PlaceListInfoView(placeListId: placeListId,
                                      showSheet: $showSheet,
                                      sheetSelection: $sheetSelection,
                                      tabSelection: $tabSelection)
                        .environmentObject(firestorePlaceList)
                        .padding()
                        .animation(.spring())
                        .transition(.asymmetric(insertion: .scale, removal: .scale))
                }
                
                Picker(selection: $selection.animation(), label: Text("View")) {
                    Text("List").tag(0)
                    Text("Map").tag(1)
                }
                .padding(.horizontal)
                .padding(.bottom)
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(0)
            .padding(.horizontal, 22)
            .background(Color("bg-primary"))
            
            
            if selection == 0 {
                List {
                    ForEach(self.firestorePlaceList.places, id: \.self) { place in
                        PlaceRow(place: place,
                                 placeListId: self.placeListId,
                                 showSheet: self.$showSheet,
                                 sheetSelection: self.$sheetSelection,
                                 placeIdToNavigateTo: self.$placeIdToNavigateTo,
                                 goToPlace: self.$goToPlace,
                                 placeForAddPlaceToListSheet: self.$placeForAddPlaceToListSheet,
                                 imageForAddPlaceToListSheet: self.$imageForAddPlaceToListSheet)
                    }
                    
                }
            } else {
                MapView().environmentObject(firestorePlaceList)
            }
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: HStack {
            if (self.firestorePlaceList.isOwnedPlaceList) {
                PlaceListSettingsButton(showSheet: self.$showSheet, sheetSelection: self.$sheetSelection).environmentObject(self.firestorePlaceList)
            } else if (!self.firestorePlaceList.isOwnedPlaceList) {
                PlaceListFollowButton(placeListId: self.placeListId).environmentObject(self.firestorePlaceList)
            }
        })
    }
}

struct PlaceListFollowButton: View {
    var placeListId: String
    
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    
    var body: some View {
        VStack {
            if(self.firebaseAuthentication.currentUser != nil){
                if (!self.firestorePlaceList.placeList.followerIds.contains(self.firebaseAuthentication.currentUser!.uid)) {
                    Button(action: {
                        FirestoreConnection.shared.followPlaceList(userId: self.firebaseAuthentication.currentUser!.uid, placeListId: self.placeListId)
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "heart")
                                .foregroundColor(Color("text-secondary"))
                        }
                        .frame(width: 49, height: 49)
                        
                    }
                } else if (self.firestorePlaceList.placeList.followerIds.contains(self.firebaseAuthentication.currentUser!.uid)) {
                    Button(action: {
                        FirestoreConnection.shared.unfollowPlaceList(userId: self.firebaseAuthentication.currentUser!.uid, placeListId: self.placeListId)
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color("brand-color-primary"))
                        }
                        .frame(width: 49, height: 49)
                    }
                }
            }
        }
    }
}

struct PlaceListSettingsButton: View {
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    var body: some View {
        VStack {
            Button(action: {
                self.showSheet.toggle()
                self.sheetSelection = "settings"
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "ellipsis")
                }
                .frame(width: 49, height: 49)
            }
        }
        
    }
}
