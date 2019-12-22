//
//  HomeView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State private var selection = "places"
    @State var searchQuery: String = ""
    @ObservedObject var searchSpace = FirestoreSearch()
    
    var body: some View {
        
        VStack {
            NavigationView {
                
                VStack {
                    
                    TextField("Search", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Picker(selection: $selection, label: Text("View")) {
                        Text("Places").tag("places")
                        Text("Lists").tag("lists")
                        Text("Accounts").tag("accounts")
                        
                    }
                    .padding()
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Spacer()
                    
                    if selection == "places" {
                        VStack{
                            Spacer()
                                Button(action: {self.printFuse()}) {
                                    Text("hi")
                                }
                        }
                        
                    } else if selection == "lists" {
                        VStack{
                            List{
                                ForEach(self.searchSpace.allPublicPlaceLists) {
                                    (placeList: PlaceList) in NavigationLink(destination: PlaceListView(placeList: placeList, isOwnedPlacelist: false)){Text(placeList.name)}
                                }
                            }
                            
                            Spacer()
                        }
                    } else {
                        VStack{
                            List{
                                ForEach(self.searchSpace.allUsers) {
                                    (user: User) in NavigationLink(destination: ProfileView(isMyProfile: false, profileUserId: user.id)){Text(user.username)}
                                }
                            }
                            
                            Spacer()
                        }
                    }
                }
                .navigationBarTitle(Text("Search"))
                
            }
            
        }.onAppear {
            self.searchSpace.getAllPublicPlaceLists()
            self.searchSpace.getAllUsers()
        }
        .onDisappear {
            self.searchSpace.cleanAllPublicPlaceLists()
            self.searchSpace.cleanAllUsers()
        }
    }
    func printFuse() {
//        let fuse = Fuse()
//        let accountsIndexes = fuse.search("Tim", in: ["Timo", "Andreas", "Havy"])
//        print(self.searchQuery)
//        print(self.searchSpace.allUsers)
//        print(accountsIndexes)
//        accountsIndexes.forEach { item in
//            print("index: \(item.index)")
//            print("score: \(item.score)")
//        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


