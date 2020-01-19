import Foundation
import GooglePlaces

struct ExploreList: Equatable {
    var places: [ExplorePlace] = []
    var currentTarget: ExplorePlace? = nil
    var lastOpenedAt: Date? = nil
}

struct ExplorePlace: Equatable, Hashable {
    var place: GMSPlace
    var image: UIImage? = nil
    var distance: CLLocationDistance? = nil
    var visited: Bool = false
    var visited_at: Date? = nil
    var added_at: Date = Date.init()
}

class ExploreModel: ObservableObject {
    
    static let shared = ExploreModel()
    
    @Published var locationManager = LocationManager()
    @Published var exploreList: ExploreList? = nil
    
    private init(){}
    
    func startExploreWithEmptyList() {
        self.exploreList = ExploreList(places: [])
    }
    
    func startExploreWithPlaceList(placeList: PlaceList, places: [GMSPlace]) {
        // Explore already active: Append places
        if (self.exploreList != nil) {
            exploreList?.places.append(contentsOf: places.map{return ExplorePlace(place: $0)})
            // Explore not active yet. Create new ExploreList
        } else {
            if (places.isEmpty) {
                self.exploreList = ExploreList()
            } else {
                let explorePlaces =  places.map{return ExplorePlace(place: $0)}
                self.exploreList = ExploreList(places: explorePlaces)
            }
        }
        self.updateDistancesInPlaces()
        self.loadPlaceImages()
    }
    
    func startExploreWithPlaceListAndFetchPlaces(placeList: PlaceList) {
        self.exploreList = ExploreList()
        let dispatchGroup = DispatchGroup()
        placeList.places.forEach {placeIDWithTimestamp in
            dispatchGroup.enter()
            getPlace(placeID: placeIDWithTimestamp.placeId) { (place: GMSPlace?, error: Error?) in
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
            self.updateDistancesInPlaces()
            self.loadPlaceImages()
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
                self.exploreList!.places[index].visited_at = Date.init()
            }
            self.updateDistancesInPlaces()
        }
    }
    
    func markPlaceAsUnvisited(place: ExplorePlace) {
        if self.exploreList != nil {
            if let index = self.exploreList!.places.firstIndex(where: {$0.place == place.place}) {
                self.exploreList!.places[index].visited = false
                self.exploreList!.places[index].visited_at = nil
            }
            self.updateDistancesInPlaces()
        }
    }
    
    func updateDistancesInPlaces() {
        print("Begin updating distances in explore places")
        // if explore active and we already have a location
        if let exploreList = self.exploreList, let location = self.locationManager.location {
            // 1. calculate distance to my location for all places
            let explorePlaces: [ExplorePlace] = self.exploreList!.places.map { place in
                var mutablePlace = place
                let distance = calculateDistance(coordinate: place.place.coordinate,
                                                 location: location)
                mutablePlace.distance = distance
                return mutablePlace
            }
                // 2. sort places based on distance
                .sorted{(place1, place2) in place1.distance! < place2.distance!}
            self.exploreList!.places = explorePlaces
            // If no currentTarget set by user yet set current target (which is the next nearst not visited place)
            if (exploreList.currentTarget == nil && !explorePlaces.filter{!$0.visited}.isEmpty) {
                self.exploreList?.currentTarget = explorePlaces.filter{!$0.visited}[0]
                // Else also update distance currentTarget
            } else if (exploreList.currentTarget != nil) {
                // also update currentTarget
                self.exploreList?.currentTarget!.distance = calculateDistance(coordinate: self.exploreList!.currentTarget!.place.coordinate,
                                                                              location: location)
            }
        }
    }
    
    func loadPlaceImages() {
        if let exploreList = self.exploreList {
            for (i, place) in exploreList.places.enumerated() {
                if let photos = place.place.photos {
                    getPlaceFoto(photoMetadata: photos[0]) { (photo: UIImage?, error: Error?) in
                        if let error = error {
                            print("Error loading photo metadata: \(error.localizedDescription)")
                            return
                        }
                        if let photo = photo {
                            if self.exploreList?.places[i] != nil {
                                self.exploreList?.places[i].image = photo
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
        if self.exploreList != nil {
            self.exploreList!.lastOpenedAt = Date.init()
        }
    }
    
    func calculateIsNewPlace(explorePlace: ExplorePlace) -> Bool {
        if let exploreList = self.exploreList {
            if let lastOpenedAt = exploreList.lastOpenedAt {
                return lastOpenedAt < explorePlace.added_at
            } else {
                return true
            }
        } else {
            return false
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

func makeUiImageBlackAndWhite(_ image: UIImage) -> UIImage {
    // Slows down app by a lot. ToDo evauate if we 
//    guard let currentCGImage = image.cgImage else { return image}
//    let currentCIImage = CIImage(cgImage: currentCGImage)
//
//    let filter = CIFilter(name: "CIColorMonochrome")
//    filter?.setValue(currentCIImage, forKey: "inputImage")
//
//    // set a gray value for the tint color
//    filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
//
//    filter?.setValue(1.0, forKey: "inputIntensity")
//    guard let outputImage = filter?.outputImage else { return image }
//
//    let context = CIContext()
//
//    if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
//        let processedImage = UIImage(cgImage: cgimg)
//        return processedImage
//    } else {
//        return image
//    }
    return image
}
