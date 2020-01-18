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
    @State var place: ExplorePlace
    
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    @Binding var placeForPlaceMenuSheet: ExplorePlace?
    @Binding var imageForPlaceMenuSheet: UIImage?
    
    var body: some View {
        GeometryReader { metrics in
            HStack(alignment: .center) {
                HStack {
                    PlaceRowImage(image: self.place.image != nil ? self.place.image! : UIImage())
                    VStack (alignment: .leading) {
                        Text(self.place.place.name != nil ? self.place.place.name! : "")
                        Text(self.place.distance != nil ? "\(getDistanceStringToDisplay(self.place.distance!))" : "distance")
                    }
                    Spacer()
                }
                .frame(width: metrics.size.width * 0.8)
                .onTapGesture {
                    self.exploreModel.changeCurrentTargetTo(self.place)
                }
                HStack {
                    Spacer()
                    if (self.exploreModel.calculateIsNewPlace(explorePlace: self.place)) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.gray)
                            .frame(width: 10, height: 10)
                            .padding(.trailing)
                    }
                    Image(systemName: "ellipsis")
                }
                .frame(width: metrics.size.width * 0.2)
                .onTapGesture {
                    self.showSheet.toggle()
                    self.sheetSelection = "place_menu"
                    self.placeForPlaceMenuSheet = self.place
                    self.imageForPlaceMenuSheet = self.place.image
                }
            }
        }
        .frame(height: 60)
    }
}


struct PlaceRowExploreVisited: View {
    @State var place: ExplorePlace
    
    @ObservedObject var exploreModel = ExploreModel.shared
    
    var body: some View {
        GeometryReader { metrics in
            HStack(alignment: .center) {
                HStack {
                    PlaceRowImage(image: self.place.image != nil ? self.place.image! : UIImage())
                    VStack (alignment: .leading){
                        Text(self.place.place.name != nil ? self.place.place.name! : "")
                        Text(self.place.visited_at != nil ? getVisitedAtStringToDisplay(self.place.visited_at!) : "")
                    }
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
    }
}

struct CurrentTargetRow: View {
    @ObservedObject var exploreModel = ExploreModel.shared
    
    var body: some View {
        VStack {
            if (exploreModel.exploreList != nil && exploreModel.exploreList!.currentTarget != nil) {
                GeometryReader { metrics in
                    HStack(alignment: .center) {
                        HStack {
                            PlaceRowImage(image: self.exploreModel.exploreList!.currentTarget!.image != nil ? self.exploreModel.exploreList!.currentTarget!.image! : UIImage())
                            VStack (alignment: .leading) {
                                Text(self.exploreModel.exploreList!.currentTarget!.place.name != nil ? self.exploreModel.exploreList!.currentTarget!.place.name! : "")
                                Text(self.exploreModel.exploreList!.currentTarget!.distance != nil ? "\(getDistanceStringToDisplay(self.exploreModel.exploreList!.currentTarget!.distance!))" : "distance")
                            }
                            Spacer()
                        }
                        .frame(width: metrics.size.width * 0.4)
                        HStack {
                            Button(action: {
                                self.exploreModel.markPlaceAsVisited(place: self.exploreModel.exploreList!.currentTarget!)
                            }) {
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                    Text("Mark visited")
                                }
                            }
                        }.frame(width: metrics.size.width * 0.3)
                        HStack {
                            Button(action: {
                                UIApplication.shared.open(getUrlForGoogleMapsNavigation(place: self.exploreModel.exploreList!.currentTarget!.place))
                            }) {
                                HStack {
                                    Image(systemName: "arrow.up.right.diamond")
                                    Text("Navigate")
                                }
                            }
                        }.frame(width: metrics.size.width * 0.3)
                    }
                }
            } else {
                Text("Tap on a place to make it the current target")
                
            }
        }
        .frame(height: 60)
    }
}
