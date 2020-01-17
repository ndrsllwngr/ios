//
//  ListComponent.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import GooglePlaces

struct PlaceRowExplore: View {
    var place: ExplorePlace
    
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String

    @Binding var placeForPlaceMenuSheet: ExplorePlace?
    @Binding var imageForPlaceMenuSheet: UIImage?
    
    @State var image: UIImage? = nil
    
    var body: some View {
        GeometryReader { metrics in
            HStack(alignment: .center) {
                HStack {
                    PlaceRowImage(image: self.image != nil ? self.image! : UIImage())
                    VStack {
                        Text(self.place.place.name != nil ? self.place.place.name! : "")
                        Text(self.place.distance != nil ? "\(getDistanceStringToDisplay(self.place.distance!))" : "distance")
                    }
                    Spacer()
                }
                    .frame(width: metrics.size.width * 0.7)
                    .onTapGesture {
                        self.exploreModel.changeCurrentTargetTo(self.place)
                }
                HStack {
                    Spacer()
                    Image(systemName: "ellipsis")
                }
                    .frame(width: metrics.size.width * 0.3)
                    .onTapGesture {
                        self.showSheet.toggle()
                        self.sheetSelection = "place_menu"
                        self.placeForPlaceMenuSheet = self.place
                        self.imageForPlaceMenuSheet = self.image
                }
            }
        }
        .frame(height: 60)
        .onAppear {
            if let photos = self.place.place.photos {
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

struct PlaceRowExploreImage: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .renderingMode(.original)
            .resizable()
            .frame(width: 50, height: 50)
            .clipShape(Rectangle())
            .scaledToFill()
            .cornerRadius(15)
    }
}
