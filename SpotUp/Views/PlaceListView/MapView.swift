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

struct MapView: View {
    @EnvironmentObject var placesConnection: GooglePlacesConnection

    var body: some View {
            VStack{
                GoogMapView().environmentObject(self.placesConnection)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

struct GoogMapView : UIViewRepresentable {
    @EnvironmentObject var placesConnection: GooglePlacesConnection
    
    func makeUIView(context: Context) -> GMSMapView {
        let initialPlace = placesConnection.places[0]
        let camera = GMSCameraPosition.camera(
            withLatitude: initialPlace.coordinates.latitude,
            longitude: initialPlace.coordinates.longitude,
            zoom: 16.0
        )
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
//        mapView.addSubview(SpotOnMap())
//        mapView.bringSubviewToFront(SpotOnMap())
        return mapView
    }
    
    func updateUIView(_ view: GMSMapView, context: Context) {
        for place in self.placesConnection.places {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: place.coordinates.latitude,
                longitude: place.coordinates.longitude
            )
            marker.title = place.name
            //marker.snippet = place.state
            marker.icon = GMSMarker.markerImage(with: .black) //Set Marker color
            marker.map = view
            print("Place name",place.name)
            print("latitude: ",place.coordinates.latitude,"longitude: ",place.coordinates.longitude)
        }
        
    }
}
