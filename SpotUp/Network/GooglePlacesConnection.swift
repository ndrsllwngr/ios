//
//  GoogleClient.swift
//  SpotUp
//
//  Created by Havy Ha on 20.12.19.
//

import Foundation
import GooglePlaces

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
        UInt(GMSPlaceField.phoneNumber.rawValue)
    )!

func getPlace (placeID: String, handler: @escaping GMSPlaceResultCallback) {
    placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: handler)
}

func getPlaceFoto(photoMetadata: GMSPlacePhotoMetadata, handler: @escaping GMSPlacePhotoImageResultCallback) {
    placesClient.loadPlacePhoto(photoMetadata, callback: handler)
}
