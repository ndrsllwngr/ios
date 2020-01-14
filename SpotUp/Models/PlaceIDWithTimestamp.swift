//
//  PlaceIDwithTimestamp.swift
//  SpotUp
//
//  Created by Havy Ha on 12.01.20.
//

import Foundation
import FirebaseFirestore
import GooglePlaces

struct PlaceIDWithTimestamp {
       var placeId: String
       var addedAt: Timestamp
   }

struct GMSPlaceWithTimestamp{
    var gmsPlace: GMSPlace
    var addedAt: Timestamp
}
