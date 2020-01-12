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
    
    @State private var selection = 0
    @State var showSheet = false
    
    var body: some View {
        VStack {
            if (!self.firestorePlaceList.isOwnedPlaceList && self.firestorePlaceList.placeList == nil) {
                Text("")
            } else if (!self.firestorePlaceList.isOwnedPlaceList && !self.firestorePlaceList.placeList!.followerIds.contains(self.firebaseAuthentication.currentUser!.uid)) {
                Button(action: {
                    FirestoreConnection.shared.followPlaceList(userId: self.firebaseAuthentication.currentUser!.uid, placeListId: self.placeListId)
                    
                }) {
                    Text("Follow")
                }
            } else if (!self.firestorePlaceList.isOwnedPlaceList && self.firestorePlaceList.placeList!.followerIds.contains(self.firebaseAuthentication.currentUser!.uid)){
                Button(action: {
                    FirestoreConnection.shared.unfollowPlaceList(userId: self.firebaseAuthentication.currentUser!.uid, placeListId: self.placeListId)
                }) {
                    Text("Unfollow")
                }
            }
            
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
            .onAppear {
                print("PlaceListView ON APPEAR")
                self.firestorePlaceList.addPlaceListListener(placeListId: self.placeListId, ownUserId: self.firebaseAuthentication.currentUser!.uid)
            }
            .onDisappear {
                print("PlaceListView ON DISAPPEAR")
                self.firestorePlaceList.removePlaceListListener()
            }
            .sheet(isPresented: $showSheet) {
                    PlaceListSettings(showSheet: self.$showSheet).environmentObject(self.firestorePlaceList)
            }
        .navigationBarTitle(self.firestorePlaceList.placeList != nil ? self.firestorePlaceList.placeList!.name : "loading")
        .navigationBarItems(trailing: Button(action: {
            self.showSheet.toggle()
        }) {
            Image(systemName: "line.horizontal.3")
        })
            
        
    }
}

//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceListView(placeList: lists[0], isOwnedPlacelist: true)
//    }
//}
