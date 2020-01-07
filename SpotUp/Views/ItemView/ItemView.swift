//
//  ItemView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 07.01.20.
//

import SwiftUI
import GooglePlaces

struct ItemView: View {
    var id: String?
    @State var place: GMSPlace?
    
    @ObservedObject var placesConnection = GooglePlacesConnection()
    
    
    var body: some View {
        VStack {
            if (place == nil) {
                Text("")
            } else {
                InnerItemView(place: place!)
            }
        }.onAppear {
            if let id = self.id {
                self.placesConnection.getPlace(placeID: id) {
                    (place: GMSPlace?, error: Error?) in
                    if let error = error {
                        print("An error occurred: \(error.localizedDescription)")
                        return
                    }
                    if let place = place {
                        self.place = place
                        print("The selected place is: \(String(describing: place.name))")
                    }
                }
            }
        }
    }
}

struct InnerItemView: View {
    var place: GMSPlace
    var body: some View {
        VStack {
            VStack {
                //                Image(uiImage: place.photos != nil ? place.photos![0] : UIImage())
                //                    .resizable()
                //                    .clipShape(Circle())
                //                    .overlay(
                //                        Circle().stroke(Color.white, lineWidth: 4))
                //                    .shadow(radius: 10)
                //                    .frame(width:200,height:200)
                
                Text(place.placeID != nil ? "\(place.placeID!)" : "")
                Text(place.formattedAddress != nil ? "\(place.formattedAddress!)" : "")
                Text(place.phoneNumber != nil ? "\(place.phoneNumber!)" : "no phone number")
                
                Button(action: {
                    if self.place.website != nil {
                        UIApplication.shared.open(self.place.website!)
                    }
                }){Text("Open Website")}
            }.padding(.all)
            Spacer()
        }
    }
}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
