//
//  ListViewMap.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import GoogleMaps
import GooglePlaces

struct PlacelistViewMap:UIViewRepresentable {

        let places = placeData
        
       
        func makeUIView(context:Self.Context)-> GMSMapView{GMSServices.provideAPIKey("***REMOVED***")

            let camera = GMSCameraPosition.camera(withLatitude: places[5].placeCoordinate.latitude, longitude: places[5].placeCoordinate.longitude, zoom: 6.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
           
            return mapView
        }
        
        func updateUIView(_ mapView:GMSMapView, context:Self.Context){
            for place in places
            {let marker : GMSMarker = GMSMarker ()
                marker.position = CLLocationCoordinate2D(latitude:place.placeCoordinate.latitude, longitude:place.placeCoordinate.longitude)
                 marker.map = mapView
            }
           
            
        }
        
        
    }

struct ListViewMap_Previews: PreviewProvider {
    static var previews: some View {
        PlacelistViewMap()
    }
}
