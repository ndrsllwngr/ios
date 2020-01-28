import SwiftUI
import UIKit
import GoogleMaps
import GooglePlaces

struct PlaceListMapView: View {
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    // PROPS
    @Binding var sortByCreationDate: Bool
    // LOCAL
    @State var currentIndex: Int = 0
    @State var placeIdToNavigateTo: String? = nil
    @State var goToPlace: Int? = nil
    
    var body: some View {
        ZStack(alignment: .bottom){
            if (self.placeIdToNavigateTo != nil) {
                NavigationLink(destination: ItemView(placeId: self.placeIdToNavigateTo!), tag: 1, selection: self.$goToPlace) {
                    EmptyView()
                }
            }
            GoogleMapView(places: sortPlaces(places: self.firestorePlaceList.places, sortByCreationDate: sortByCreationDate),
                          currentIndex: self.$currentIndex)
            if(!self.firestorePlaceList.places.isEmpty){
                SwipeView(index: self.$currentIndex,
                          placeIdToNavigateTo: self.$placeIdToNavigateTo,
                          goToPlace: self.$goToPlace,
                          sortByCreationDate: self.$sortByCreationDate).environmentObject(self.firestorePlaceList)
                    .frame(height: 180)
            }
        }
    }
}

struct GoogleMapView : UIViewRepresentable {
    // PROPS
    var places: [GMSPlaceWithTimestamp]
    @Binding var currentIndex: Int
    // LOCAL
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var defaultLocation = CLLocationCoordinate2D(
        latitude: 48.149552,
        longitude: 11.594079
    )
    func makeUIView(context: Context) -> GMSMapView {
        let initialCoords = !places.isEmpty ? places[currentIndex].gmsPlace.coordinate : self.defaultLocation
        
        let camera = GMSCameraPosition.camera(
            withLatitude: initialCoords.latitude,
            longitude: initialCoords.longitude,
            zoom: 10.0
        )
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.delegate = context.coordinator
        if !places.isEmpty {
            mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom:160, right: 0)
        }
        context.coordinator.places = self.places
        return mapView
    }
    
    func updateUIView(_ view: GMSMapView, context: Context) {
        if(places.isEmpty) {return}
        context.coordinator.places = self.places
        let currentPlace = places[currentIndex].gmsPlace.coordinate
        view.animate(toLocation: currentPlace)
        view.clear()
        for (index,place) in self.places.enumerated() {
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
        var places: [GMSPlaceWithTimestamp]?
        let parent: GoogleMapView
        
        init(_ parent: GoogleMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            let index = places?.firstIndex { (place) -> Bool in
                return place.gmsPlace.name == marker.title ?? ""
            }
            if let index = index {
                self.parent.currentIndex = Int(index)
            }
            return true
        }
    }
}
