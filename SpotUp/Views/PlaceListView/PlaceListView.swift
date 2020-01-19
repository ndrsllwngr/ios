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
    
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject var firestorePlaceList = FirestorePlaceList()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var showSheet = false
    @State var sheetSelection = "none"
    
    @State var placeIdToNavigateTo: String? = nil
    @State var goToPlace: Int? = nil
    
    @State var placeForPlaceMenuSheet: GMSPlaceWithTimestamp? = nil
    @State var imageForPlaceMenuSheet: UIImage? = nil
    
    
    var body: some View {
        VStack {
            if (self.placeIdToNavigateTo != nil) {
                NavigationLink(destination: ItemView(placeId: self.placeIdToNavigateTo!), tag: 1, selection: self.$goToPlace) {
                    Text("")
                }
            }
            InnerPlaceListView(placeListId: placeListId,
                               showSheet: $showSheet,
                               sheetSelection: $sheetSelection,
                               placeIdToNavigateTo: $placeIdToNavigateTo,
                               goToPlace: $goToPlace,
                               placeForPlaceMenuSheet: self.$placeForPlaceMenuSheet,
                               imageForPlaceMenuSheet: self.$imageForPlaceMenuSheet)
                .environmentObject(firestorePlaceList)
                .onAppear {
                    print("OnAppear PlaceListView: About to add firestorePlaceList Listener")
                    self.firestorePlaceList.addPlaceListListener(placeListId: self.placeListId, ownUserId: self.firebaseAuthentication.currentUser!.uid)
            }
            .onDisappear {
                print("onDisappear PlaceListView: About to remove firestorePlaceList Listener")
                self.firestorePlaceList.removePlaceListListener()
            }
        }
        .sheet(isPresented: $showSheet) {
            if self.sheetSelection == "settings" {
                PlaceListSettingsSheet(presentationMode: self.presentationMode,
                                       showSheet: self.$showSheet)
                    .environmentObject(self.firestorePlaceList)
            } else if self.sheetSelection == "place_menu" {
                PlaceMenuSheet(placeListId: self.placeListId,
                               gmsPlaceWithTimestamp: self.placeForPlaceMenuSheet!,
                               image: self.$imageForPlaceMenuSheet,
                               showSheet: self.$showSheet)
            }
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
    
    @Binding var placeForPlaceMenuSheet: GMSPlaceWithTimestamp?
    @Binding var imageForPlaceMenuSheet: UIImage?
    
    @State private var selection = 0
    
    var body: some View {
        VStack {
            // Follow button only on foreign user profiles
            PlaceListInfoView(placeListId: placeListId).environmentObject(firestorePlaceList)
            
            Picker(selection: $selection, label: Text("View")) {
                Text("List").tag(0)
                Text("Map").tag(1)
            }
            .padding()
            .pickerStyle(SegmentedPickerStyle())
            
            Spacer()
            
            if selection == 0 {
                List {
                    ForEach(self.firestorePlaceList.places, id: \.self) { place in
                        PlaceRow(gmsPlaceWithTimestamp: place,
                                 showSheet: self.$showSheet,
                                 sheetSelection: self.$sheetSelection,
                                 placeIdToNavigateTo: self.$placeIdToNavigateTo,
                                 goToPlace: self.$goToPlace,
                                 placeForPlaceMenuSheet: self.$placeForPlaceMenuSheet,
                                 imageForPlaceMenuSheet: self.$imageForPlaceMenuSheet)
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

struct PlaceListInfoView: View {
    
    var placeListId: String
    
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    
    var body: some View {
        VStack {
            HStack {
                FirebasePlaceListImage(imageUrl: self.firestorePlaceList.placeList.imageUrl).padding(.top)
                VStack {
                    Text(self.firestorePlaceList.placeList.name)
                    HStack {
                        Text("by \(self.firestorePlaceList.placeList.owner.username)")
                        HStack {
                            Image(systemName: "map.fill")
                            Text("\(self.firestorePlaceList.placeList.places.map{$0.placeId}.count)")
                        }
                        HStack {
                            Image(systemName: "person.fill")
                            Text("\(self.firestorePlaceList.placeList.followerIds.count)")
                        }
                    }
                    Button(action: {
                        ExploreModel.shared.startExploreWithPlaceList(placeList: self.firestorePlaceList.placeList, places: self.firestorePlaceList.places.map{$0.gmsPlace})
                    }) {
                        Text("Explore")
                    }
                }
            }
        }
    }
}

struct PlaceListFollowButton: View {
    var placeListId: String
    
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    
    var body: some View {
        VStack {
            if (!self.firestorePlaceList.placeList.followerIds.contains(self.firebaseAuthentication.currentUser!.uid)) {
                Button(action: {
                    FirestoreConnection.shared.followPlaceList(userId: self.firebaseAuthentication.currentUser!.uid, placeListId: self.placeListId)
                }) {
                    Image(systemName: "heart")
                }
            } else if (self.firestorePlaceList.placeList.followerIds.contains(self.firebaseAuthentication.currentUser!.uid)) {
                Button(action: {
                    FirestoreConnection.shared.unfollowPlaceList(userId: self.firebaseAuthentication.currentUser!.uid, placeListId: self.placeListId)
                }) {
                    Image(systemName: "heart.fill")
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
                Image(systemName: "ellipsis")
            }
        }
        
    }
}

//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceListView(placeList: lists[0], isOwnedPlacelist: true)
//    }
//}
