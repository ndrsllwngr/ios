//
//  ItemView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 07.01.20.
//

import SwiftUI
import GooglePlaces
import FirebaseFirestore

struct ItemView: View {
    var placeID: String?
    @State var place: GMSPlace?
    var isOpen:String?
    
    var body: some View {
        VStack {
            if (place == nil) {
                Text("")
            } else {
                InnerItemView(place: place!)
            }
        }.onAppear {
            
            if let placeID = self.placeID {
                getPlace(placeID: placeID) { (place: GMSPlace?, error: Error?) in
                    if let error = error {
                        print("An error occurred: \(error.localizedDescription)")
                        return
                    }
                    if let place = place {
                        self.place = place
                        print("The selected place is: \(String(describing: place.name))")
                        let isOpen = getPlaceIsOpenNow(isOpen: place.isOpen())
                        print("here")
                        print(isOpen)
                        
                    }
                    
                }
                if let place = place {
                    self.place = place
                    print("The selected place is: \(String(describing: place.name))")
                }
            }
        }
    }
}

struct InnerItemView: View {
    var place: GMSPlace
    @State var image: UIImage?
    @State var showSheet = false
    
    var body: some View {
        ScrollView(showsIndicators:false) {
            VStack {
                VStack (alignment: .leading){
                    ItemImageView(image: image != nil ? image! : UIImage())
                        .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 250)

                    //                    .offset(y: -90)
                    //                    .padding(.bottom, -90)
                    VStack{
                        Button(action: {
                            self.showSheet.toggle()
                        }){
                            Text("add to list")
                                .font(.custom("Europa Bold", size: 16))
                                .padding(10)
                                .background(Color.purple)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                            //
                        }
                        
                    }
                    VStack (alignment: .leading){
                        HStack{
                            Text("Restaurant (Test)")
                                .font(.custom("Europa Bold", size: 16))
                            Image(systemName: "mappin")
                            Text("3.67km (Test)")
                                .font(.custom("Europa Bold", size: 16))
                            Image(systemName:"eurosign.circle")
                        }
                    }.padding()
                    
                    VStack(alignment: .leading) {
                        Text(place.name != nil ? place.name! : "")
                            .font(.custom("Bodoni 72", size: 35))
                            .padding()
                        Text(place.formattedAddress != nil ? "\(place.formattedAddress!)" : "")
                         .font(.custom("Europa Bold", size: 16))
                            .padding()
                        Text(place.phoneNumber != nil ? "\(place.phoneNumber!)" : "no phone number")
                         .font(.custom("Europa Bold", size: 16))
                            .padding()
                        Button(action: {
                            if let website = self.place.website {
                                UIApplication.shared.open(website)
                            }
                        }){
                            Text("Open Website")
                             .font(.custom("Europa Bold", size: 16))
                        }.padding()
                    }
                    .frame(minWidth: 0,maxWidth: .infinity, minHeight: 360, maxHeight: 360)
                    .padding()
                    
                    
                    ItemMapView(coordinate: place.coordinate)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height:300)
                }
                .sheet(isPresented: $showSheet) {
                    AddPlaceToListSheet(place: self.place, placeImage: self.$image, showSheet: self.$showSheet)
                }
                .navigationBarTitle(Text(place.name != nil ? place.name! : ""), displayMode:.inline)
                .onAppear {
                    if let photos = self.place.photos {
                        getPlaceFoto(photoMetadata: photos[0]) { (photo: UIImage?, error: Error?) in
                            if let error = error {
                                print("Error loading photo metadata: \(error.localizedDescription)")
                                return
                            }
                            if let photo = photo {
                                self.image = photo;
                                
                            }
                        }
                    }
                }
            }
        }
    }
}


//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
