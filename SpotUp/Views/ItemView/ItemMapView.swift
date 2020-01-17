//
//  ItemMapView.swift
//  SpotUp
//
//  Created by Havy Ha on 05.12.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import MapKit
import GoogleMaps

struct ItemMapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
   
    func makeUIView(context: Context) -> GMSMapView {

        let camera = GMSCameraPosition.camera(
            withLatitude: coordinate.latitude,
            longitude: coordinate.longitude,
            zoom: 12.0
        )
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        return mapView
    }
    
    func updateUIView(_ view: GMSMapView, context: Context) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.map = view
    }
    
    
}


struct ItemMapView_Previews: PreviewProvider {
    static var previews: some View {
        ItemMapView(coordinate: CLLocationCoordinate2D(latitude:59.987329384, longitude:-141.38749845) )
    }
}

