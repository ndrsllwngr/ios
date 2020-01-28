import Foundation
import GooglePlaces

struct ExploreList: Equatable {
    var places: [ExplorePlace] = []
    var currentTarget: ExplorePlace? = nil
    var lastOpenedAt: Date = Date.init()
}

struct ExplorePlace: Equatable, Hashable {
    var id: String = UUID().uuidString
    var place: GMSPlace
    var image: UIImage? = nil
    var distance: CLLocationDistance? = nil
    var visited: Bool = false
    var visited_at: Date? = nil
    var added_at: Date = Date.init()
    var isNewPlace: Bool = true
}

class ExploreModel: ObservableObject {
    
    static let shared = ExploreModel()
        
    @Published var exploreList: ExploreList? = nil
    @Published var isLoadingPlaces = false
    var locationManager = LocationManager()
    
    private init(){}
    
    func startExploreWithEmptyList() {
        self.exploreList = ExploreList(places: [])
        self.locationManager.startUpdatingLocation()
    }
    
    func startExploreWithPlaceList(placeList: PlaceList, places: [GMSPlace]) {
        // Explore already active: Append places
        if (self.exploreList != nil) {
            exploreList?.places.append(contentsOf: places.map{return ExplorePlace(place: $0)})
            self.updateDistancesInPlaces()
            self.loadPlaceImages()
            // Explore not active yet. Create new ExploreList
        } else {
            self.locationManager.startUpdatingLocation()
            self.locationManager.beginNotifyingExplore()
            // Create list before adding places to make sure they get marked as isNew
            self.exploreList = ExploreList()
            if (!places.isEmpty) {
                self.exploreList?.places = places.map{return ExplorePlace(place: $0)}
            }
        }
    }
    
