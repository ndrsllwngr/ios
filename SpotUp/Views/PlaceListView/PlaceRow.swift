//
//  ListComponent.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import GooglePlaces

struct PlaceRow: View {
    var gmsPlaceWithTimestamp: GMSPlaceWithTimestamp
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    @Binding var placeIdToNavigateTo: String?
    @Binding var goToPlace: Int?
    
    @Binding var placeForPlaceMenuSheet: GMSPlaceWithTimestamp?
    @Binding var imageForPlaceMenuSheet: UIImage?
    
    @State var image: UIImage?
    @State var address: String?
    
    var body: some View {
        GeometryReader { metrics in
            HStack(alignment: .center) {
                HStack {
                    PlaceRowImage(image: self.image != nil ? self.image! : UIImage())
                        .frame(width: 60, height: 60)
                        .cornerRadius(15)
                        .padding(.trailing, 10)
                    
                    VStack(alignment: .leading){
                        Text(self.gmsPlaceWithTimestamp.gmsPlace.name != nil ? self.gmsPlaceWithTimestamp.gmsPlace.name! : "")
                            .font(.system(size: 18))
                            .lineLimit(1)
                        Text(self.address != nil ? self.address! : "")
                            .font(.system(size: 12))
                            .lineLimit(1)
                            //.fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color("text-secondary"))
                    }
                    Spacer()
                }
                    .frame(width: metrics.size.width * 0.85)
                    .onTapGesture {
                        self.placeIdToNavigateTo = self.gmsPlaceWithTimestamp.gmsPlace.placeID!
                        self.goToPlace = 1
                }
                HStack {
                    Spacer()
                    Image(systemName: "ellipsis")
                }
                    .frame(width: metrics.size.width * 0.15)
                    .onTapGesture {
                        self.showSheet.toggle()
                        self.sheetSelection = "place_menu"
                        self.placeForPlaceMenuSheet = self.gmsPlaceWithTimestamp
                        self.imageForPlaceMenuSheet = self.image
                }
            }.frame(height: 60)
        }
        .frame(height: 60)
        .onAppear {
            if let address = self.gmsPlaceWithTimestamp.gmsPlace.formattedAddress {
                self.address = address
            }
            
            if let photos = self.gmsPlaceWithTimestamp.gmsPlace.photos {
                getPlaceFoto(photoMetadata: photos[0]) { (photo: UIImage?, error: Error?) in
                    if let error = error {
                        print("Error loading photo metadata: \(error.localizedDescription)")
                        return
                    }
                    if let photo = photo {
                        self.image = photo
                    }
                }
            }
        }
    }
}

struct PlaceRowImage: View {
    var image: UIImage?
    var body: some View {
        Image(uiImage: image != nil ? image! : UIImage(named: "place_image_placeholder")!)
            .renderingMode(.original)
            .resizable()
            .clipShape(Rectangle())
            .scaledToFill()
            .animation(.easeInOut)
//            .frame(width: 60, height: 60)
//            .cornerRadius(15)
            
    }
}
