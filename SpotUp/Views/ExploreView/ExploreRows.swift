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
    
    @Binding var placeForAddPlaceToListSheet: ExplorePlace?
    @Binding var imageForAddPlaceToListSheet: UIImage?
    
    var body: some View {
        VStack {
            if (exploreModel.exploreList != nil) {
                if (exploreModel.exploreList!.currentTarget != nil) {
                    HStack(alignment: .center, spacing: 0.0) {
                        HStack {
                            PlaceRowImage(image: self.exploreModel.exploreList!.currentTarget!.image)
                                .clipShape(Rectangle())
                                .frame(width: 50, height: 50)
                                .cornerRadius(15)
                            
                            VStack (alignment: .leading) {
                                Text(self.exploreModel.exploreList!.currentTarget!.place.name != nil ? self.exploreModel.exploreList!.currentTarget!.place.name! : "")
                                    .font(.system(size:18))
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                                
                                Text(self.exploreModel.exploreList!.currentTarget!.distance != nil ? "\(getDistanceStringToDisplay(self.exploreModel.exploreList!.currentTarget!.distance!))" : "Loading distance...")
                                    .font(.system(size: 12))
                                    .lineLimit(1)
                                    .foregroundColor(Color("text-secondary"))
                            }
                            Spacer()
                        }
                        .onTapGesture {
                            self.placeIdToNavigateTo = self.exploreModel.exploreList!.currentTarget!.place.placeID!
                            self.goToPlace = 1
                        }
                        Spacer()
                        HStack {
                            Button(action: {
                                UIApplication.shared.open(getUrlForGoogleMapsNavigation(place: self.exploreModel.exploreList!.currentTarget!.place))
                            }) {
                                VStack {
                                    Image(systemName: "arrow.up.right.diamond.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color(UIColor.systemBlue))
                                }
                                .frame(width: 40)
                            }
                        }
                        .padding([.trailing], 10)
                        VStack {
                            VStack {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundColor(Color.white)
                                    .font(Font.title.weight(.bold))
                            }
                            .frame(width: 40, height: 40)
                            .background(Color.green)
                            .cornerRadius(15)
                            .frame(width: 40)
                        }
                        .frame(width: 40)
                        .onTapGesture {
                            self.exploreModel.markPlaceAsVisited(self.exploreModel.exploreList!.currentTarget!)
                        }
                        HStack {
                            Image(systemName: "ellipsis")
                        }
                        .frame(width: 40)
                        .onTapGesture {
                            self.showActionSheet.toggle()
                        }
                        .actionSheet(isPresented: self.$showActionSheet) {
                            ActionSheet(title: Text("\(self.exploreModel.exploreList!.currentTarget!.place.name!)"), buttons: [
                                .default(Text("Add to collection")) {
                                    self.showSheet.toggle()
                                    self.sheetSelection = "add_to_placelist"
                                    self.placeForAddPlaceToListSheet = self.exploreModel.exploreList!.currentTarget!
                                    self.imageForAddPlaceToListSheet = self.exploreModel.exploreList!.currentTarget!.image
                                },
                                .destructive(Text("Remove from explore")) { ExploreModel.shared.removePlaceFromExplore(self.exploreModel.exploreList!.currentTarget!)
                                },
                                .cancel()
                            ])
                        }
                    }
                    .padding([.leading], 10)
                } else if (exploreModel.exploreList!.currentTarget == nil && !exploreModel.exploreList!.places.filter{!$0.visited}.isEmpty) {
                    HStack(spacing: 0.0) {
                        Image(uiImage: UIImage(named: "explore-empty-target-bw")!)
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50.0, height: 50.0, alignment: .center)
                        Spacer()
                        Text("No target selected")
                            .foregroundColor(Color("text-secondary"))
                        Spacer()
                    }
                    .padding([.horizontal], 10)
                } else {
                    HStack(spacing: 0.0) {
                        Image(uiImage: UIImage(named: "explore-empty-guidebook-bw")!)
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50.0, height: 50.0, alignment: .center)
                        Spacer()
                        Text("All places were visited")
                            .foregroundColor(Color("text-secondary"))
                        Spacer()
                    }
                    .padding([.horizontal], 10)
                }
            }
        }
        .frame(height: 72)
        .background(Color("elevation-1"))
        .cornerRadius(15)
        .shadow(radius: 5, y: 4)
        .padding([.horizontal], 10)
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
    
    @Binding var placeForAddPlaceToListSheet: ExplorePlace?
    @Binding var imageForAddPlaceToListSheet: UIImage?
    
    var body: some View {
        HStack(alignment: .center, spacing: 0.0) {
            HStack {
                if (self.place.isNewPlace) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.blue)
                        .frame(width: 10, height: 10)
                } else {
                    VStack {
                        Text("")
                    }
                    .frame(width: 10, height: 10)
                }
            }
            .padding([.trailing], 5)
            HStack {
                PlaceRowImage(image: self.place.image)
                    .clipShape(Rectangle())
                    .frame(width: 50, height: 50)
                    .cornerRadius(15)
                VStack (alignment: .leading) {
                    Text(self.place.place.name != nil ? self.place.place.name! : "")
                        .font(.system(size:18))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    Text(self.place.distance != nil ? "\(getDistanceStringToDisplay(self.place.distance!))" : "Loading distance...")
                        .font(.system(size: 12))
                        .lineLimit(1)
                        .foregroundColor(Color("text-secondary"))
                }
                Spacer()
            }
            .onTapGesture {
                self.placeIdToNavigateTo = self.place.place.placeID!
                self.goToPlace = 1
            }
            Spacer()
            VStack {
                VStack {
                    Text("GO")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.white)
                }
                .frame(width: 40, height: 40)
                .background(Color(UIColor.systemRed))
                .cornerRadius(15)
            }
            .frame(width: 40)
            .onTapGesture {
                self.exploreModel.changeCurrentTargetTo(self.place)
            }
            HStack {
                Image(systemName: "ellipsis")
            }
            .frame(width: 40)
            .onTapGesture {
                self.showActionSheet.toggle()
            }
            .actionSheet(isPresented: self.$showActionSheet) {
                ActionSheet(title: Text("\(self.place.place.name!)"), buttons: [
                    .default(Text("Add to collection")) {
                        self.showSheet.toggle()
                        self.sheetSelection = "add_to_placelist"
                        self.placeForAddPlaceToListSheet = self.place
                        self.imageForAddPlaceToListSheet = self.place.image
                    },
                    .destructive(Text("Remove from explore")) { ExploreModel.shared.removePlaceFromExplore(self.place)
                    },
                    .cancel()
                ])
            }
        }
        .frame(height: 60)
        .padding([.leading], 5)
        .padding([.trailing], 10)
    }
}


