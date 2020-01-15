//
//  ListViewList.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct ListView: View {
    
    var placeListId: String

    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    
    var body: some View {
        List {
            ForEach(self.firestorePlaceList.places, id: \.self) { (place: GMSPlaceWithTimestamp) in
                    NavigationLink(destination: ItemView(place: place.gmsPlace)) {
                        ListRowPlace(place : place.gmsPlace)
                }
            }.onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach {index in
            let placeToDelete = firestorePlaceList.places[index]
            FirestoreConnection.shared.deletePlaceFromList(placeListId: placeListId, place: placeToDelete)
        }
    }
}
