//
//  TabBar.swift
//  SpotUp
//
//  Created by Timo Erdelt on 19.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI


struct TabBarView: View {
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject var searchViewModel = SearchViewModel()
    @State private var selection = 0
    
    init() {
        UITabBar.appearance().tintColor = UIColor.red
        UITabBar.appearance().backgroundColor = UIColor.red
    }
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                HomeView().environmentObject(self.searchViewModel)
            }
            .tabItem({
                Image(systemName: selection == 0 ? "magnifyingglass" : "magnifyingglass")
                Text("Search")
            }).tag(0)
            NavigationView {
                ProfileView(profileUserId: firebaseAuthentication.currentUser!.uid)
            }
            .tabItem({
                Image(systemName: selection == 1 ? "person.fill" : "person")
                Text("Profil")
            }).tag(1)
        }
        .accentColor(.black)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
