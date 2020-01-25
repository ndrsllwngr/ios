//
//  ExploreView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 16.01.20.
//

import SwiftUI
import UIKit
import GoogleMaps
import GooglePlaces

struct ExploreView: View {
    @Binding var tabSelection: Int
    
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @State var showSheet: Bool = false
    @State var sheetSelection = "none"
    
    @State var placeIdToNavigateTo: String? = nil
    @State var goToPlace: Int? = nil
    
    @State var placeForAddPlaceToListSheet: ExplorePlace? = nil
    @State var imageForAddPlaceToListSheet: UIImage? = nil
    
    @State var sortByDistance = true
    
    var body: some View {
        VStack {
            if (self.placeIdToNavigateTo != nil) {
                NavigationLink(destination: ItemView(placeId: self.placeIdToNavigateTo!), tag: 1, selection: self.$goToPlace) {
                    Text("")
                }
            }
            if (self.exploreModel.exploreList != nil) {
                ExploreActiveView(tabSelection: self.$tabSelection,
                                  showSheet: self.$showSheet,
                                  sheetSelection: self.$sheetSelection,
                                  placeIdToNavigateTo: self.$placeIdToNavigateTo,
                                  goToPlace: self.$goToPlace,
                                  placeForAddPlaceToListSheet: self.$placeForAddPlaceToListSheet,
                                  imageForAddPlaceToListSheet: self.$imageForAddPlaceToListSheet,
                                  sortByDistance: self.$sortByDistance)
            } else {
                ExploreInactiveView(showSheet: self.$showSheet, sheetSelection: self.$sheetSelection)
            }
            
        }
        .onAppear{
            self.exploreModel.locationManagerBeginNotifyingExplore()
            self.exploreModel.updateLastOpenedAt()
            self.exploreModel.updateDistancesInPlaces()
            self.exploreModel.loadPlaceImages()
        }
        .onDisappear() {
            self.exploreModel.locationManagerStopNotifyingExplore()
        }
            
        .sheet(isPresented: $showSheet) {
            if (self.sheetSelection == "select_placelist") {
                SelectPlaceListToExploreSheet(showSheet: self.$showSheet)
            } else if (self.sheetSelection == "add_to_placelist"){
                AddPlaceToListSheet(place: self.placeForAddPlaceToListSheet!.place, placeImage: self.imageForAddPlaceToListSheet, showSheet: self.$showSheet)
            }
            
        }
        .navigationBarTitle(Text("Explore"), displayMode: .inline)
        .navigationBarItems(trailing: HStack {
            if self.exploreModel.exploreList != nil {
                ExploreSortButton(sortByDistance: self.$sortByDistance)
            }
        })
    }
}

struct ExploreActiveView: View {
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @Binding var tabSelection: Int
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    @Binding var placeIdToNavigateTo: String?
    @Binding var goToPlace: Int?
    
    @Binding var placeForAddPlaceToListSheet: ExplorePlace?
    @Binding var imageForAddPlaceToListSheet: UIImage?
    
    @Binding var sortByDistance: Bool
    
