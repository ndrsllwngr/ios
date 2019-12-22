//
//  ListViewMap.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import UIKit
import GoogleMaps

struct MapSpots: View {
    var body: some View {
        GeometryReader { geometry in
            VStack{
                GoogMapView(place: placeData[0])
            }
        }
    }
}

struct MapSpots_Previews: PreviewProvider {
    static var previews: some View {
        MapSpots()
    }
}
 

struct GoogMapView : UIViewRepresentable {
    var place: Place
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(
            withLatitude: place.placeCoordinate.latitude,
            longitude: place.placeCoordinate.longitude,
            zoom: 6.0
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
        for place in placeData {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: place.placeCoordinate.latitude,
                longitude: place.placeCoordinate.longitude
            )
            marker.title = place.name
            marker.snippet = place.state
            marker.icon = GMSMarker.markerImage(with: .black) //Set Marker color
            marker.map = view
            print("Place name",place.name)
            print("latitude: ",place.placeCoordinate.latitude,"longitude: ",place.placeCoordinate.longitude)
        }
        
    }
}
