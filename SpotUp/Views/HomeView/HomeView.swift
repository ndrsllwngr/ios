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
    @State private var searchTerm: String = ""
    @ObservedObject var searchSpace = FirestoreSearch()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredUsers: [User] = []
    var filteredLists: [PlaceList] = []
    
    var body: some View {
        
        VStack {
            NavigationView {
                
                VStack {
                    
                    TextField("Search \(selection)", text: $searchTerm)
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
                        }
                        
                    } else if selection == "lists" {
                        VStack{
                            List{
                                ForEach(self.searchSpace.allPublicPlaceLists.filter{self.searchTerm.isEmpty ? false : $0.name.localizedCaseInsensitiveContains(self.searchTerm)}) {
                                    (placeList: PlaceList) in NavigationLink(destination: PlaceListView(placeList: placeList, isOwnedPlacelist: false)){Text(placeList.name)}
                                }
                            }
                            
                            Spacer()
                        }
                    } else {
                        VStack{
                            List{
                                ForEach(self.searchSpace.allUsers.filter{self.searchTerm.isEmpty ? false : $0.username.localizedCaseInsensitiveContains(self.searchTerm)}) {
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
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


