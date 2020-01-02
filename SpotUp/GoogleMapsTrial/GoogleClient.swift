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
    @Published var address:String?
    @Published var types:[String]?
    @Published var image:UIImage?
    @Published var website:URL?
    @Published var openingHours:[String]?
    @Published var phoneNumber:String?
    @Published var priceLevel:GMSPlacesPriceLevel?
    @Published var isOpen:GMSPlaceOpenStatus?
    @Published var coordinates:CLLocationCoordinate2D?
    @Published var placesArray:[GooglePlaceTest] = []

  
    

    
//    func getPlaceID (completion:@escaping ([PlacesID]?) -> ()){
//        guard let url = URL(string:"https://maps.googleapis.com/maps/api/place/findplacefromtext/json?key=***REMOVED***&input=Kistenpfennig&inputtype=textquery") else{
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
    
    func getPlaceDetails2 (testArray:[String]) {
        let a = GooglePlaceTest()
        
        let fields : GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.photos.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue)
            | UInt(GMSPlaceField.website.rawValue) | UInt(GMSPlaceField.openingHours.rawValue) | UInt(GMSPlaceField.priceLevel.rawValue)
            | UInt(GMSPlaceField.phoneNumber.rawValue)
            )!
        
        for test in testArray{
            placesClient.fetchPlace(fromPlaceID: test, placeFields: fields, sessionToken: nil, callback: {
                    (place: GMSPlace?, error: Error?) in
                    if let error = error {
                        print("An error occurred: \(error.localizedDescription)")
                        return
                    }
                    if let place = place {
                        print(a)
                        a.placeid = place.name
                        a.address = place.formattedAddress
                        a.website = place.website
                        a.phoneNumber = place.phoneNumber
                        a.openingHours = place.openingHours?.weekdayText
                        a.priceLevel = place.priceLevel
                        a.isOpen = place.isOpen()
                        a.types = place.types
                        a.metadata = place.photos![0]
//                        placesClient.loadPlacePhoto(photoMetaData, callback: { (photo, error) -> Void in
//                            if let error = error {
//                                // TODO: Handle the error.
//                                print("Error loading photo metadata: \(error.localizedDescription)")
//                                return
//                            } else {
//                                // Display the first image and its attributions.
//                                self.a.image = photo;
//                            }
//                        })
                        self.placesArray.append(a)
                        print("placesArray in for loop:",a.placeid)
                        
//                        switch self.isOpen{
//                        case.closed:
//                            print("It's closed")
//                        case.open:
//                            print ("It's open")
//                        case.unknown:
//                            print ("Unknown")
//                        case .none:
//                            print ("none")
//                        case .some(_):
//                            print ("some")
//                        }
//
//                        print("The selected place is: \(String(describing: place.name))")
//                        print("The Type is: \(String(describing: self.types))" )
//                        print("Opening Hours: \(String(describing: self.openingHours))")
//                        print("Opening Hours: \(String(describing: self.priceLevel))")

                        
                        
                    }
                    else {
                        print ("didn't jump in any ifs")
                }
                
                
                
            })
        }
        print ("after for loop:" , placesArray)
        
    }

    
    func getPlaceDetails(){
        let placesClient = GMSPlacesClient.shared()
        
        let fields : GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.photos.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue)
            | UInt(GMSPlaceField.website.rawValue) | UInt(GMSPlaceField.openingHours.rawValue) | UInt(GMSPlaceField.priceLevel.rawValue)
            | UInt(GMSPlaceField.phoneNumber.rawValue)
            )!
            placesClient.fetchPlace(fromPlaceID: "ChIJW0DSe-l1nkcRrRdURwBJGmU", placeFields: fields, sessionToken: nil, callback: {
                    (place: GMSPlace?, error: Error?) in
                    if let error = error {
                        print("An error occurred: \(error.localizedDescription)")
                        return
                    }
                    if let place = place {
                        self.placeid = place.name
                        self.address = place.formattedAddress
                        self.website = place.website
                        self.phoneNumber = place.phoneNumber
                        self.openingHours = place.openingHours?.weekdayText
                        self.priceLevel = place.priceLevel
                        self.isOpen = place.isOpen()
                        self.types = place.types
                        let photoMetaData:GMSPlacePhotoMetadata = place.photos![0]
                        placesClient.loadPlacePhoto(photoMetaData, callback: { (photo, error) -> Void in
                            if let error = error {
                                // TODO: Handle the error.
                                print("Error loading photo metadata: \(error.localizedDescription)")
                                return
                            } else {
                                // Display the first image and its attributions.
                                self.image = photo;
                            }
                        })

//                        switch self.isOpen{
//                        case.closed:
//                            print("It's closed")
//                        case.open:
//                            print ("It's open")
//                        case.unknown:
//                            print ("Unknown")
//                        case .none:
//                            print ("none")
//                        case .some(_):
//                            print ("some")
//                        }
//
//                        print("The selected place is: \(String(describing: place.name))")
//                        print("The Type is: \(String(describing: self.types))" )
//                        print("Opening Hours: \(String(describing: self.openingHours))")
//                        print("Opening Hours: \(String(describing: self.priceLevel))")

                        
                    }
                })
            }
}
