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
                    VStack (alignment: .leading) {
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


struct PlaceRowExploreVisited: View {
    var place: ExplorePlace
    
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @State var image: UIImage? = nil
    
    var body: some View {
        GeometryReader { metrics in
            HStack(alignment: .center) {
                HStack {
                    PlaceRowImage(image: self.image != nil ? self.image! : UIImage())
                    Text(self.place.place.name != nil ? self.place.place.name! : "")
                    Spacer()
                }
                .frame(width: metrics.size.width * 0.7)
                HStack {
                    Image(systemName: "mappin.slash")
                    Text("Mark unvisited")
                }.onTapGesture {
                    self.exploreModel.markPlaceAsUnVisited(place: self.place)
                }
                .frame(width: metrics.size.width * 0.3)
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

struct CurrentTargetRow: View {
    var place: ExplorePlace
    
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @State var image: UIImage? = nil
    
    var body: some View {
        GeometryReader { metrics in
            HStack(alignment: .center) {
                HStack {
                    PlaceRowImage(image: self.image != nil ? self.image! : UIImage())
                    VStack (alignment: .leading) {
                        Text(self.place.place.name != nil ? self.place.place.name! : "")
                        Text(self.place.distance != nil ? "\(getDistanceStringToDisplay(self.place.distance!))" : "distance")
                    }
                    Spacer()
                }
                .frame(width: metrics.size.width * 0.4)
                .onTapGesture {
                    self.exploreModel.changeCurrentTargetTo(self.place)
                }
                HStack {
                    Button(action: {
                        self.exploreModel.markPlaceAsVisited(place: self.place)
                    }) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            Text("Mark visited")
                        }
                    }
                }.frame(width: metrics.size.width * 0.3)
                HStack {
                    Button(action: {
                        UIApplication.shared.open(getUrlForGoogleMapsNavigation(place: self.place.place))
                    }) {
                        HStack {
                            Image(systemName: "arrow.up.right.diamond")
                            Text("Navigate")
                        }
                    }
                }.frame(width: metrics.size.width * 0.3)
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
