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
    
    @ObservedObject private var googleConnection = GoogleClient()

    
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
                
                Text("Test")
                
        
                
            }.padding(.all)
            Spacer()
            
           
            
            
        }.onAppear{ self.googleConnection.getPlaceDetails()}
        
        
    }
    
}

//struct GoogleMapsTest_Previews: PreviewProvider {
//    static var previews: some View {
//        GoogleMapsTest()
//
//    }
//}

