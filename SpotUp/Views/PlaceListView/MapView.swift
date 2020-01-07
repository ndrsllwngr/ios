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
    @State var currentIndex: Int = 0
    var body: some View {
            VStack{
                ZStack{
                    GoogMapView(currentIndex: self.$currentIndex).environmentObject(self.placesConnection)
                    if(!self.placesConnection.places.isEmpty){
                        PlaceCard(currentIndex: self.$currentIndex).environmentObject(self.placesConnection)
                    }
                }
                
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
    @Binding var currentIndex: Int
    var defaultLocation = CLLocationCoordinate2D(
        latitude: 34.6692097,
        longitude: 135.503039
    )
    func makeUIView(context: Context) -> GMSMapView {
       
        let initialCoords = !placesConnection.places.isEmpty ? placesConnection.places[currentIndex].coordinates : self.defaultLocation
        let camera = GMSCameraPosition.camera(
            withLatitude: initialCoords.latitude,
            longitude: initialCoords.longitude,
            zoom: 16.0
        )
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        //mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom:400, right: 0)
        return mapView
    }
    
    func updateUIView(_ view: GMSMapView, context: Context) {
        if(placesConnection.places.isEmpty) {return}
        let currentPlace = placesConnection.places[currentIndex].coordinates
        view.animate(toLocation: currentPlace)
        view.clear()
        for (index,place) in self.placesConnection.places.enumerated() {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: place.coordinates.latitude,
                longitude: place.coordinates.longitude
            )
            marker.title = place.name
            //marker.snippet = place.state
            if(index == currentIndex){
                marker.icon = GMSMarker.markerImage(with: .black)
            } else {
                marker.icon = GMSMarker.markerImage(with: .red)
            }
            marker.map = view
            
        }

    }
}

struct PlaceCard: View {
    @EnvironmentObject var placesConnection: GooglePlacesConnection
    @Binding var currentIndex: Int
    
    var body: some View {
        VStack{
            
            HStack {
                if(self.currentIndex > 0){
                    Button(action: {
                        self.currentIndex-=1
                    }) {
                        Text("Previous Place")
                    }
                }
                
                Text(self.placesConnection.places[self.currentIndex].name)
                    .background(Color.black)
                
                if(self.currentIndex < (self.placesConnection.places.count - 1)){
                    Button(action: {
                        self.currentIndex+=1
                    }) {
                        Text("Next Place")
                    }
                }
                
            }
            .frame(width: 240, height: 100)
            .background(Color.white)
            .offset(y: 120)
            .shadow(radius: 15)
        }
    }
}


