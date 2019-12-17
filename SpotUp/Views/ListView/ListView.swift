//
//  ListView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

let lists: [PlaceList] = [PlaceList(id: "blub", name: "Paris best Spots", owner: SimpleUser(id: "bla", username: "bla")), PlaceList(id: "blub", name: "Munich Ramen", owner: SimpleUser(id: "bla", username: "bla")), PlaceList(id: "blub", name:"DummieList", owner: SimpleUser(id: "bla", username: "bla"))]

struct ListView: View {
    @State private var selection = 0
    @State var showListSettings = false
    
    var placeList: PlaceList
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
                ListViewList()
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
        ListView(placeList: lists[0])
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
