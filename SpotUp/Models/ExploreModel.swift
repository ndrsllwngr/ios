import Foundation
import GooglePlaces

class ExploreModel: ObservableObject {
    
    static let shared = ExploreModel()
    @Published var locationManager = LocationManager()
    
    @Published var exploreList: ExploreList? = nil
    
    private init(){
        self.locationManager.startUpdating()
        
    }
    
    func startExploreWithEmptyList() {
        self.exploreList = ExploreList(places: [])
        self.locationManager.startUpdating()
    }
    
    func startExploreWithPlaceList(placeList: PlaceList, places: [GMSPlace]) {
        if (places.isEmpty) {
            self.exploreList = ExploreList()
        } else {
            let placesSortedByDistance = sortPlacesByDistanceToCurrentLocation(places)
            self.exploreList = ExploreList(places: placesSortedByDistance, currentTarget: placesSortedByDistance[0])
        }
    }
    
    func addPlaceToExplore(_ place: GMSPlace) {
        let explorePlace = ExplorePlace(place: place)
        if self.exploreList != nil {
            self.exploreList?.places.append(explorePlace)
            if (self.exploreList!.places.count == 1) {
                self.exploreList?.currentTarget = explorePlace
            }
        } else {
            self.exploreList = ExploreList(places: [explorePlace])
        }
    }
    
    func removePlaceFromExplore(_ place: ExplorePlace) {
        if self.exploreList != nil {
            self.exploreList!.places = self.exploreList!.places.filter{$0 != place}
        }
    }
    
    func quitExplore() {
        self.exploreList = nil
    }
    
    
    
    func changeCurrentTargetTo(_ place: ExplorePlace) {
        self.exploreList?.currentTarget = place
    }
    
    func sortPlacesByDistanceToCurrentLocation(_ places: [GMSPlace]) -> [ExplorePlace] {
        return places.map { place in
            if (self.locationManager.lastKnownLocation != nil) {
                print("location")
                let placeLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                let distance = placeLocation.distance(from: self.locationManager.lastKnownLocation!)
                return ExplorePlace(place: place, distance: distance)
            } else {
                print("no location")
                return ExplorePlace(place: place)
            }
        }
        // ToDo implement
    }
    
}



struct ExploreList: Equatable {
    var places: [ExplorePlace] = []
    var currentTarget: ExplorePlace? = nil
}

struct ExplorePlace: Equatable, Hashable {
    var place: GMSPlace
    var distance: CLLocationDistance? = nil
}
