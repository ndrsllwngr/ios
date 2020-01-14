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
    
    @State var showSheet = false
    
    var body: some View {
        VStack {
            InnerPlaceListView(placeListId: placeListId, showSheet: $showSheet).environmentObject(firestorePlaceList)
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
            PlaceListSettings(showSheet: self.$showSheet).environmentObject(self.firestorePlaceList)
        }
    }
}

struct InnerPlaceListView: View {
    
    var placeListId: String
    
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    
    @Binding var showSheet: Bool
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
                ListView().environmentObject(firestorePlaceList)
            } else {
                MapView().environmentObject(firestorePlaceList)
            }
        }
        .navigationBarTitle(Text(self.firestorePlaceList.placeList.name), displayMode: .inline)
        .navigationBarItems(trailing: PlaceListSettingsButton(showSheet: self.$showSheet).environmentObject(self.firestorePlaceList))
    }
}

struct PlaceListInfoView: View {
    
    var placeListId: String
    
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    
    var body: some View {
        VStack {
            if (!self.firestorePlaceList.isOwnedPlaceList) {
                if (!self.firestorePlaceList.placeList.followerIds.contains(self.firebaseAuthentication.currentUser!.uid)) {
                    Button(action: {
                        FirestoreConnection.shared.followPlaceList(userId: self.firebaseAuthentication.currentUser!.uid, placeListId: self.placeListId)
                        
                    }) {
                        Text("Follow")
                    }
                } else if (self.firestorePlaceList.placeList.followerIds.contains(self.firebaseAuthentication.currentUser!.uid)) {
                    Button(action: {
                        FirestoreConnection.shared.unfollowPlaceList(userId: self.firebaseAuthentication.currentUser!.uid, placeListId: self.placeListId)
                    }) {
                        Text("Unfollow")
                    }
                }
            }
        }
    }
}

struct PlaceListSettingsButton: View {
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack {
            if (firestorePlaceList.isOwnedPlaceList) {
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    Image(systemName: "line.horizontal.3")
                }
            }
        }
        
    }
}

//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceListView(placeList: lists[0], isOwnedPlacelist: true)
//    }
//}
