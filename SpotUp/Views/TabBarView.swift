//
//  TabBar.swift
//  SpotUp
//
//  Created by Timo Erdelt on 19.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI


struct TabBarView: View {
    
    @State private var selection = 0
    
    init() {
        UITabBar.appearance().tintColor = UIColor.red
        UITabBar.appearance().backgroundColor = UIColor.red
    }
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView().tabItem({
                Image(systemName: selection == 0 ? "house.fill" : "house")
                Text("Home")
            }).tag(0)
            ProfileView()
                .tabItem({
                    Image(systemName: selection == 1 ? "person.fill" : "person")
                    Text("Profil")
                }).tag(1)
        }
        .accentColor(.white)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
