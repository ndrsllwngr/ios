//
//  GoogleMapsViewController.swift
//  SpotUp
//
//  Created by Fangli Lu on 14.01.20.
//

import Foundation
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    var tappedMarker : GMSMarker?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.delegate = self
        self.tappedMarker = GMSMarker()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }

        locationManager.startUpdatingLocation()

        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }

        let loc = location.coordinate

        let marker = GMSMarker(position: loc)
        marker.title = "You are here"
        marker.map = mapView

        mapView.camera = GMSCameraPosition(target: loc, zoom: 15, bearing: 0, viewingAngle: 0)

        locationManager.stopUpdatingLocation()
    }
}

//class GoogleMapsViewController: UIViewController, UIViewRepresentable, GMSMapViewDelegate, CLLocationManagerDelegate {
////    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
////    @Binding var currentIndex: Int
//    var defaultLocation = CLLocationCoordinate2D(
//        latitude: 34.6692097,
//        longitude: 135.503039
//    )
//    var locationManager = CLLocationManager()
//    var userLocation = CLLocation()
//
//    var userMarker = GMSMarker()
//
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////    }
//
//    func makeUIView(context: Context) -> GMSMapView {
//
//        let initialCoords = !firestorePlaceList.places.isEmpty ? firestorePlaceList.places[currentIndex].gmsPlace.coordinate : self.defaultLocation
//
//        let camera = GMSCameraPosition.camera(
//            withLatitude: initialCoords.latitude,
//            longitude: initialCoords.longitude,
//            zoom: 16.0
//        )
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        mapView.settings.myLocationButton = true
//        mapView.isMyLocationEnabled = true
//        mapView.settings.compassButton = true
//        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom:170, right: 0)
//        return mapView
//    }
//
//
//
//
//    func updateUIView(_ view: GMSMapView, context: Context) {
//        if(firestorePlaceList.places.isEmpty) {return}
//        let currentPlace = firestorePlaceList.places[currentIndex].gmsPlace.coordinate
//        view.animate(toLocation: currentPlace)
//        view.clear()
//        for (index,place) in self.firestorePlaceList.places.enumerated() {
//            let marker = GMSMarker()
//            marker.position = CLLocationCoordinate2D(
//                latitude: place.gmsPlace.coordinate.latitude,
//                longitude: place.gmsPlace.coordinate.longitude
//            )
//            marker.title = place.gmsPlace.name
//            //marker.snippet = place.state
//            if(index == currentIndex){
//                marker.icon = GMSMarker.markerImage(with: .red)
//            } else {
//                marker.icon = GMSMarker.markerImage(with: .black)
//            }
//            marker.map = view
//
//        }
//
//    }
//
//}


