import Foundation

func sortPlaces(places: [GMSPlaceWithTimestamp], sortByCreationDate: Bool) -> [GMSPlaceWithTimestamp] {
    if sortByCreationDate {
        // New Placelists always first!
        return places.sorted{$0.addedAt.dateValue() > $1.addedAt.dateValue()}
    } else {
        return places.sorted{(place1, place2) in
            if let name1 = place1.gmsPlace.name, let name2 = place2.gmsPlace.name {
                return name1 < name2
            } else {
                return false
            }
        }
    }
}

func sortPlaceLists(placeLists: [PlaceList], sortByCreationDate: Bool) -> [PlaceList] {
    if sortByCreationDate {
        // New Placelists always first!
        return placeLists.sorted{$0.createdAt.dateValue() > $1.createdAt.dateValue()}
    } else {
        return placeLists.sorted{$0.name < $1.name}
    }
}

func sortExplorePlaces(places: [ExplorePlace], sortByDistance: Bool) ->  [ExplorePlace]{
    
    if sortByDistance {
        return places.sorted{(place1, place2) in
            if let distance1 = place1.distance, let distance2 = place2.distance {
                // Closer places always first!
                return distance1 < distance2
            } else {
                return false
            }
        }
    } else {
        return places.sorted{(place1, place2) in place1.place.name! < place2.place.name!}
    }
}
