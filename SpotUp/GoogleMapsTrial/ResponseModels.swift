////
////  ResponseModels.swift
////  SpotUp
////
////  Created by Havy Ha on 20.12.19.
////
//
//import SwiftUI
import Foundation
import GoogleMaps
import GooglePlaces
//
//
//
//struct GooglePlacesResponse : Codable {
//    let results : [Places]
//    enum CodingKeys : String, CodingKey {
//        case results = "results"
//    }
//}
//
//
//
//// Place struct
struct PlacesID: Codable {
//
//    let geometry : Location
// let name : String
    let place_id: String
//    let openingHours : OpenNow?
//    let photos : [PhotoInfo]?
//    let types : [String]
//    let address : String


//    enum CodingKeys : String, CodingKey {
//        case geometry = "geometry"
//        case name = "name"
//        case place_id = "place_id"
//        case openingHours = "opening_hours"
//        case photos = "photos"
//        case types = "types"
//        case address = "vicinity"
    }
//
//
//    // Location struct
//    struct Location : Codable {
//
//        let location : LatLong
//
//        enum CodingKeys : String, CodingKey {
//            case location = "location"
//        }
//
//
//        // LatLong struct
//        struct LatLong : Codable {
//
//            let latitude : Double
//            let longitude : Double
//
//            enum CodingKeys : String, CodingKey {
//                case latitude = "lat"
//                case longitude = "lng"
//            }
//        }
//
//    }
//
//
//    // OpenNow struct
//    struct OpenNow : Codable {
//
//        let isOpen : Bool
//
//        enum CodingKeys : String, CodingKey {
//            case isOpen = "open_now"
//        }
//    }
//
//
//    // PhotoInfo struct
//    struct PhotoInfo : Codable {
//
//        let height : Int
//        let width : Int
//        let photoReference : String
//
//        enum CodingKeys : String, CodingKey {
//            case height = "height"
//            case width = "width"
//            case photoReference = "photo_reference"
//        }
//    }
//
//
//
//}
//
//
//
//struct GooglePlacesDetailsResponse : Codable {
//    let result : PlaceDetails
//    enum CodingKeysDetails : String, CodingKey {
//        case result = "result"
//    }
//}
//
//
//
//// PlaceDetails struct
//// I have fields commented out because I wanted to just get a location's rating for testing before implementing the rest
//struct PlaceDetails : Codable {
//
//    let place_id: String
////    let geometry : Location
//    let name : String
//    let rating : CGFloat?
////    let price_level : Int
////    let types : [String]
////    let openingHours : OpenNow?
////    let formatted_address : String
////    let formatted_phone_number : String
////    let website : String
////    let reviews : String
////    let photos : [PhotoInfo]?
//
//
//    enum CodingKeysDetails : String, CodingKey {
//        case place_id = "place_id"
////        case geometry = "geometry"
//        case name = "name"
//        case rating = "rating"
////        case price_level = "price_level"
////        case types = "types"
////        case openingHours = "opening_hours"
////        case formatted_address = "formatted_address"
////        case formatted_phone_number = "formatted_phone_number"
////        case website = "website"
////        case reviews = "reviews"
////        case photos = "photos"
//    }
//
//
//
//}
//
