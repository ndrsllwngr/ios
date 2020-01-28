import SwiftUI
import GooglePlaces

struct PlaceRow: View {
    var place: GMSPlaceWithTimestamp
    var placeListId: String
    
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    
    @State var showActionSheetSimple: Bool = false
    @State var showActionSheetWithWriteOptions: Bool = false
    
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    @Binding var placeIdToNavigateTo: String?
    @Binding var goToPlace: Int?
    
    @Binding var placeForAddPlaceToListSheet: GMSPlaceWithTimestamp?
    @Binding var imageForAddPlaceToListSheet: UIImage?
    
    @State var image: UIImage?
    @State var address: String?
    
    var body: some View {
        HStack(alignment: .center) {
            HStack {
                PlaceRowImage(image: self.image)
                    .clipShape(Rectangle())
                    .frame(width: 60, height: 60)
                    .cornerRadius(15)
                    .padding(.trailing, 10)
                VStack(alignment: .leading){
                    Text(self.place.gmsPlace.name != nil ? self.place.gmsPlace.name! : "")
                        .font(.system(size: 18))
                        .lineLimit(1)
                    Text(self.address != nil ? self.address! : "")
                        .font(.system(size: 12))
                        .lineLimit(1)
                        //.fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color("text-secondary"))
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.placeIdToNavigateTo = self.place.gmsPlace.placeID!
                self.goToPlace = 1
            }
            // We have to make the whole button conditional, not just the action sheet,
            //because it's not possible to place two action sheets on one onTapGesture
            if (self.firestorePlaceList.isOwnedPlaceList || self.firestorePlaceList.placeList.isCollaborative) {
                HStack {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .frame(width: 40)
                .contentShape(Rectangle())
                .onTapGesture {
                    self.showActionSheetWithWriteOptions.toggle()
                }
                .actionSheet(isPresented: self.$showActionSheetWithWriteOptions) {
                    ActionSheet(title: Text("\(self.place.gmsPlace.name!)"), buttons: [
                        .default(Text("Add to explore")) {
                            ExploreModel.shared.addPlaceToExplore(self.place.gmsPlace)
                        },
                        .default(Text("Add to collection")) {
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
                            self.showActionSheetWithWriteOptions.toggle()
                            FirestoreConnection.shared.deletePlaceFromList(placeListId: self.placeListId, place: self.place)
                        },
                        .cancel()
                    ])
                }
            } else {
                HStack {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .frame(width: 40)
                .contentShape(Rectangle())
                .onTapGesture {
                    self.showActionSheetSimple.toggle()
                }
                .actionSheet(isPresented: self.$showActionSheetSimple) {
                    ActionSheet(title: Text("\(self.place.gmsPlace.name!)"), buttons: [
                        .default(Text("Add to explore")) {
                            ExploreModel.shared.addPlaceToExplore(self.place.gmsPlace)
                        },
                        .default(Text("Add to collection")) {
                            self.showSheet.toggle()
                            self.sheetSelection = "add_to_placelist"
                            self.placeForAddPlaceToListSheet = self.place
                            self.imageForAddPlaceToListSheet = self.image
                        },
                        .cancel()
                    ])
                }
            }
        }.frame(height: 60)
            .onAppear {
                if let address = self.place.gmsPlace.formattedAddress {
                    self.address = address
                }
                
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
            .scaledToFill()
            .animation(.easeInOut)
    }
}
