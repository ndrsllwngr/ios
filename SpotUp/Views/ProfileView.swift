//
//  ProfileView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

let lists: [LocationList] = [LocationList(title: "Paris best Spots"), LocationList(title: "Munich Ramen")]

struct ProfileView: View {
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(lists) { locationList in
                    NavigationLink(
                        destination: ListView(locationList: locationList)
                    ) {
                        ListRow(locationList: locationList)
                    }
                }
            }
            .navigationBarTitle(Text("ProfileView"))
            .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
                Image(systemName: "gear")
            })
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
