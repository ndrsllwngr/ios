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
                    .padding(.bottom, -10)
                    Spacer()
                    if (self.exploreModel.exploreList != nil && self.selection != 0) {
                        ExploreIsActiveBar(tabSelection: self.$selection)
                    }
                    HStack {
                        GeometryReader{ geo in
                            VStack {
                                //Image(systemName: self.selection == 0 ? "map.fill" : "map")
                                Image(systemName: "map")
                                    .foregroundColor(self.selection == 0 ? Color("brand-color-primary") : Color("text-secondary"))
                                Text("Explore")
                                    .foregroundColor(self.selection == 0 ? Color("brand-color-primary") : Color("text-secondary"))
                                    .font(.footnote)
                                
                            }.onTapGesture {
                                self.selection = 0
                            }.frame(width: geo.size.width)
                        }
                        
                        
                        GeometryReader{ geo in
                            VStack {
                                //Image(systemName: self.selection == 1 ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(self.selection == 1 ? Color("brand-color-primary") : Color("text-secondary"))
                                Text("Search")
                                    .foregroundColor(self.selection == 1 ? Color("brand-color-primary") : Color("text-secondary"))
                                    .font(.footnote)
                            }.onTapGesture {
                                self.selection = 1
                            }.frame(width: geo.size.width)
                        }
                        
                        
                        GeometryReader{ geo in
                            VStack {
                                //Image(systemName: self.selection == 2 ? "person.fill" : "person")
                                Image(systemName: "person")
                                    .foregroundColor(self.selection == 2 ? Color("brand-color-primary") : Color("text-secondary"))
                                Text("Profile")
                                    .foregroundColor(self.selection == 2 ? Color("brand-color-primary") : Color("text-secondary"))
                                    .font(.footnote)
                            }
                            .onTapGesture {
                                self.selection = 2
                            }
                            .frame(width: geo.size.width)
                        }
                        
                    }
                    .frame(width: metrics.size.width, height: 50)
                    .background(Color("bg-tab-bar"))
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
