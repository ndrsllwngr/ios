//
//  MapView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import UIKit
import GoogleMaps
import GooglePlaces

struct MapView: View {
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    @State var currentIndex: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottom){
            GoogleMapView(currentIndex: self.$currentIndex).environmentObject(self.firestorePlaceList)
            if(!self.firestorePlaceList.places.isEmpty){
                SwipeView(index: $currentIndex, firestorePlaceList: firestorePlaceList)
                 .frame(height: 180)
            }
            
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}



struct GoogleMapView : UIViewRepresentable {
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    @Binding var currentIndex: Int
    var defaultLocation = CLLocationCoordinate2D(
        latitude: 34.6692097,
        longitude: 135.503039
    )
    func makeUIView(context: Context) -> GMSMapView {
        
        let initialCoords = !firestorePlaceList.places.isEmpty ? firestorePlaceList.places[currentIndex].coordinate : self.defaultLocation
        let camera = GMSCameraPosition.camera(
            withLatitude: initialCoords.latitude,
            longitude: initialCoords.longitude,
            zoom: 16.0
        )
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom:170, right: 0)
        return mapView
    }
    
    func updateUIView(_ view: GMSMapView, context: Context) {
        if(firestorePlaceList.places.isEmpty) {return}
        let currentPlace = firestorePlaceList.places[currentIndex].coordinate
        view.animate(toLocation: currentPlace)
        view.clear()
        for (index,place) in self.firestorePlaceList.places.enumerated() {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: place.coordinate.latitude,
                longitude: place.coordinate.longitude
            )
            marker.title = place.name
            //marker.snippet = place.state
            if(index == currentIndex){
                marker.icon = GMSMarker.markerImage(with: .red)
            } else {
                marker.icon = GMSMarker.markerImage(with: .black)
            }
            marker.map = view
            
        }
        
    }
}

