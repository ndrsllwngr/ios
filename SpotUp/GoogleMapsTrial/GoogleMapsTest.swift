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
            Text(self.googleConnection.placeid != nil ? "\(self.googleConnection.placeid!)" : "")
        }.onAppear{ self.googleConnection.getPlaceDetails()}
        }

}

struct GoogleMapsTest_Previews: PreviewProvider {
    static var previews: some View {
        GoogleMapsTest()
    
    }
}

