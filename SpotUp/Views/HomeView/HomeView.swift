//
//  HomeView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var searchSpace = FirestoreSearch()
    @State private var selection = "places"
    @State var searchQuery: String = ""
    
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
                        Text("Places")
                    } else if selection == "lists" {
                        ListsResults(searchQuery: $searchQuery)
                    } else {
                        AccountsResults()
                    }
                }
                .navigationBarTitle(Text("Search"))
                
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


