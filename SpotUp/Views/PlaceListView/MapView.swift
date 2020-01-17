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
                SwipeView(index: self.$currentIndex).environmentObject(self.firestorePlaceList)
                    .frame(height: 180)
            }
            
        }
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
        let initialCoords = !firestorePlaceList.places.isEmpty ? firestorePlaceList.places[currentIndex].gmsPlace.coordinate : self.defaultLocation
        
        let camera = GMSCameraPosition.camera(
            withLatitude: initialCoords.latitude,
            longitude: initialCoords.longitude,
            zoom: 10.0
        )
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        //mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.delegate = context.coordinator
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom:160, right: 0)
        context.coordinator.firestorePlaceList = self.firestorePlaceList
        return mapView
    }
    
    func updateUIView(_ view: GMSMapView, context: Context) {
        if(firestorePlaceList.places.isEmpty) {return}
        context.coordinator.firestorePlaceList = self.firestorePlaceList
        let currentPlace = firestorePlaceList.places[currentIndex].gmsPlace.coordinate
        view.animate(toLocation: currentPlace)
        view.clear()
        for (index,place) in self.firestorePlaceList.places.enumerated() {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: place.gmsPlace.coordinate.latitude,
                longitude: place.gmsPlace.coordinate.longitude
            )
            marker.title = place.gmsPlace.name
            //marker.snippet = place.state
            if(index == currentIndex){
                marker.icon = GMSMarker.markerImage(with: .red)
                marker.appearAnimation = GMSMarkerAnimation.pop
            } else {
                marker.icon = GMSMarker.markerImage(with: .black)
            }
            marker.map = view
            
        }
        
    }
    func makeCoordinator() -> GoogleMapView.Coordinator {
        return Coordinator(self)
    }
    
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var firestorePlaceList: FirestorePlaceList?
        let parent: GoogleMapView
        
        init(_ parent: GoogleMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            let index = firestorePlaceList?.places.firstIndex { (place) -> Bool in
                return place.gmsPlace.name == marker.title ?? ""
            }
            if let index = index {
                self.parent.currentIndex = Int(index)
            }

            return true
        }
    }
}
