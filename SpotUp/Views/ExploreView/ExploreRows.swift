import SwiftUI
import GooglePlaces

struct CurrentTargetRow: View {
    @ObservedObject var exploreModel = ExploreModel.shared
    
    // PROPS
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
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.placeIdToNavigateTo = self.exploreModel.exploreList!.currentTarget!.place.placeID!
                            self.goToPlace = 1
                        }
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
                        .padding(.trailing, 10)
                        VStack {
                            VStack {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundColor(Color("elevation-1"))
                                    .font(Font.title.weight(.bold))
                            }
                            .frame(width: 40, height: 40)
                            .background(Color.green)
                            .cornerRadius(15)
                            .frame(width: 40)
                        }
                        .frame(width: 40)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.exploreModel.markPlaceAsVisited(self.exploreModel.exploreList!.currentTarget!)
                        }
                        ThreeDotsWithActionSheet(place: self.exploreModel.exploreList!.currentTarget!,
                                                 buttonColor: Color("text-primary"),
                                                 showSheet: self.$showSheet,
                                                 sheetSelection: self.$sheetSelection,
                                                 placeForAddPlaceToListSheet: self.$placeForAddPlaceToListSheet,
                                                 imageForAddPlaceToListSheet: self.$imageForAddPlaceToListSheet)
                    }
                    .padding(.leading, 10)
                } else if (exploreModel.exploreList!.currentTarget == nil && !exploreModel.exploreList!.places.filter{!$0.visited}.isEmpty) {
                    HStack(spacing: 0.0) {
                        VStack(alignment: .center, spacing: 0){
                            Image(uiImage: UIImage(named: "explore-empty-target-bw-50")!)
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50, alignment: .center)
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                        Spacer()
                        Text("No target selected")
                            .foregroundColor(Color("text-secondary"))
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                } else {
                    HStack(spacing: 0.0) {
                        VStack(alignment: .center, spacing: 0){
                            Image(uiImage: UIImage(named: "explore-empty-guidebook-bw-50")!)
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50, alignment: .center)
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                        Spacer()
                        Text("All places were visited")
                            .foregroundColor(Color("text-secondary"))
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
        .frame(height: 72)
        .background(Color("elevation-1"))
        .cornerRadius(15)
        .shadow(color: Color.init(red:0.00, green:0.00, blue:0.00, opacity: 0.24), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 10)
    }
}


struct ExplorePlaceRow: View {
    @ObservedObject var exploreModel = ExploreModel.shared
    
    // PROPS
    var place: ExplorePlace
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
            .padding(.trailing, 5)
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
            .contentShape(Rectangle())
            .onTapGesture {
                self.placeIdToNavigateTo = self.place.place.placeID!
                self.goToPlace = 1
            }
            VStack {
                VStack {
                    Text("GO")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color("bg-primary"))
                }
                .frame(width: 40, height: 40)
                .background(Color(UIColor.systemRed))
                .cornerRadius(15)
            }
            .frame(width: 40)
            .contentShape(Rectangle())
            .onTapGesture {
                self.exploreModel.changeCurrentTargetTo(self.place)
            }
            ThreeDotsWithActionSheet(place: self.place,
                                     buttonColor: Color("text-primary"),
                                     showSheet: self.$showSheet,
                                     sheetSelection: self.$sheetSelection,
                                     placeForAddPlaceToListSheet: self.$placeForAddPlaceToListSheet,
                                     imageForAddPlaceToListSheet: self.$imageForAddPlaceToListSheet)
        }
        .frame(height: 50)
        .padding(.leading, 5)
        .padding(.trailing, 10)
    }
}


struct ExplorePlaceVisitedRow: View {
    @ObservedObject var exploreModel = ExploreModel.shared
    
    // PROPS
    var place: ExplorePlace
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
            .contentShape(Rectangle())
            .onTapGesture {
                self.placeIdToNavigateTo = self.place.place.placeID!
                self.goToPlace = 1
            }
            VStack {
                VStack {
                    Image(systemName: "gobackward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(Color("bg-primary"))
                        .font(Font.title.weight(.bold))
                }
                .frame(width: 40, height: 40)
                .background(Color("text-secondary"))
                .cornerRadius(15)
                .frame(width: 40)
            }
            .frame(width: 40)
            .contentShape(Rectangle())
            .onTapGesture {
                self.exploreModel.markPlaceAsUnvisited(self.place)
            }
            ThreeDotsWithActionSheet(place: self.place,
                                     buttonColor: Color("text-secondary"),
                                     showSheet: self.$showSheet,
                                     sheetSelection: self.$sheetSelection,
                                     placeForAddPlaceToListSheet: self.$placeForAddPlaceToListSheet,
                                     imageForAddPlaceToListSheet: self.$imageForAddPlaceToListSheet)
        }
        .frame(height: 50)
        .padding(.leading, 20)
        .padding(.trailing, 10)
    }
}

struct ThreeDotsWithActionSheet: View {
    // PROPS
    var place: ExplorePlace
    var buttonColor: Color
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    @Binding var placeForAddPlaceToListSheet: ExplorePlace?
    @Binding var imageForAddPlaceToListSheet: UIImage?
    // LOCAL
    @State var showActionSheet: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "ellipsis")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(buttonColor)
        }
        .frame(width: 40)
        .contentShape(Rectangle())
        .onTapGesture {
            self.showActionSheet.toggle()
            ExploreModel.shared.locationManagerPauseNotifiyingExploreForXSeconds()
        }
        .actionSheet(isPresented: self.$showActionSheet) {
            ActionSheet(title: Text("\(self.place.place.name!)"), buttons: [
                .default(Text("Add to collection")) {
                    self.showSheet.toggle()
                    self.sheetSelection = "add_to_placelist"
                    self.placeForAddPlaceToListSheet = self.place
                    self.imageForAddPlaceToListSheet = self.place.image
                },
                .destructive(Text("Remove from explore")) {
                    ExploreModel.shared.removePlaceFromExplore(self.place)
                },
                .cancel()
            ])
        }
    }
    
}
