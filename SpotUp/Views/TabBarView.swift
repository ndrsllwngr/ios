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
    @ObservedObject var exploreModel = ExploreModel.shared
    @State var selection = 0
    
    init() {
        UITabBar.appearance().tintColor = UIColor.red
        UITabBar.appearance().backgroundColor = UIColor.red
    }
    
    var body: some View {
        GeometryReader { metrics in
            ZStack(alignment: .bottom) {
                TabView(selection: self.$selection) {
                    NavigationView {
                        HomeView()
                    }
                    .tabItem({
                        Image(systemName: self.selection == 0 ? "magnifyingglass" : "magnifyingglass")
                        Text("Search")
                    }).tag(0)
                    NavigationView {
                        ProfileView(profileUserId: self.firebaseAuthentication.currentUser!.uid)
                    }
                    .tabItem({
                        Image(systemName: self.selection == 1 ? "person.fill" : "person")
                        Text("Profil")
                    }).tag(1)
                    NavigationView {
                        ExploreView()
                    }
                    .tabItem({
                        Image(systemName: self.selection == 2 ? "map.fill" : "map")
                        Text("Explore")
                    }).tag(2)
                }
                .accentColor(.black)
                if (self.exploreModel.exploreList != nil && self.selection != 2) {
                    ExploreIsActiveBar()
                        .frame(width: metrics.size.width, height: 49)
                        .background(Color.gray)
                        .offset(y: -49) // 49 is the exact height of the TabBar
                        .onTapGesture {
                            self.selection = 2
                    }
                }
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
