import Foundation
import GooglePlaces

class ExploreModel: ObservableObject {
    
    static let shared = ExploreModel()

    @Published var exploreList: ExploreList? = nil
    
    private init(){}
    
    func startExploreWithEmptyList() {
        self.exploreList = ExploreList(places: [])
    }
    
    func startExploreWithPlaceList(placeList: PlaceList, places: [GMSPlace]) {
        if (places.isEmpty) {
            self.exploreList = ExploreList(places: places)
        } else {
            let placesSortedByDistance = sortPlacesByDistanceToCurrentLocation(places)
            self.exploreList = ExploreList(places: placesSortedByDistance, currentTarget: places[0])
        }
    }
    
    func addPlaceToExplore(_ place: GMSPlace) {
        if self.exploreList != nil {
            self.exploreList?.places.append(place)
            if (self.exploreList!.places.count == 1) {
                self.exploreList?.currentTarget = place
            }
        } else {
            self.exploreList = ExploreList(places: [place])
        }
    }
    
    func removePlaceFromExplore(_ place: GMSPlace) {
        if self.exploreList != nil {
            self.exploreList!.places = self.exploreList!.places.filter{$0 != place}
        }
    }
    
    func quitExplore() {
        self.exploreList = nil
    }
    
    
    
    func changeCurrentTargetTo(_ place: GMSPlace) {
        self.exploreList?.currentTarget = place
    }

    
}

func sortPlacesByDistanceToCurrentLocation(_ places: [GMSPlace]) -> [GMSPlace] {
    // ToDo implement
    return places
}

struct ExploreList: Equatable {
    var places: [GMSPlace]
    var currentTarget: GMSPlace? = nil
}