struct ExplorePlaceVisitedRow: View {
    @State var place: ExplorePlace
    @State var showActionSheet: Bool = false
    
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    @Binding var placeIdToNavigateTo: String?
    @Binding var goToPlace: Int?
    
    @Binding var placeForAddPlaceToListSheet: ExplorePlace?
    @Binding var imageForAddPlaceToListSheet: UIImage?
    
    var body: some View {
        HStack(alignment: .center, spacing: 0.0) {
            HStack {
                PlaceRowImage(image: self.place.image)
                    .clipShape(Rectangle())
                    .frame(width: 50, height: 50)
                    .cornerRadius(15)
                    .opacity(0.5)
                VStack (alignment: .leading){
                    Text(self.place.place.name != nil ? self.place.place.name! : "")
                        .font(.system(size:18))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .foregroundColor(Color("text-secondary"))
                    
                    Text(self.place.visited_at != nil ? getVisitedAtStringToDisplay(self.place.visited_at!) : "")
                        .font(.system(size: 12))
                        .lineLimit(1)
                        .foregroundColor(Color("text-secondary"))
                    
                }
                Spacer()
            }
            .onTapGesture {
                self.placeIdToNavigateTo = self.place.place.placeID!
                self.goToPlace = 1
            }
            Spacer()
            VStack {
                VStack {
                    Image(systemName: "gobackward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(Color.white)
                        .font(Font.title.weight(.bold))
                }
                .frame(width: 40, height: 40)
                .background(Color("text-secondary"))
                .cornerRadius(15)
                .frame(width: 40)
            }
            .frame(width: 40)
            .onTapGesture {
                self.exploreModel.markPlaceAsUnvisited(self.place)
            }
            HStack {
                Image(systemName: "ellipsis")
            }
            .frame(width: 40)
            .onTapGesture {
                self.showActionSheet.toggle()
            }
            .actionSheet(isPresented: self.$showActionSheet) {
                ActionSheet(title: Text("\(self.place.place.name!)"), buttons: [
                    .default(Text("Add to collection")) {
                        self.showSheet.toggle()
                        self.sheetSelection = "add_to_placelist"
                        self.placeForAddPlaceToListSheet = self.place
                        self.imageForAddPlaceToListSheet = self.place.image
                    },
                    .destructive(Text("Remove from explore")) { ExploreModel.shared.removePlaceFromExplore(self.place)
                    },
                    .cancel()
                ])
            }
        }
        .frame(height: 60)
        .padding([.leading], 20)
        .padding([.trailing], 10)
    }
}
