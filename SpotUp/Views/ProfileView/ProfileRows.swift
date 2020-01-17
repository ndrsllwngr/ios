//
//  ProfileRows.swift
//  SpotUp
//
//  Created by Timo Erdelt on 21.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct CreateNewPlaceListRow: View {
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    var body: some View {
        Button(action: {
            print("buttonPressed")
            self.sheetSelection = "create_placelist"
            self.showSheet.toggle()
        }) {
            HStack {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text("Create new place list")
            }
        }
    }
}

struct PlacesListRow: View {
    var placeList: PlaceList
    
    var body: some View {
        HStack {
            
            FirebasePlaceListRowImage(imageUrl: placeList.imageUrl)
            .scaledToFill()
            .frame(width: 100, height: 100)
            .mask(
                Rectangle()
                .frame(width: 120, height: 100)
                .cornerRadius(15)
            )
            
            VStack(alignment: .leading) {
                Text(placeList.name)
                    .bold()
                Text("von \(placeList.owner.username)")
            }
            if (!placeList.isPublic) {
                Image(systemName: "lock.circle.fill")
            }
            if (placeList.isCollaborative) {
                Image(systemName: "person.3.fill")
            }
        }
    }
}
