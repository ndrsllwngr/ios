import Foundation
import GooglePlaces

class ExploreModel: ObservableObject {
    
    static let shared = ExploreModel()
    
    @Published var locationManager = LocationManager()
    @Published var exploreList: ExploreList? = nil

    
    func startExploreWithEmptyList() {
        self.exploreList = ExploreList(places: [])
    }
    
    func startExploreWithPlaceList(placeList: PlaceList, places: [GMSPlace]) {
        if (places.isEmpty) {
            self.exploreList = ExploreList()
        } else {
            let explorePlaces =  places.map { place in
                    return ExplorePlace(place: place)
            }
            self.exploreList = ExploreList(places: explorePlaces)
        }
    }
    
    func addPlaceToExplore(_ place: GMSPlace) {
        let explorePlace = ExplorePlace(place: place)
        if let exploreList = self.exploreList {
            self.exploreList?.places.append(explorePlace)
            if (exploreList.currentTarget == nil) {
                self.exploreList!.currentTarget = explorePlace
            }
        } else {
            self.exploreList = ExploreList(places: [explorePlace])
        }
        self.updateDistancesInPlaces()
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
                return ExplorePlace(place: place)
        }
        // ToDo implement
    }
    
    func updateDistancesInPlaces() {
        // if explore active and we already have a location
        if let exploreList = self.exploreList, let location = self.locationManager.location {
            // 1. calculate distance to my location for all places
            let explorePlaces: [ExplorePlace] = exploreList.places.map { place in
                let distance = calculateDistance(coordinate: place.place.coordinate,
                location: location)
                return ExplorePlace(place: place.place,
                                    distance: distance)
            }
            // 2. sort places based on distance
            .sorted{(place1, place2) in place1.distance! < place2.distance!}
            self.exploreList!.places = explorePlaces
            // If no currentTarget set by user yet set current target
            if (self.exploreList!.currentTarget == nil) {
                self.exploreList?.currentTarget = explorePlaces[0]
            }
        }
    }
}

func calculateDistance(coordinate: CLLocationCoordinate2D, location: CLLocation) -> CLLocationDistance {
    return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distance(from: location)
}

func getDistanceStringToDisplay(_ distance: CLLocationDistance) -> String {
    
    let roundedDistance = (distance * 1).rounded(.toNearestOrEven) / 1
    if (roundedDistance > 1000) {
        return String(format: "%.1f", (roundedDistance/1000 * 1).rounded(.toNearestOrEven) / 1) + " km"
    } else {
        return String(format: "%.0f", roundedDistance) + " m"
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

