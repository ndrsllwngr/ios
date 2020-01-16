//
//  ExploreView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 16.01.20.
//

import SwiftUI

struct ExploreView: View {
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @State var showSheet: Bool = false
    
    @State var placeForPlaceMenuSheet: GMSPlaceWithTimestamp? = nil
    @State var imageForPlaceMenuSheet: UIImage? = nil
    var body: some View {
        VStack {
            if (self.exploreModel.exploreList != nil) {
                Text("Current target")
                if !exploreModel.exploreList!.places.isEmpty {
                    PlaceRowExplore(place: exploreModel.exploreList!.currentTarget!,
                                    showSheet: self.$showSheet,
                                    placeForPlaceMenuSheet: self.$placeForPlaceMenuSheet,
                                    imageForPlaceMenuSheet: self.$imageForPlaceMenuSheet)
                    Text("Other Places")
                    List {
                        ForEach (exploreModel.exploreList!.places.filter{$0 != exploreModel.exploreList!.currentTarget!}, id: \.self) { place in
                            PlaceRowExplore(place: place,
                                            showSheet: self.$showSheet,
                                            placeForPlaceMenuSheet: self.$placeForPlaceMenuSheet,
                                            imageForPlaceMenuSheet: self.$imageForPlaceMenuSheet)
                            
                        }
                    }
                } else {
                    Text("There are currently no places in your Explore Queue. Feel free to add some!")
                }
            } else {
                Text("Explore is currently not active.")
                
                Button(action: {
                    self.exploreModel.startWithEmptyExploreList()
                }) {
                    Text("Start Exploring now")
                }.padding()
            }
            
        }.sheet(isPresented: $showSheet) {
            ExplorePlaceMenuSheet(gmsPlaceWithTimestamp: self.placeForPlaceMenuSheet!,
                                  image: self.$imageForPlaceMenuSheet,
                                  showSheet: self.$showSheet)
        }
        .padding()
    }
}
