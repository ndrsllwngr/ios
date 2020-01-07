//
//  ListViewList.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var placesConnection: GooglePlacesConnection
    
    var body: some View {
        List {
            ForEach(self.placesConnection.places, id: \.self) { place in
                NavigationLink(destination: ItemView(place:place)) {
                    ListRowPlace(place : place)
                }
            }
        }
    }
}


struct ListSpots_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
