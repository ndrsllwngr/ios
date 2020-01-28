import Foundation
import FirebaseFirestore
import GooglePlaces

struct PlaceIDWithTimestamp: Equatable {
    var placeId: String
    var addedAt: Timestamp
}

struct GMSPlaceWithTimestamp: Equatable, Hashable {
    var gmsPlace: GMSPlace
    var addedAt: Timestamp
    
    func toPlaceIdWithTimeStamp() -> PlaceIDWithTimestamp {
        return PlaceIDWithTimestamp(placeId: self.gmsPlace.placeID!, addedAt: self.addedAt)
    }
}

