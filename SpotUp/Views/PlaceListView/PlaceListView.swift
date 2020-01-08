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
    var isOwnedPlacelist: Bool
    
    @ObservedObject var firestorePlaceList = FirestorePlaceList()

    @State private var selection = 0
    @State var showSheet = false
    
    var body: some View {
        VStack {
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
        .navigationBarTitle(firestorePlaceList.placeList != nil ? firestorePlaceList.placeList!.name : "")
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
        }
        .onDisappear {
            self.firestorePlaceList.removePlaceListListener()
        }
    }
}

//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceListView(placeList: lists[0], isOwnedPlacelist: true)
//    }
//}
