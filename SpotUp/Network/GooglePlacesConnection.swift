//
//  GoogleClient.swift
//  SpotUp
//
//  Created by Havy Ha on 20.12.19.
//

import Foundation
import GooglePlaces

let placesClient = GMSPlacesClient.shared()

class GooglePlacesConnection: ObservableObject{
    
    @Published var places: [GMSPlace] = []
    
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
    
    func getPlaces (placeIds: [String]) {
        
        placeIds.forEach {placeId in
            
            print(placeId)
            
            
            placesClient.fetchPlace(fromPlaceID: placeId, placeFields: fields, sessionToken: nil, callback: {
                (place: GMSPlace?, error: Error?) in
                if let error = error {
                    print("An error occurred: \(error.localizedDescription)")
                    return
                }
                if let place = place {
                    self.places.append(place)
                    print("The selected place is: \(String(describing: place.name))")
                }
            })        
        }
        
    }
    
    func getPlace (placeID: String, handler: @escaping GMSPlaceResultCallback) {
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: handler)
    }
    
    //    func getPlaceID (completion:@escaping ([PlacesID]?) -> ()){
    //        guard let url = URL(string:"https://maps.googleapis.com/maps/api/place/findplacefromtext/json?key=AIzaSyBJgMwNKkk8i8Ue5TmmLHDrwoNyO5iYMMQ&input=Kistenpfennig&inputtype=textquery") else{
    //            fatalError("Invalid URL")
    //        }
    //
    //        URLSession.shared.dataTask(with: url){ data, response, error in
    //            guard let data = data, error == nil else {
    //                DispatchQueue.main.async {
    //                    completion(nil)
    //                    //Completion Handler=
    //                }
    //                return
    //            }
    //
    //            let placeID = try? JSONDecoder().decode(PlacesID.self, from:data)
    //            self.placeid=placeID?.place_id
    //
    //            //sending to ui
    //
    //        }.resume()
    //    }
    
}
