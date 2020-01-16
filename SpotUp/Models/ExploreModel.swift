import Foundation

class ExploreModel: ObservableObject {
    
    static let shared = ExploreModel()

    @Published var exploreList: ExploreList? = nil
    
    private init(){}
    
    func startWithEmptyExploreList() {
        self.exploreList = ExploreList(places: [])
    }
    
    func startExploringPlaceList(placeList: PlaceList, gmsPlaces: [GMSPlaceWithTimestamp]) {
        if (gmsPlaces.isEmpty) {
            self.exploreList = ExploreList(places: gmsPlaces)
        } else {
            let placesSortedByDistance = sortPlacesByDistanceToCurrentLocation(gmsPlaces)
            self.exploreList = ExploreList(places: gmsPlaces, currentTarget: gmsPlaces[0])
        }
    }
    
    func changeCurrentTargetTo(_ place: GMSPlaceWithTimestamp) {
        self.exploreList?.currentTarget = place
    }

    
}

func sortPlacesByDistanceToCurrentLocation(_ places: [GMSPlaceWithTimestamp]) -> [GMSPlaceWithTimestamp] {
    // ToDo implement
    return places
}

struct ExploreList: Equatable {
    var places: [GMSPlaceWithTimestamp]
    var currentTarget: GMSPlaceWithTimestamp? = nil
}
