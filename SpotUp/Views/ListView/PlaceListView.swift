//
//  ListView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

let lists: [PlaceList] = [PlaceList(id: "blub", name: "Paris best Spots", owner: ListOwner(id: "bla", username: "bla"), followerIds: []), PlaceList(id: "blub", name: "Munich Ramen", owner: ListOwner(id: "bla", username: "bla"), followerIds: [])]

struct PlacelistView: View {
    
    var placeList: PlaceList
    var isOwnedPlacelist: Bool

    @State private var selection = 0
    @State var showListSettings = false
    
    var body: some View {
        VStack {
            Picker(selection: $selection, label: Text("label")) {
                Text("List").tag(0)
                Text("Map").tag(1)
            }
            .padding()
            .pickerStyle(SegmentedPickerStyle())
            
            Spacer()
            
            if selection == 0 {
                PlacelistViewList()
            } else {
                Text("Todo Map View")
                //ListViewMap()
            }
        }
        .navigationBarTitle(placeList.name)
        .navigationBarItems(trailing: ListSettingsButton())
        .sheet(isPresented: $showListSettings) {
            Text("ListSettings")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        PlacelistView(placeList: lists[0], isOwnedPlacelist: true)
    }
}

struct ListSettingsButton: View {
    @State var showListSettings = false
    var body: some View {
        Button(action: {
            self.showListSettings.toggle()
        }) {
            Image(systemName: "line.horizontal.3")
        }
    }
}
