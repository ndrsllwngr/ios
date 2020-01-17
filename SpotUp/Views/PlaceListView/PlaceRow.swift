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
    
    var body: some View {
        GeometryReader { metrics in
            HStack(alignment: .center) {
                HStack {
                    PlaceRowImage(image: self.image != nil ? self.image! : UIImage())
                    Text(self.gmsPlaceWithTimestamp.gmsPlace.name != nil ? self.gmsPlaceWithTimestamp.gmsPlace.name! : "")
                    Spacer()
                }
                    .frame(width: metrics.size.width * 0.7)
                    .onTapGesture {
                        self.placeIdToNavigateTo = self.gmsPlaceWithTimestamp.gmsPlace.placeID!
                        self.goToPlace = 1
                }
                HStack {
                    Spacer()
                    Image(systemName: "ellipsis")
                }
                    .frame(width: metrics.size.width * 0.3)
                    .onTapGesture {
                        self.showSheet.toggle()
                        self.sheetSelection = "place_menu"
                        self.placeForPlaceMenuSheet = self.gmsPlaceWithTimestamp
                        self.imageForPlaceMenuSheet = self.image
                }
            }
        }
        .frame(height: 90)
        .onAppear {
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
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .renderingMode(.original)
            .resizable()
            .clipShape(Rectangle())
            .scaledToFill()
            .frame(width: 50, height: 50)
            .cornerRadius(15)
    }
}
