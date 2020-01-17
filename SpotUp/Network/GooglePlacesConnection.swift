import Foundation
import GooglePlaces
import SwiftUI

let placesClient = GMSPlacesClient.shared()

let fields : GMSPlaceField = GMSPlaceField(rawValue:
    UInt(GMSPlaceField.name.rawValue) |
        UInt(GMSPlaceField.placeID.rawValue) |
        UInt(GMSPlaceField.coordinate.rawValue) |
        UInt(GMSPlaceField.photos.rawValue) |
        UInt(GMSPlaceField.formattedAddress.rawValue) |
        UInt(GMSPlaceField.website.rawValue) |
        UInt(GMSPlaceField.openingHours.rawValue) |
        UInt(GMSPlaceField.priceLevel.rawValue) |
    UInt(GMSPlaceField.types.rawValue)
        UInt(GMSPlaceField.rating.rawValue) |
        UInt(GMSPlaceField.plusCode.rawValue)
    )!

func getPlace (placeID: String, handler: @escaping GMSPlaceResultCallback) {
    placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: handler)
}

func getPlaceFoto(photoMetadata: GMSPlacePhotoMetadata, handler: @escaping GMSPlacePhotoImageResultCallback) {
    placesClient.loadPlacePhoto(photoMetadata, callback: handler)
}

func getPlaceIsOpenNow(isOpen:GMSPlaceOpenStatus) -> String{
    var a: String
    switch isOpen {
    case.closed:
          print("It's closed")
        a = ("It's closed")
    case.open:
         print("It's open")
        a = ("It's open")
    case.unknown:
         a = ("It's unknown")
    default:
        a = ("default")
    }
    return a
}

func getPlacePricelevel(priceLevel:GMSPlacesPriceLevel){
    switch priceLevel {
    case.cheap:
          print("It's cheap")
    case.expensive:
         print("It's expensive")
    case.free:
         print("It's free")
    case.high:
        print("It'high")
    case.medium:
        print("It's medium")
    case.unknown:
        print ("It's unknown")
    default:
        print("default")
    }
    
}





