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
    @State var selection = 2
    
    var body: some View {
        GeometryReader { metrics in
            ZStack{
                VStack(spacing: 0) {
                    HStack(spacing: 0){
                        Spacer()
                    }
                    Spacer()
                }
                .frame(minHeight: 0, maxHeight: .infinity)
                    //                .background(Color.red)
                    .background(Color("bg-tab-bar"))
                    .edgesIgnoringSafeArea(.bottom)
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        if (self.selection == 0) {
                            NavigationView {
                                ExploreView(tabSelection: self.$selection)
                            }
                            
                        } else if (self.selection == 1) {
                            NavigationView {
                                SearchView(tabSelection: self.$selection)
                            }
                        } else if (self.selection == 2) {
                            NavigationView {
                                ProfileView(profileUserId: self.firebaseAuthentication.currentUser!.uid, tabSelection: self.$selection)
                                
                            }
                        }
                    }
                    Spacer()
                    if (self.exploreModel.exploreList != nil && self.selection != 0) {
                        ExploreIsActiveBar(tabSelection: self.$selection)
                    }
                    HStack(spacing: 0) {
                        Spacer()
                        VStack {
                            Image(systemName: self.selection == 0 ? "map.fill" : "map")
                            Text("Explore")
                            
                        }.onTapGesture {
                            self.selection = 0
                        }
                        Spacer()
                        VStack {
                            Image(systemName: self.selection == 1 ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                            Text("Search")
                        }.onTapGesture {
                            self.selection = 1
                        }
                        Spacer()
                        VStack {
                            Image(systemName: self.selection == 2 ? "person.fill" : "person")
                            Text("Profile")
                        }.onTapGesture {
                            self.selection = 2
                        }
                        Spacer()
                    }
                    .frame(width: metrics.size.width, height: 50)
                    .background(Color("bg-tab-bar"))
                }
            }
            // TODO colore on the back
            //.edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
