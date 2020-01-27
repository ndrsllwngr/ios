import Foundation
import GooglePlaces

let placesClient = GMSPlacesClient.shared()

let fields: GMSPlaceField = GMSPlaceField(rawValue:
    UInt(GMSPlaceField.name.rawValue) |
        UInt(GMSPlaceField.placeID.rawValue) |
        UInt(GMSPlaceField.coordinate.rawValue) |
        UInt(GMSPlaceField.photos.rawValue) |
        UInt(GMSPlaceField.formattedAddress.rawValue) |
        UInt(GMSPlaceField.website.rawValue) |
        UInt(GMSPlaceField.openingHours.rawValue) |
        UInt(GMSPlaceField.priceLevel.rawValue) |
        UInt(GMSPlaceField.phoneNumber.rawValue) |
        UInt(GMSPlaceField.rating.rawValue) |
        UInt(GMSPlaceField.types.rawValue) |
        UInt(GMSPlaceField.plusCode.rawValue)
    )!

let fieldsSimple: GMSPlaceField = GMSPlaceField(rawValue:
    UInt(GMSPlaceField.name.rawValue) |
        UInt(GMSPlaceField.placeID.rawValue) |
        UInt(GMSPlaceField.coordinate.rawValue) |
        UInt(GMSPlaceField.formattedAddress.rawValue) |
        UInt(GMSPlaceField.photos.rawValue)
    )!


func getPlace (placeID: String, handler: @escaping GMSPlaceResultCallback) {
    placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: handler)
}

func getPlaceSimple (placeID: String, handler: @escaping GMSPlaceResultCallback) {
    placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fieldsSimple, sessionToken: nil, callback: handler)
}

func getPlaceFoto(photoMetadata: GMSPlacePhotoMetadata, handler: @escaping GMSPlacePhotoImageResultCallback) {
    placesClient.loadPlacePhoto(photoMetadata, callback: handler)
}

func getPlaceIsOpenNow(isOpen:GMSPlaceOpenStatus)->String{
    dump(isOpen)
    var temp:String
    switch isOpen{
    case.closed:
        temp = ("It's closed")
    case.open:
        temp = ("It's open")
    case.unknown:
        temp = ("It's unknown")
    default:
        temp = ("default")
    }
    return temp
}


func getPlacePriceLevel(priceLevel:GMSPlacesPriceLevel)->Int{
    var temp:Int
    switch priceLevel{
    case.free:
        temp = 0
    case.cheap:
        temp = 1
    case.medium:
        temp = 2
    case.high:
        temp = 3
    case.expensive:
        temp = 4
    case.unknown:
        temp = 0
    default:
        temp = 0
    }
    return temp
}