    func startExploreWithPlaceListAndFetchPlaces(placeList: PlaceList) {
        self.locationManager.startUpdatingLocation()
        self.locationManager.beginNotifyingExplore()
        self.exploreList = ExploreList()
        self.isLoadingPlaces = true
        let dispatchGroup = DispatchGroup()
        placeList.places.forEach {placeIDWithTimestamp in
            dispatchGroup.enter()
            getPlaceSimple(placeID: placeIDWithTimestamp.placeId) { (place: GMSPlace?, error: Error?) in
                if let error = error {
                    print("An error occurred : \(error.localizedDescription)")
                    dispatchGroup.leave()
                    return
                }
                if let place = place {
                    self.exploreList?.places.append(ExplorePlace(place: place))
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // 1. updateDistancesInPlacesAndSetCurrentTarget
            self.updateDistancesInPlaces()
            // 2. loadPlaceImages
            self.loadPlaceImages()
            self.updateLastOpenedAt()
            self.isLoadingPlaces = false
        }
    }
    
    func addPlaceToExplore(_ place: GMSPlace) {
        if (self.exploreList == nil) {
            // Create list before adding place to make sure it gets marked as isNew
            self.exploreList = ExploreList()
            self.locationManager.startUpdatingLocation()
        }
        self.exploreList?.places.append(ExplorePlace(place: place))
        self.updateDistancesInPlaces()
        self.loadPlaceImages()
    }
    
    func removePlaceFromExplore(_ place: ExplorePlace) {
        if let exploreList = self.exploreList {
            if let index = exploreList.places.firstIndex(where: {$0.id == place.id}) {
                self.exploreList!.places.remove(at: index)
            }
            if (place.id == exploreList.currentTarget?.id) {
                self.exploreList?.currentTarget = nil
                updateDistancesInPlaces()
            }
        }
    }
    
    func quitExplore() {
        self.locationManager.stopUpdatingLocation()
        self.exploreList?.places = []
        self.exploreList = nil
    }
    
    
    func changeCurrentTargetTo(_ place: ExplorePlace) {
        self.exploreList?.currentTarget = place
    }
    
    func markPlaceAsVisited(_ place: ExplorePlace) {
        if self.exploreList != nil {
            self.exploreList!.currentTarget = nil
            if let index = self.exploreList!.places.firstIndex(where: {$0.id == place.id}) {
                self.exploreList!.places[index].visited = true
                self.exploreList!.places[index].visited_at = Date.init()
                // Remove isNew badge on action
                self.exploreList!.places[index].isNewPlace = false
            }
            self.updateDistancesInPlaces()
        }
    }
    
    func markPlaceAsUnvisited(_ place: ExplorePlace) {
        if self.exploreList != nil {
            if let index = self.exploreList!.places.firstIndex(where: {$0.id == place.id}) {
                self.exploreList!.places[index].visited = false
                self.exploreList!.places[index].visited_at = nil
            }
            self.updateDistancesInPlaces()
        }
    }
    
    func updateDistancesInPlaces() {
        // if explore active and we already have a location
        if let exploreList = self.exploreList, let location =
            self.locationManager.location {
            print("Begin updating distances in explore places")
            // 1. Calculate and set distance to my location for all places
            self.exploreList!.places = self.exploreList!.places.map { place in
                var mutablePlace = place
                let distance = calculateDistance(coordinate: place.place.coordinate,
                                                 location: location)
                mutablePlace.distance = distance
                return mutablePlace
            }
            // 2. Update distance in current target
            if (exploreList.currentTarget != nil) {
                self.exploreList?.currentTarget!.distance = calculateDistance(coordinate: self.exploreList!.currentTarget!.place.coordinate,
                                                                              location: location)
            }
        }
    }
    
    func loadPlaceImages() {
        if let exploreList = self.exploreList {
            exploreList.places.forEach { place in
                if place.image == nil {
                    if let photos = place.place.photos {
                        getPlaceFoto(photoMetadata: photos[0]) { (photo: UIImage?, error: Error?) in
                            if let error = error {
                                print("Error loading photo metadata: \(error.localizedDescription)")
                                return
                            }
                            if let photo = photo {
                                if let index = exploreList.places.firstIndex(where: {$0.id == place.id}) {
                                    self.exploreList?.places[index].image = photo
                                }
                            }
                        }
                    }
                }
            }
            if (exploreList.currentTarget != nil && exploreList.currentTarget!.image == nil) {
                if let photos = exploreList.currentTarget!.place.photos {
                    getPlaceFoto(photoMetadata: photos[0]) { (photo: UIImage?, error: Error?) in
                        if let error = error {
                            print("Error loading photo metadata: \(error.localizedDescription)")
                            return
                        }
                        if let photo = photo {
                            self.exploreList?.currentTarget?.image = photo
                        }
                    }
                }
            }
        }
    }
    
    func updateLastOpenedAt() {
        if let exploreList = self.exploreList {
            for (index, place) in exploreList.places.enumerated() {
                if (place.added_at > exploreList.lastOpenedAt) {
                    self.exploreList!.places[index].isNewPlace = true
                } else {
                    self.exploreList!.places[index].isNewPlace = false
                }
                
            }
            self.exploreList!.lastOpenedAt = Date.init()
        }
    }
    
    func locationManagerBeginNotifyingExplore() {
        if self.exploreList != nil {
            self.locationManager.beginNotifyingExplore()
        }
    }
    
    func locationManagerStopNotifyingExplore() {
        if self.exploreList != nil {
            self.locationManager.stopNotifyingExplore()
        }
    }
    
}

func calculateDistance(coordinate: CLLocationCoordinate2D, location: CLLocation) -> CLLocationDistance {
    return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distance(from: location)
}

func getDistanceStringToDisplay(_ distance: CLLocationDistance) -> String {
    // Round distance (which is in m) to zero decimals
    let roundedDistance = (distance * 1).rounded(.toNearestOrEven) / 1
    // If distance bigger than 1 km write as km and round two 1 decimal
    if (roundedDistance > 1000) {
        return String(format: "%.1f", (roundedDistance/1000 * 10).rounded(.toNearestOrEven) / 10) + " km"
    } else {
        return String(format: "%.0f", roundedDistance) + " m"
    }
}

func getVisitedAtStringToDisplay(_ visited_at: Date) -> String {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    if (calendar.isDateInToday(visited_at)) {
        dateFormatter.dateFormat = "HH:mm"
        return "today at \(dateFormatter.string(from: visited_at))"
    } else {
        dateFormatter.dateFormat = "E, d MMM"
        return "at \(dateFormatter.string(from: visited_at))"
    }
}

func getUrlForGoogleMapsNavigation(place: GMSPlace) -> URL {
    return URL(string: "https://www.google.com/maps/search/?api=1&query=\(place.coordinate.latitude),\(place.coordinate.longitude)&query_place_id=\(place.placeID!)")!
}
