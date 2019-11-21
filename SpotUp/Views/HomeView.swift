//
//  HomeView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @State var searchQuery: String = ""
    
    var body: some View {
        NavigationView {

            VStack {
                SearchBar(text: $searchQuery)
                    .padding()
                Spacer()
            }
            .navigationBarTitle(Text("HomeView"))

        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


