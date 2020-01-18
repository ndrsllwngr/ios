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
    
    func startExploreWithPlaceListAndFetchPlaces(placeList: PlaceList) {
        self.exploreList = ExploreList()
        let dispatchGroup = DispatchGroup()
        placeList.places.forEach {placeIDWithTimestamp in
            dispatchGroup.enter()
            getPlace(placeID: placeIDWithTimestamp.placeId) { (place: GMSPlace?, error: Error?) in
                if let error = error {
                    print("An error occurred : \(error.localizedDescription)")
                    // ToDo maybe also leave dispatch group here
                    return
                }
                if let place = place {
                    self.exploreList?.places.append(ExplorePlace(place: place))
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.updateDistancesInPlaces()
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
            if let index = self.exploreList!.places.firstIndex(where: {$0.place == place.place}) {
                self.exploreList!.places.remove(at: index)
            }
        }
    }
    
    func quitExplore() {
        self.exploreList = nil
    }
    
    
    func changeCurrentTargetTo(_ place: ExplorePlace) {
        self.exploreList?.currentTarget = place
    }
    
    func markPlaceAsVisited(place: ExplorePlace) {
        if self.exploreList != nil {
            self.exploreList!.currentTarget = nil
            if let index = self.exploreList!.places.firstIndex(where: {$0.place == place.place}) {
                self.exploreList!.places[index].visited = true
                print("marked \(self.exploreList!.places[index].place.name!) as true")
            }
            self.updateDistancesInPlaces()
        }
    }
    
    func markPlaceAsUnVisited(place: ExplorePlace) {
        if self.exploreList != nil {
            if let index = self.exploreList!.places.firstIndex(where: {$0.place == place.place}) {
                self.exploreList!.places[index].visited = false
            }
            self.updateDistancesInPlaces()
            print("111")
        }
    }
    
    func updateDistancesInPlaces() {
        print("222")
        // if explore active and we already have a location
        if let exploreList = self.exploreList, let location = self.locationManager.location {
            // 1. calculate distance to my location for all places
            let explorePlaces: [ExplorePlace] = self.exploreList!.places.map { place in
                let distance = calculateDistance(coordinate: place.place.coordinate,
                                                 location: location)
                return ExplorePlace(place: place.place,
                                    distance: distance,
                                    visited: place.visited
                )
            }
                // 2. sort places based on distance
                .sorted{(place1, place2) in place1.distance! < place2.distance!}
            self.exploreList!.places = explorePlaces
            // If no currentTarget set by user yet set current target (which is the next nearst not visited place)
            if (exploreList.currentTarget == nil && !explorePlaces.filter{!$0.visited}.isEmpty) {
                print("Place to set: \(explorePlaces.filter{!$0.visited}[0].place.name!),  \(explorePlaces.filter{!$0.visited}[0].visited)")
                self.exploreList?.currentTarget = explorePlaces.filter{!$0.visited}[0]
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
    var visited: Bool = false
}

func getUrlForGoogleMapsNavigation(place: GMSPlace) -> URL {
    return URL(string: "https://www.google.com/maps/search/?api=1&query=\(place.coordinate.latitude),\(place.coordinate.longitude)&query_place_id=\(place.placeID!)")!
}
