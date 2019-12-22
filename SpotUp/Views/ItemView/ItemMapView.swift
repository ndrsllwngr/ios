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

//The UIViewRepresentable protocol has two requirements: a makeUIView(context:) method that creates an MKMapView, and an updateUIView(_:context:) method that configures the view and responds to any changes.
struct ItemMapView: UIViewRepresentable {
    var coordinate:CLLocationCoordinate2D
    let marker : GMSMarker = GMSMarker ()
   
    func makeUIView(context:Self.Context)-> GMSMapView{GMSServices.provideAPIKey("AIzaSyBJgMwNKkk8i8Ue5TmmLHDrwoNyO5iYMMQ")

        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
       
        return mapView
    }
    
    func updateUIView(_ mapView:GMSMapView, context:Self.Context){
        marker.position = CLLocationCoordinate2D(latitude:coordinate.latitude, longitude:coordinate.longitude)
        marker.map = mapView
        
    }
    
    
}


struct ItemMapView_Previews: PreviewProvider {
    static var previews: some View {
        ItemMapView(coordinate: placeData[0].placeCoordinate)
    }
}

