//
//  ItemView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 07.01.20.
//

import SwiftUI
import GooglePlaces
import FirebaseFirestore
import GoogleMaps

struct ItemView: View {
    var placeID: String?
    @State var place: GMSPlace?
    @State var myLocation: CLLocationCoordinate2D?
    @State var isOpen: String?
    @State var priceLevel: Int?
    @State var types: [String]
    
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
                        self.isOpen = getPlaceIsOpenNow(isOpen: place.isOpen())
                        self.priceLevel = getPlacePricelevel(priceLevel: place.priceLevel)
                        self.types = (place.types != nil ? place.types! : [] )
                        print(place.phoneNumber)
                        let distance = round(GMSGeometryDistance(place.coordinate, CLLocationCoordinate2D(latitude:48.137154, longitude:11.576124))/1000)
                        print (distance)
                        print (place.rating)
                        
                        
                    }
                    
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
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 280, maxHeight: 280)
                    
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
//                            drawSigns(signs: place.priceLevel, name: "eurosign.circle")
                        }
                    }.padding()
                    
                    VStack(alignment: .leading) {
                        Text(place.name != nil ? place.name! : "")
                            .font(.custom("Bodoni 72", size: 35))
                            .padding()
                        Text(place.formattedAddress != nil ? "\(place.formattedAddress!)" : "")
                            .font(.custom("Europa", size: 16))
                            .fontWeight(.bold)
                            .padding()
                        Button(action:
                            {
                                if let phoneNumber = self.place.phoneNumber {
                                    let tel = URL(string:("tel://" + phoneNumber))
                                    UIApplication.shared.open(tel!)
        
                                }
                        }){Text(self.place.phoneNumber != nil ? self.place.phoneNumber! : "")}
                            .padding()
                            .foregroundColor(.black)
                        VStack{
                            Button(action: {
                                if let website = self.place.website {
                                    UIApplication.shared.open(website)
                                    
                                }
                            }){ Text("open website")
                                //                            Text(self.website != nil ? self.website : "")
                                .font(.custom("Europa Bold", size: 16))
                                .foregroundColor(.black)
                            }
                            .padding()
                        }
                        
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

func drawSigns(signs: Int, name:String){
    if signs > 0{
        for _ in 1..<signs {
            Image(systemName: name)
        }
    }else {
        return
    }
    
}


//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
