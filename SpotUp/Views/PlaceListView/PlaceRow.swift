//
//  ListComponent.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import GooglePlaces

struct PlaceRow: View {
    var gmsPlaceWithTimestamp: GMSPlaceWithTimestamp
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    @Binding var placeIdToNavigateTo: String?
    @Binding var goToPlace: Int?
    
    @Binding var placeForPlaceMenuSheet: GMSPlaceWithTimestamp?
    
    var body: some View {
        GeometryReader { metrics in
            HStack(alignment: .center) {
                HStack {
                    Text(self.gmsPlaceWithTimestamp.gmsPlace.name != nil ? self.gmsPlaceWithTimestamp.gmsPlace.name! : "")
                    Spacer()
                }
                    .frame(width: metrics.size.width * 0.7)
                    .onTapGesture {
                        self.placeIdToNavigateTo = self.gmsPlaceWithTimestamp.gmsPlace.placeID!
                        self.goToPlace = 1
                }
                HStack {
                    Spacer()
                    Image(systemName: "ellipsis")
                }
                    .frame(width: metrics.size.width * 0.3)
                    .onTapGesture {
                        self.showSheet.toggle()
                        self.sheetSelection = "place_menu"
                        self.placeForPlaceMenuSheet = self.gmsPlaceWithTimestamp
                }
            }
        }
        .frame(height: 60)
    }
}

//struct ListComponent_Previews: PreviewProvider {
//    static var previews:some View{
//        Group {
//            ListRowPlace(place: placeData[0])
//            ListRowPlace(place: placeData[1])
//
//        }
//          .previewLayout(.fixed(width: 300, height: 70))
//    }
//}
