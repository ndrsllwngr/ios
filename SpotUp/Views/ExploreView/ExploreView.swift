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
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @State var showSheet: Bool = false
    @State var sheetSelection = "none"
    
    @State var placeIdToNavigateTo: String? = nil
    @State var goToPlace: Int? = nil
    
    @State var placeForPlaceMenuSheet: ExplorePlace? = nil
    @State var imageForPlaceMenuSheet: UIImage? = nil
    
    var body: some View {
        VStack {
            if (self.placeIdToNavigateTo != nil) {
                NavigationLink(destination: ItemView(placeId: self.placeIdToNavigateTo!), tag: 1, selection: self.$goToPlace) {
                    Text("")
                }
            }
            if (self.exploreModel.exploreList != nil) {
                ExploreActiveView(showSheet: self.$showSheet,
                                  sheetSelection: self.$sheetSelection,
                                  placeIdToNavigateTo: self.$placeIdToNavigateTo,
                                  goToPlace: self.$goToPlace,
                                  placeForPlaceMenuSheet: self.$placeForPlaceMenuSheet,
                                  imageForPlaceMenuSheet: self.$imageForPlaceMenuSheet)
            } else {
                ExploreInactiveView(showSheet: self.$showSheet, sheetSelection: self.$sheetSelection)
            }
            
        }
        .onAppear{
                self.exploreModel.locationManager.startUpdatingLocation()
                self.exploreModel.updateLastOpenedAt()
                self.exploreModel.loadPlaceImages()
                self.exploreModel.updateDistancesInPlaces()
        }
        .onDisappear {
            self.exploreModel.locationManager.stopUpdatingLocation()
            
        }
        .sheet(isPresented: $showSheet) {
            if (self.sheetSelection == "settings") {
                ExploreSettingsSheet(showSheet: self.$showSheet)
            } else if (self.sheetSelection == "select_placelist") {
                SelectPlaceListToExploreSheet(showSheet: self.$showSheet)
            } else if (self.sheetSelection == "place_menu") {
                ExplorePlaceMenuSheet(place: self.placeForPlaceMenuSheet!,
                                      image: self.$imageForPlaceMenuSheet,
                                      showSheet: self.$showSheet)
            }
            
        }
        .navigationBarTitle(Text("Explore"), displayMode: .inline)
        .navigationBarItems(trailing: HStack {
            ExploreSettingsButton(showSheet: self.$showSheet, sheetSelection: self.$sheetSelection)
        })
            .padding()
    }
}

struct ExploreActiveView: View {
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    @Binding var placeIdToNavigateTo: String?
    @Binding var goToPlace: Int?
    
    @Binding var placeForPlaceMenuSheet: ExplorePlace?
    @Binding var imageForPlaceMenuSheet: UIImage?
    
    var body: some View {
        VStack {
            if (self.exploreModel.exploreList != nil) {
                HStack {
                    Image(systemName: "map")
                    Text("\(self.exploreModel.exploreList!.places.count) Places")
                    Spacer()
                    Button(action: {
                        self.exploreModel.quitExplore()
                    }) {
                        Text("Quit")
                    }
                }
                
                ExploreMapView(exploreList: self.exploreModel.exploreList!)
                    .frame(height: 180, alignment: .center) // ToDo make height based on Geometry Reader
                
                if !exploreModel.exploreList!.places.isEmpty {
                    CurrentTargetRow( showSheet: self.$showSheet,
                                      sheetSelection: self.$sheetSelection,
                                      placeIdToNavigateTo: self.$placeIdToNavigateTo,
                                      goToPlace: self.$goToPlace,
                                      placeForPlaceMenuSheet: self.$placeForPlaceMenuSheet,
                                      imageForPlaceMenuSheet: self.$imageForPlaceMenuSheet)
                    List {
                        Section (header: Text("Travel Queue")) {
                            if (!exploreModel.exploreList!.places.filter{$0.id != exploreModel.exploreList!.currentTarget?.id && !$0.visited}.isEmpty) {
                                ForEach (exploreModel.exploreList!.places.filter{$0.id != exploreModel.exploreList!.currentTarget?.id && !$0.visited}, id: \.self) // \.self is very important here, otherwise the list wont update the list_item, because it thinks the item is still the same because the id didn't change (if place would be Identifiable)
                                { place in
                                    ExplorePlaceRow(place: place,
                                                    showSheet: self.$showSheet,
                                                    sheetSelection: self.$sheetSelection,
                                                    placeIdToNavigateTo: self.$placeIdToNavigateTo,
                                                    goToPlace: self.$goToPlace,
                                                    placeForPlaceMenuSheet: self.$placeForPlaceMenuSheet,
                                                    imageForPlaceMenuSheet: self.$imageForPlaceMenuSheet)
                                        .listRowInsets(EdgeInsets()) // removes left and right padding of the list elements
                                }
                            } else {
                                VStack {
                                    Text("Your travel queue is empty. Add more places!").listRowInsets(EdgeInsets())
                                }
                            }
                        }
                        if (!exploreModel.exploreList!.places.filter{$0.visited}.isEmpty) {
                            Section(header: Text("Already visited")) {
                                ForEach (exploreModel.exploreList!.places.filter{$0.visited}, id: \.self) // \.self is very important here, otherwise the list wont update the list_item, because it thinks the item is still the same because the id didn't change (if place would be Identifiable)
                                { place in
                                    ExplorePlaceVisitedRow(place: place,
                                                           placeIdToNavigateTo: self.$placeIdToNavigateTo,
                                                           goToPlace: self.$goToPlace)
                                        .listRowInsets(EdgeInsets()) // removes left and right padding of the list elements
                                }
                            }
                        }
                    }
                } else {
                    Spacer()
                    Text("There are currently no places in your Explore Queue. Feel free to add some!")
                }
                Spacer()
                
            }
        }
    }
}

struct ExploreInactiveView: View {
    @ObservedObject var exploreModel = ExploreModel.shared
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    var body: some View {
        VStack {
            Spacer()
            Text("Explore is currently not active.")
            Text("Why dont you...")
            Spacer()
            Button(action: {
                self.showSheet.toggle()
                self.sheetSelection = "select_placelist"
            }) {
                Text("1. Select a placelist you want to explore")
            }.padding()
            Button(action: {
                self.exploreModel.startExploreWithEmptyList()
            }) {
                Text("2. Create an empty explore queue and add places by yourself")
            }.padding()
            Spacer()
        }
    }
}

struct ExploreSettingsButton: View {
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    var body: some View {
        VStack {
            Button(action: {
                self.showSheet.toggle()
                self.sheetSelection = "settings"
            }) {
                Image(systemName: "ellipsis")
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
                marker.icon = GMSMarker.markerImage(with: .gray)
            } else if (place.id == self.exploreList.currentTarget?.id) {
                marker.icon = GMSMarker.markerImage(with: .green)
            } else {
                marker.icon = GMSMarker.markerImage(with: .red)
            }
            marker.map = view
            
        }
        
    }
}
