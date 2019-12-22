//
//  ListViewList.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct ListView: View {
        var body: some View {
                NavigationView {
                    List(placeData) { place in
                        ListRowPlace(place: place)
                    }
                    .navigationBarTitle(Text("Spots"))
                }
            }
        }


struct ListSpots_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
