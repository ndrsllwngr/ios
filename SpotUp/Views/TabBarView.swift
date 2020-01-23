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
    @State var selection = 1
    
    var body: some View {
        GeometryReader { metrics in
            VStack {
                VStack {
                    if (self.selection == 0) {
                        NavigationView {
                            HomeView(tabSelection: self.$selection)
                        }
                        
                    } else if (self.selection == 1) {
                        NavigationView {
                            ProfileView(profileUserId: self.firebaseAuthentication.currentUser!.uid, tabSelection: self.$selection)
                        }
                    } else if (self.selection == 2) {
                        NavigationView {
                            ExploreView()
                        }
                    }
                    Spacer()
                }
                if (self.exploreModel.exploreList != nil && self.selection != 2) {
                    ExploreIsActiveBar()
                        .frame(width: metrics.size.width, height: 49)
                        .background(Color("bg-explore-bar"))
                        //.offset(y: -49) // 49 is the exact height of the TabBar
                        .onTapGesture {
                            self.selection = 2
                    }
                }
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: self.selection == 0 ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                        Text("Search")
                    }.onTapGesture {
                        self.selection = 0
                    }
                    Spacer()
                    VStack {
                        Image(systemName: self.selection == 1 ? "person.fill" : "person")
                        Text("Profile")
                    }.onTapGesture {
                        self.selection = 1
                    }
                    Spacer()
                    VStack {
                        Image(systemName: self.selection == 2 ? "map.fill" : "map")
                        Text("Explore")
                    }.onTapGesture {
                        self.selection = 2
                    }
                    Spacer()
                }
                .frame(width: metrics.size.width, height: 50)
                .background(Color("bg-tab-bar"))
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