    var body: some View {
        VStack(spacing: 0.0) {
            if (self.exploreModel.exploreList != nil) {
                HStack {
                    Image(systemName: "map")
                    Text("\(self.exploreModel.exploreList!.places.count) Places")
                    Spacer()
                    Button(action: {
                        self.exploreModel.quitExplore()
                    }) {
                        Text("Quit")
                            .accentColor(Color("text-secondary"))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                ExploreMapView(exploreList: self.exploreModel.exploreList!)
                    .frame(height: 180) // ToDo make height based on Geometry Reader
                
                if !exploreModel.exploreList!.places.isEmpty {
                    CurrentTargetRow( showSheet: self.$showSheet,
                                      sheetSelection: self.$sheetSelection,
                                      placeIdToNavigateTo: self.$placeIdToNavigateTo,
                                      goToPlace: self.$goToPlace,
                                      placeForAddPlaceToListSheet: self.$placeForAddPlaceToListSheet,
                                      imageForAddPlaceToListSheet: self.$imageForAddPlaceToListSheet)
                        .offset(y: -36)
                    ScrollView {
                        HStack {
                            Text("Travel queue")
                            .font(.system(size:20, weight:.bold))
                            Spacer()
                        }
                        .padding([.leading], 20)
                        if (!exploreModel.exploreList!.places.filter{$0.id != exploreModel.exploreList!.currentTarget?.id && !$0.visited}.isEmpty) {
                            ForEach (sortPlaces(places: exploreModel.exploreList!.places.filter{$0.id != exploreModel.exploreList!.currentTarget?.id && !$0.visited}, sortByDistance: self.sortByDistance), id: \.self) // \.self is very important here, otherwise the list wont update the list_item, because it thinks the item is still the same because the id didn't change (if place would be Identifiable)
                            { place in
                                ExplorePlaceRow(place: place,
                                                showSheet: self.$showSheet,
                                                sheetSelection: self.$sheetSelection,
                                                placeIdToNavigateTo: self.$placeIdToNavigateTo,
                                                goToPlace: self.$goToPlace,
                                                placeForAddPlaceToListSheet: self.$placeForAddPlaceToListSheet,
                                                imageForAddPlaceToListSheet: self.$imageForAddPlaceToListSheet)
                                    .listRowInsets(EdgeInsets()) // removes left and right padding of the list elements
                            }
                        } else {
                            HStack {
                                Image(uiImage: UIImage(named: "explore-empty-trail-sign-bw")!)
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50.0, height: 50.0, alignment: .center)
                                Spacer()
                                Text("Travel queue is empty")
                                    .foregroundColor(Color("text-secondary"))
                                Spacer()
                            }
                            .frame(height: 60)
                            .padding([.horizontal], 20)
                        }
                        if (!exploreModel.exploreList!.places.filter{$0.visited}.isEmpty) {
                            HStack {
                                Text("Visited")
                                .font(.system(size:20, weight:.bold))
                                Spacer()
                            }
                            .padding([.leading], 20)
                            ForEach (exploreModel.exploreList!.places.filter{$0.visited}.sorted{$0.visited_at! > $1.visited_at!}, id: \.self) // \.self is very important here, otherwise the list wont update the list_item, because it thinks the item is still the same because the id didn't change (if place would be Identifiable)
                            { place in
                                ExplorePlaceVisitedRow(place: place,
                                                       showSheet: self.$showSheet,
                                                       sheetSelection: self.$sheetSelection,
                                                       placeIdToNavigateTo: self.$placeIdToNavigateTo,
                                                       goToPlace: self.$goToPlace,
                                                       placeForAddPlaceToListSheet: self.$placeForAddPlaceToListSheet,
                                                       imageForAddPlaceToListSheet: self.$imageForAddPlaceToListSheet)
                                    .listRowInsets(EdgeInsets()) // removes left and right padding of the list elements
                            }
                        }
                    }
                    Spacer()
                } else {
                    Spacer()
                    Button(action: {
                        self.tabSelection = 1
                    }) {
                        VStack {
                            Image(uiImage: UIImage(named: "explore-empty-map")!)
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150.0, height: 150.0, alignment: .center)
                            Text("Add places and start exploring.")
                                .font(.system(size:16, weight:.bold))
                                .accentColor(Color("brand-color-primary"))
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct ExploreInactiveView: View {
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    var body: some View {
        GeometryReader { metrics in
            VStack {
                Spacer()
                Image(uiImage: UIImage(named: "explore-empty-trail-sign")!)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200.0, height: 200.0, alignment: .center)
                Spacer()
                Button(action: {
                    self.showSheet.toggle()
                    self.sheetSelection = "select_placelist"
                }) {
                    VStack {
                        Text("Explore collection")
                            .font(.system(size:20, weight:.bold))
                            .accentColor(Color.white)
                            .padding([.vertical], 15)
                    }
                    .frame(width: metrics.size.width * 0.8)
                    .background(Color("brand-color-primary-soft"))
                    .cornerRadius(15)
                }
                .padding([.bottom], 20)
                Button(action: {
                    self.exploreModel.startExploreWithEmptyList()
                }) {
                    VStack {
                        Text("Start new queue")
                            .font(.system(size:20, weight:.bold))
                            .accentColor(Color.white)
                            .padding([.vertical], 15)
                    }
                    .frame(width: metrics.size.width * 0.8)
                    .background(Color("brand-color-secondary"))
                    .cornerRadius(15)
                }
                Spacer()
            }
        }
        
    }
}

struct ExploreSortButton: View {
    @Binding var sortByDistance: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                self.sortByDistance.toggle()
            }) {
                HStack {
                    Spacer()
                    Image(systemName: sortByDistance ? "textformat.abc" : "textformat.123")
                }
                .frame(width: 49, height: 49)
            }
        }
        
    }
}

struct ExploreMapView : UIViewRepresentable {
    var exploreList: ExploreList
    var defaultLocation = CLLocationCoordinate2D(
        latitude: 48.149552,
        longitude: 11.594079
    )
    func makeUIView(context: Context) -> GMSMapView {
        
        var initialCoordinates = self.defaultLocation
        if let currentTarget = self.exploreList.currentTarget {
            initialCoordinates = currentTarget.place.coordinate
        }
        
        let camera = GMSCameraPosition.camera(
            withLatitude: initialCoordinates.latitude,
            longitude: initialCoordinates.longitude,
            zoom: 12.0
        )
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        //mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        return mapView
    }
    
    func updateUIView(_ view: GMSMapView, context: Context) {
        if (self.exploreList.places.isEmpty) {
            return
        }
        if let currentTarget = self.exploreList.currentTarget {
            view.animate(toLocation: currentTarget.place.coordinate)
        } else {
            view.animate(toLocation: exploreList.places[0].place.coordinate)
        }
        view.clear()
        self.exploreList.places.forEach { place in
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: place.place.coordinate.latitude,
                longitude: place.place.coordinate.longitude
            )
            marker.title = place.place.name
            
            if(place.visited){
                marker.icon = GMSMarker.markerImage(with: UIColor.systemGray)
            } else if (place.id == self.exploreList.currentTarget?.id) {
                marker.icon = GMSMarker.markerImage(with: UIColor.systemBlue)
            } else {
                marker.icon = GMSMarker.markerImage(with: UIColor.systemRed )
            }
            marker.map = view
            
        }
        
    }
}
