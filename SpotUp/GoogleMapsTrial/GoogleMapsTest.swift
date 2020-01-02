//
//  GoogleMapsTest.swift
//  SpotUp
//
//  Created by Havy Ha on 20.12.19.
//

import SwiftUI
import GoogleMaps
import GooglePlaces

struct GoogleMapsTest: View {
    
    @EnvironmentObject var googleConnection: GoogleClient
   var idTestArray = ["ChIJW0DSe-l1nkcRrRdURwBJGmU","ChIJz_Vm4-x1nkcR9eUl33F28dY","ChIJk2XVNXPfnUcRNtjDi6U-rOA","ChIJOwfxTOV1nkcRSZP07RYIkR0"]


    
    var body: some View {
        VStack {
            VStack {
                Image(uiImage: self.googleConnection.image != nil ? self.googleConnection.image! : UIImage())
               .resizable()
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                .frame(width:200,height:200)
                
                
                Text(self.googleConnection.placeid != nil ? "\(self.googleConnection.placeid!)" : "")
                Text(self.googleConnection.address != nil ? "\(self.googleConnection.address!)" : "")
                Text(self.googleConnection.phoneNumber != nil ? "\(self.googleConnection.phoneNumber!)" : "no phone number")
                
                Button(action: {
                    if self.googleConnection.website != nil {
                        UIApplication.shared.open(self.googleConnection.website!)
                    }
                    }){Text("Open Website")}
                
                Text("Test")
                Text(!self.googleConnection.placesArray.isEmpty ?  "\(self.googleConnection.placesArray[0].placeid!)" : "loading")
        
                
            }.padding(.all)
            Spacer()
            
           
            
            
        }.onAppear{ //self.googleConnection.getPlaceDetails()
           self.googleConnection.getPlaceDetails2(testArray: self.idTestArray)
            
        }
        
        
    }
    
}

//struct GoogleMapsTest_Previews: PreviewProvider {
//    static var previews: some View {
//        GoogleMapsTest()
//
//    }
//}

