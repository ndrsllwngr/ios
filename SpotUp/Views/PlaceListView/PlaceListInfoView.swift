//
//  PlaceListInfoView.swift
//  SpotUp
//
//  Created by Fangli Lu on 17.01.20.
//

import Foundation
import SwiftUI

struct PlaceListInfoView: View {
    
    var placeListId: String
    
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    
    var body: some View {
        VStack {
            HStack {
                FirebasePlaceListInfoImage(imageUrl: self.firestorePlaceList.placeList.imageUrl)
                    .clipShape(Rectangle())
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(15)
                    .padding(.top)
                
                VStack (alignment: .leading){
                    Text(self.firestorePlaceList.placeList.name)
                    HStack {
                        Text("by \(self.firestorePlaceList.placeList.owner.username)")
                        HStack {
                            Image(systemName: "map.fill")
                            Text("\(self.firestorePlaceList.placeList.places.map{$0.placeId}.count)")
                        }
                        HStack {
                            Image(systemName: "person.fill")
                            Text("\(self.firestorePlaceList.placeList.followerIds.count)")
                        }
                    }
                    Button(action: {
                        print("Explore")
                    }) {
                        Text("Explore")
                    }
                }
            }
        }
    }
}
