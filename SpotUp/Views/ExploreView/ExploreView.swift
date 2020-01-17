//
//  ExploreView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 16.01.20.
//

import SwiftUI
import UIKit
import GoogleMaps
import GooglePlaces

struct ExploreView: View {
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @State var showSheet: Bool = false
    @State var sheetSelection = "none"

    @State var placeForPlaceMenuSheet: ExplorePlace? = nil
    @State var imageForPlaceMenuSheet: UIImage? = nil
    
    var body: some View {
        VStack {
            if (self.exploreModel.exploreList != nil) {
                HStack {
                    Image(systemName: "map")
                    Text("\(self.exploreModel.exploreList!.places.count) Places")
                    Button(action: {
                        self.exploreModel.quitExplore()
                    }) {
                        Text("Quit")
                    }
                }
                ExploreMapView(exploreList: self.exploreModel.exploreList!)
                    .frame(height: 180, alignment: .center)
                if !exploreModel.exploreList!.places.isEmpty {
                    PlaceRowExplore(place: exploreModel.exploreList!.currentTarget!,
                                    showSheet: self.$showSheet,
                                    sheetSelection: self.$sheetSelection,
                                    placeForPlaceMenuSheet: self.$placeForPlaceMenuSheet,
                                    imageForPlaceMenuSheet: self.$imageForPlaceMenuSheet)
                    Text("Travel Queue")
                    List {
                        ForEach (exploreModel.exploreList!.places.filter{$0 != exploreModel.exploreList!.currentTarget!}, id: \.self) { place in
                            PlaceRowExplore(place: place,
                                            showSheet: self.$showSheet,
                                            sheetSelection: self.$sheetSelection,
                                            placeForPlaceMenuSheet: self.$placeForPlaceMenuSheet,
                                            imageForPlaceMenuSheet: self.$imageForPlaceMenuSheet)
                            
                        }
                    }
                } else {
                    Spacer()
                    Text("There are currently no places in your Explore Queue. Feel free to add some!")
                }
                Spacer()
            } else {
                Button(action: {
                    self.exploreModel.startExploreWithEmptyList()
                }) {
                    Text("Start Exploring now")
                }
                Spacer()
                Text("Explore is currently not active.")
                Spacer()
            }
            
        }.sheet(isPresented: $showSheet) {
            if (self.sheetSelection == "settings") {
                ExploreSettingsSheet(showSheet: self.$showSheet)
            } else if (self.sheetSelection == "place_menu") {
                ExplorePlaceMenuSheet(place: self.placeForPlaceMenuSheet!,
                image: self.$imageForPlaceMenuSheet,
                showSheet: self.$showSheet)
            }
            
        }
            .navigationBarTitle(Text("Explore"), displayMode: .inline)
            .navigationBarItems(trailing: HStack {
                ExploreSettingsButton(showSheet: self.$showSheet, sheetSelection: self.$sheetSelection)
            })
        .padding()
    }
}


struct ExploreSettingsButton: View {
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    var body: some View {
        VStack {
            Button(action: {
                self.showSheet.toggle()
                self.sheetSelection = "settings"
            }) {
                Image(systemName: "ellipsis")
            }
        }
        
    }
}

struct ExploreMapView : UIViewRepresentable {
    var exploreList: ExploreList
    var defaultLocation = CLLocationCoordinate2D(
        latitude: 48.149552,
        longitude: 11.594079
    )
    func makeUIView(context: Context) -> GMSMapView {
        
        var initialCoordinates = self.defaultLocation
        if ( !self.exploreList.places.isEmpty) {
            initialCoordinates = self.exploreList.currentTarget!.place.coordinate
        }
        
        let camera = GMSCameraPosition.camera(
            withLatitude: initialCoordinates.latitude,
            longitude: initialCoordinates.longitude,
            zoom: 12.0
        )
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        //mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true

        return mapView
    }
    
    func updateUIView(_ view: GMSMapView, context: Context) {
        if (self.exploreList.places.isEmpty) {
            return
        }
        let currentPlace = self.exploreList.currentTarget!.place
        view.animate(toLocation: currentPlace.coordinate)
        self.exploreList.places.forEach { place in
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: place.place.coordinate.latitude,
                longitude: place.place.coordinate.longitude
            )
            marker.title = place.place.name

            if(place.place == currentPlace){
                marker.icon = GMSMarker.markerImage(with: .red)
            } else {
                marker.icon = GMSMarker.markerImage(with: .black)
            }
            marker.map = view
            
        }
        
    }
}

