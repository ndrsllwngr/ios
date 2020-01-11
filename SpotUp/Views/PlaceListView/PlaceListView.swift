//
//  ListView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

let lists: [PlaceList] = [PlaceList(id: "blub", name: "Paris best Spots", owner: ListOwner(id: "bla", username: "bla"), followerIds: []), PlaceList(id: "blub", name: "Munich Ramen", owner: ListOwner(id: "bla", username: "bla"), followerIds: [])]

struct PlaceListView: View {
    
    var placeListId: String
    var placeListName: String
    var isOwnedPlacelist: Bool
    
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    
    @State private var selection = 0
    @State var showSheet = false
    
    var body: some View {
        VStack {
            if (!self.isOwnedPlacelist && self.firestorePlaceList.placeList == nil) {
                Text("")
            } else if (!self.isOwnedPlacelist && !self.firestorePlaceList.placeList!.followerIds.contains(self.firebaseAuthentication.currentUser!.uid)) {
                Button(action: {
                    FirestoreConnection.shared.followPlaceList(userId: self.firebaseAuthentication.currentUser!.uid, placeListId: self.placeListId)
                    
                }) {
                    Text("Follow")
                }
            } else if (!self.isOwnedPlacelist && self.firestorePlaceList.placeList!.followerIds.contains(self.firebaseAuthentication.currentUser!.uid)){
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
        .navigationBarTitle(self.firestorePlaceList.placeList != nil ? self.firestorePlaceList.placeList!.name : self.placeListName)
        .navigationBarItems(trailing: Button(action: {
            self.showSheet.toggle()
        }) {
            Image(systemName: "line.horizontal.3")
        })
            .sheet(isPresented: $showSheet) {
                PlaceListSettings(showSheet: self.$showSheet).environmentObject(self.firestorePlaceList)
        }
        .onAppear {
            self.firestorePlaceList.addPlaceListListener(placeListId: self.placeListId)
            print(self.placeListId)
            print(self.placeListName)
            dump(self.firestorePlaceList.places)
        }
        .onDisappear {
            print(self.placeListId)
            print(self.placeListName)
            dump(self.firestorePlaceList.places)
            self.firestorePlaceList.removePlaceListListener()
        }
    }
}

//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceListView(placeList: lists[0], isOwnedPlacelist: true)
//    }
//}
