//
//  ListsResults.swift
//  SpotUp
//
//  Created by Andreas Ellwanger on 22.12.19.
//

import SwiftUI
import GooglePlaces

struct ListsResults: View {
    @Binding var googlePlaces: [GMSAutocompletePrediction]
    var body: some View {
        List { ForEach(self.googlePlaces, id: \.placeID) {
            result in HStack {
                //                Text(result.placeID)
                NavigationLink(destination: ItemView(id: result.placeID)) {
                    Text(result.attributedFullText.string)
                }
                Spacer()
                }
            }
            Spacer()
        }
    }
}

//struct ListsResults_Previews: PreviewProvider {
//    static var previews: some View {
////        ListsResults()
//    }
//}
