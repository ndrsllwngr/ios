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
        GoogMapView()
    }
}

struct MapSpots_Previews: PreviewProvider {
    static var previews: some View {
        MapSpots()
    }
}

struct GoogMapView : UIViewRepresentable {
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 48.137154, longitude: 11.576124, zoom: 16.0)
        return GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    }
    
    func updateUIView(_ view: GMSMapView, context: Context) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 48.137154, longitude: 11.576124)
        marker.title = "Munich"
        marker.snippet = "Germany"
        marker.map = view
        
    }
}
