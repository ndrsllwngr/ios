//
//  ItemView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 07.01.20.
//

import SwiftUI
import GooglePlaces

struct ItemView: View {
    var placeID: String?
    @State var place: GMSPlace?
    
    var body: some View {
        VStack {
            if (place == nil) {
                Text("")
            } else {
                InnerItemView(place: place!)
            }
        }.onAppear {
            if let placeID = self.placeID {
                getPlace(placeID: placeID) { (place: GMSPlace?, error: Error?) in
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
    @State var image: UIImage?
    @State var showSheet = false
    
    var body: some View {
        VStack {
            ItemMapView(coordinate: place.coordinate)
                .edgesIgnoringSafeArea(.top)
                .frame(height:300)
            
            HStack {
                ItemImageView(image: image != nil ? image! : UIImage())
                    .frame(width: 200,height: 200)
                    .offset(y: -90)
                    .padding(.bottom, -90)
                Button(action: {
                    self.showSheet.toggle()
                }){
                    Text("Add to List")
                }
            }
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading) {
                    Text(place.name != nil ? place.name! : "")
                        .font(.title)
                    Text(place.formattedAddress != nil ? "\(place.formattedAddress!)" : "")
                    Text(place.phoneNumber != nil ? "\(place.phoneNumber!)" : "no phone number")
                    Button(action: {
                        if let website = self.place.website {
                            UIApplication.shared.open(website)
                        }
                    }){
                        Text("Open Website")
                    }
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showSheet) {
            AddPlaceToListSheet(showSheet: self.$showSheet, placeID: self.place.placeID!)
        }
        .navigationBarTitle(Text(place.name != nil ? place.name! : ""), displayMode:.inline)
        .onAppear {
            if let photos = self.place.photos {
                getPlaceFoto(photoMetadata: photos[0]) { (photo: UIImage?, error: Error?) in
                    if let error = error {
                        print("Error loading photo metadata: \(error.localizedDescription)")
                        return
                    }
                    if let photo = photo {
                        self.image = photo;
                    }
                }
            }
        }
    }
}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
