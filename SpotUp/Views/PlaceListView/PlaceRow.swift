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
    var place: GMSPlaceWithTimestamp
    var placeListId: String
    
    @State var showActionSheet: Bool = false
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    @Binding var placeIdToNavigateTo: String?
    @Binding var goToPlace: Int?
    
    @Binding var placeForAddPlaceToListSheet: GMSPlaceWithTimestamp?
    @Binding var imageForAddPlaceToListSheet: UIImage?
    
    @State var image: UIImage?
    
    var body: some View {
        GeometryReader { metrics in
            HStack(alignment: .center) {
                HStack {
                    PlaceRowImage(image: self.image != nil ? self.image! : UIImage())
                        .padding(.trailing)
                    Text(self.place.gmsPlace.name != nil ? self.place.gmsPlace.name! : "")
                    Spacer()
                }
                .frame(width: metrics.size.width * 0.8)
                .onTapGesture {
                    self.placeIdToNavigateTo = self.place.gmsPlace.placeID!
                    self.goToPlace = 1
                }
                HStack {
                    Spacer()
                    Image(systemName: "ellipsis")
                }
                .frame(width: metrics.size.width * 0.2)
                .onTapGesture {
                    self.showActionSheet.toggle()
                }
                .actionSheet(isPresented: self.$showActionSheet) {
                    ActionSheet(title: Text("\(self.place.gmsPlace.name!)"), buttons: [
                        .default(Text("Add to explore")) {
                            ExploreModel.shared.addPlaceToExplore(self.place.gmsPlace)
                        },
                        .default(Text("Add to other collection")) {
                            self.showSheet.toggle()
                            self.sheetSelection = "add_to_placelist"
                            self.placeForAddPlaceToListSheet = self.place
                            self.imageForAddPlaceToListSheet = self.image
                        },
                        .default(Text("Set place image as collection image")) {
                            if let image = self.image {
                                FirebaseStorage.shared.uploadImageToStorage(id: self.placeListId, imageType: .PLACELIST_IMAGE, uiImage: image)
                            } else {
                                print("Place has no image")
                            }
                        },
                        .destructive(Text("Remove from collection")) {
                            self.showActionSheet.toggle()
                            FirestoreConnection.shared.deletePlaceFromList(placeListId: self.placeListId, place: self.place)
                        },
                        .cancel()
                    ])
                }
            }
        }
        .frame(height: 90)
        .onAppear {
            if let photos = self.place.gmsPlace.photos {
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
            .animation(.default)
            .clipShape(Rectangle())
            .scaledToFill()
            .frame(width: 50, height: 50)
            .cornerRadius(15)
    }
}
