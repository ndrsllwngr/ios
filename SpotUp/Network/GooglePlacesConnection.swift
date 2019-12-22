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
    
    @Published var places: [LocalPlace] = []
    
    
    func getPlaces (placeIds: [String]) {
        
        placeIds.forEach {placeId in
            
            print(placeId)
            let fields : GMSPlaceField = GMSPlaceField(rawValue:
                UInt(GMSPlaceField.name.rawValue) |
                    UInt(GMSPlaceField.placeID.rawValue) |
                    UInt(GMSPlaceField.coordinate.rawValue)
                )!
            
            placesClient.fetchPlace(fromPlaceID: placeId, placeFields: fields, sessionToken: nil, callback: {
                (place: GMSPlace?, error: Error?) in
                if let error = error {
                    print("An error occurred: \(error.localizedDescription)")
                    return
                }
                if let place = place {
                    let localPlace = LocalPlace(id: place.placeID!, name: place.name!, coordinates: place.coordinate)
                    
                    self.places.append(localPlace)
                    print("The selected place is: \(String(describing: place.name))")
                }
            })        
        }
        
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
