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
    var placeId: String
    @State var place: GMSPlace? = nil
    @State var isOpen: String? = nil
    @State var priceLevel: Int? = nil
    @State var types: [String]? = nil
    
    var body: some View {
        VStack {
            if (place == nil) {
                Text("")
            } else {
                InnerItemView(place: place!, isOpen: isOpen!, priceLevel: priceLevel!, types: types!)
            }
        }.onAppear {
            getPlace(placeID: self.placeId) { (place: GMSPlace?, error: Error?) in
                if let error = error {
                    print("An error occurred: \(error.localizedDescription)")
                    return
                }
                if let place = place {
                    self.place = place
                    self.isOpen = getPlaceIsOpenNow(isOpen: place.isOpen(at:NSDate.now))
                    self.priceLevel = getPlacePriceLevel(priceLevel: place.priceLevel)
                    self.types = place.types
                    print("The selected place is: \(String(describing: place.name))")
                }
            }
        }
    }
}

struct InnerItemView: View {
    var place: GMSPlace
    var isOpen: String
    var priceLevel:Int
    var types:[String]
    
    @State var image: UIImage?
    @State var showSheet = false
    
    var body: some View {
        VStack {
            ItemMapView(coordinate: place.coordinate)
                .edgesIgnoringSafeArea(.top)
                .frame(height:300)
            
            HStack {
                ItemImageView(image: image != nil ? image! : UIImage())
                    .frame(width: 200,height: 200)
                    .offset(y: -90)
                    .padding(.bottom, -90)
                Button(action: {
                    self.showSheet.toggle()
                }){
                    Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                        .frame(width: 30, height: 30)
                }
            }
            ScrollView(showsIndicators: false){
                HStack{
                    ForEach (drawSigns(signs: getPlacePriceLevel(priceLevel: place.priceLevel), name: "eurosign.circle"), id: \.self) { sign in
                        Image(systemName:sign)
                    }
                }
                VStack(alignment: .leading) {
                    Text(place.name != nil ? place.name! : "")
                        .font(.title)
                    Text(place.formattedAddress != nil ? "\(place.formattedAddress!)" : "")
                    Button(action:{
                        if let phoneNumber = self.place.phoneNumber{
                            let prefix = "tel://"
                            let trimmed = phoneNumber.replacingOccurrences(of: " ", with: "")
                            let tel = URL(string:(prefix + trimmed))
                            UIApplication.shared.open(tel!)
                        }
                    }){Text("Call Now")}
                    Text(place.phoneNumber != nil ? "\(place.phoneNumber!)" : "no phone number")
                    Button(action: {
                        if let website = self.place.website {
                            UIApplication.shared.open(website)
                        }
                    }){
                        Text("Open Website")
                    }
                Text(isOpen)
                        }
                Spacer()
            }
        }
        .sheet(isPresented: $showSheet) {
            ItemAddSheet(place: self.place, placeImage: self.$image, showSheet: self.$showSheet)
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

func drawSigns(signs:Int, name:String)->[String]{
    var temp:[String]=[]
    if signs>0{
        for _ in 0..<signs{
            temp.append(name)
        }
    }else{
        return []
    }
    return temp
}
