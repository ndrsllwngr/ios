//
//  ListComponent.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import GooglePlaces

struct CurrentTargetRow: View {
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @State var showActionSheet: Bool = false
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    @Binding var placeIdToNavigateTo: String?
    @Binding var goToPlace: Int?
    
    @Binding var placeForPlaceMenuSheet: ExplorePlace?
    @Binding var imageForPlaceMenuSheet: UIImage?
    
    var body: some View {
        VStack {
            if (exploreModel.exploreList != nil) {
                if (exploreModel.exploreList!.currentTarget != nil) {
                    GeometryReader { metrics in
                        HStack(alignment: .center) {
                            HStack {
                                PlaceRowImage(image: self.exploreModel.exploreList!.currentTarget!.image)
                                VStack (alignment: .leading) {
                                    Text(self.exploreModel.exploreList!.currentTarget!.place.name != nil ? self.exploreModel.exploreList!.currentTarget!.place.name! : "")
                                    Text(self.exploreModel.exploreList!.currentTarget!.distance != nil ? "\(getDistanceStringToDisplay(self.exploreModel.exploreList!.currentTarget!.distance!))" : "distance")
                                }
                                Spacer()
                            }
                            .frame(width: metrics.size.width * 0.65)
                            .onTapGesture {
                                self.placeIdToNavigateTo = self.exploreModel.exploreList!.currentTarget!.place.placeID!
                                self.goToPlace = 1
                            }
                            HStack {
                                Button(action: {
                                    self.exploreModel.markPlaceAsVisited(self.exploreModel.exploreList!.currentTarget!)
                                }) {
                                    VStack {
                                        Image(systemName: "mappin.and.ellipse")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                        Text("Visit")
                                    }
                                }
                            }.frame(width: metrics.size.width * 0.15)
                            HStack {
                                Button(action: {
                                    UIApplication.shared.open(getUrlForGoogleMapsNavigation(place: self.exploreModel.exploreList!.currentTarget!.place))
                                }) {
                                    VStack {
                                        Image(systemName: "arrow.up.right.diamond")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                        Text("Nav")
                                    }
                                }
                            }.frame(width: metrics.size.width * 0.10)
                            HStack {
                                Image(systemName: "ellipsis")
                            }
                            .frame(width: metrics.size.width * 0.10)
                            .onTapGesture {
                                self.showActionSheet.toggle()
                            }
                            .actionSheet(isPresented: self.$showActionSheet) {
                                ActionSheet(title: Text("\(self.exploreModel.exploreList!.currentTarget!.place.name!)"), buttons: [
                                    .default(Text("Add to collection")) {
                                        self.showSheet.toggle()
                                        self.sheetSelection = "add_to_placelist"
                                        self.placeForPlaceMenuSheet = self.exploreModel.exploreList!.currentTarget!
                                        self.imageForPlaceMenuSheet = self.exploreModel.exploreList!.currentTarget!.image
                                    },
                                    .destructive(Text("Remove from explore")) { ExploreModel.shared.removePlaceFromExplore(self.exploreModel.exploreList!.currentTarget!)
                                    },
                                    .cancel()
                                ])
                            }
                        }
                    }
                } else if (exploreModel.exploreList!.currentTarget == nil && !exploreModel.exploreList!.places.filter{!$0.visited}.isEmpty) {
                    Text("Tap on a place to make it the current target")
                } else {
                    Text("Great! You have visited all places in your travel queue.")
                }
            }
        }
        .frame(height: 60)
    }
}


struct ExplorePlaceRow: View {
    @State var place: ExplorePlace
    @State var showActionSheet: Bool = false
    
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    @Binding var placeIdToNavigateTo: String?
    @Binding var goToPlace: Int?
    
    @Binding var placeForPlaceMenuSheet: ExplorePlace?
    @Binding var imageForPlaceMenuSheet: UIImage?
    
    var body: some View {
        GeometryReader { metrics in
            HStack(alignment: .center) {
                HStack {
                    PlaceRowImage(image: self.place.image)
                    VStack (alignment: .leading) {
                        Text(self.place.place.name != nil ? self.place.place.name! : "")
                        Text(self.place.distance != nil ? "\(getDistanceStringToDisplay(self.place.distance!))" : "loading")
                    }
                    Spacer()
                }
                .frame(width: metrics.size.width * 0.65)
                .onTapGesture {
                    self.placeIdToNavigateTo = self.place.place.placeID!
                    self.goToPlace = 1
                }
                VStack {
                    Image(systemName: "location.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                    Text("Go")
                }
                .frame(width: metrics.size.width * 0.15)
                .onTapGesture {
                    self.exploreModel.changeCurrentTargetTo(self.place)
                }
                HStack {
                    Spacer()
                    if (self.place.isNewPlace) {
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
                    self.showActionSheet.toggle()
                }
                .actionSheet(isPresented: self.$showActionSheet) {
                    ActionSheet(title: Text("\(self.place.place.name!)"), buttons: [
                        .default(Text("Add to collection")) {
                            self.showSheet.toggle()
                            self.sheetSelection = "add_to_placelist"
                            self.placeForPlaceMenuSheet = self.place
                            self.imageForPlaceMenuSheet = self.place.image
                        },
                        .destructive(Text("Remove from explore")) { ExploreModel.shared.removePlaceFromExplore(self.place)
                        },
                        .cancel()
                    ])
                }
            }
        }
        .frame(height: 60)
    }
}


struct ExplorePlaceVisitedRow: View {
    @State var place: ExplorePlace
    
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @Binding var placeIdToNavigateTo: String?
    @Binding var goToPlace: Int?
    
    var body: some View {
        GeometryReader { metrics in
            HStack(alignment: .center) {
                HStack {
                    PlaceRowImage(image: self.place.image)
                        .opacity(0.5)
                    VStack (alignment: .leading){
                        Text(self.place.place.name != nil ? self.place.place.name! : "")
                        Text(self.place.visited_at != nil ? getVisitedAtStringToDisplay(self.place.visited_at!) : "")
                    }
                    Spacer()
                }
                .frame(width: metrics.size.width * 0.8)
                .onTapGesture {
                    self.placeIdToNavigateTo = self.place.place.placeID!
                    self.goToPlace = 1
                }
                VStack {
                    Image(systemName: "mappin.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text("Unvisit")
                }
                .frame(width: metrics.size.width * 0.2)
                .onTapGesture {
                    self.exploreModel.markPlaceAsUnvisited(self.place)
                }
            }.foregroundColor(Color.gray)
        }
        .frame(height: 60)
    }
}
