//
//  GoogleClient.swift
//  SpotUp
//
//  Created by Havy Ha on 20.12.19.
//

import Foundation
import GooglePlaces

class GoogleClient:ObservableObject{
    
    @Published var placeid:String?
    
        
    func getPlaceID (completion:@escaping ([PlacesID]?) -> ()){
        guard let url = URL(string:"https://maps.googleapis.com/maps/api/place/findplacefromtext/json?key=***REMOVED***&input=Kistenpfennig&inputtype=textquery") else{
            fatalError("Invalid URL")
        }
        
        URLSession.shared.dataTask(with: url){ data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                    //Completion Handler=
                }
                return
            }
            
            let placeID = try? JSONDecoder().decode(PlacesID.self, from:data)
            self.placeid=placeID?.place_id
            
            //sending to ui
            
        }.resume()
    }
    
    func getPlaceDetails (){
    let placesClient = GMSPlacesClient.shared()
    let fields : GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
        UInt(GMSPlaceField.placeID.rawValue))!
        
    placesClient.fetchPlace(fromPlaceID: "ChIJV4k8_9UodTERU5KXbkYpSYs", placeFields: fields, sessionToken: nil, callback: {
            (place: GMSPlace?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            if let place = place {
                self.placeid = place.name
                print("The selected place is: \(String(describing: place.name))")
            }
        })
    }
}
