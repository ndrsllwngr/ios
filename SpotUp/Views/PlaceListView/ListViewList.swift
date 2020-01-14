//
//  ListViewList.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    
    var body: some View {
        List {
            ForEach(self.firestorePlaceList.gmsPlaces.sorted{ $0.addedAt.dateValue() <  $1.addedAt.dateValue()}.map{$0.gmsPlace}, id: \.self) { place in
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
