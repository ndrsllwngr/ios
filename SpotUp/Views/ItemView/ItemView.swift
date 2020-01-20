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
    @State var type: String? = nil
    
    var body: some View {
        VStack {
            if (place == nil) {
                Text("")
            } else {
                InnerItemView(place: place!, isOpen: isOpen!, priceLevel: priceLevel!, type: type!)
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
                    if let types = place.types{
                    self.type = parseType(types:types)}
                    dump(place.openingHours)
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
    var type:String
    @ObservedObject var photoGallery = Gallery()
    @State var image: UIImage?
    @State var image2: UIImage?
    @State var showSheet = false
    
    var body: some View {
        ScrollView{
        VStack {
            ScrollView{
            HStack {
                ForEach(photoGallery.gallery, id:\.self){
                    photo in
                    return ItemImageView(image:photo)
                }
//                ItemImageView(image: image != nil ? image! : UIImage())
//
//                    .offset(y: -90)
//                    .padding(.bottom, -90)
                }}
            
        //topbar info
            HStack{
                //type
                Text(type)
                //distance
                //priceLevel
                ForEach (drawSigns(signs: getPlacePriceLevel(priceLevel: place.priceLevel), name: "eurosign.circle"), id: \.self) { sign in
                    Image(systemName:sign)
                
                }
                //addbutton
                Button(action: {
                    self.showSheet.toggle()
                }){
                    HStack {
                        Image(systemName: "plus")
                            .font(.body)
                        Text("add")
                            .fontWeight(.semibold)
                            .font(.body)
                    }
                    .padding(5)
                    .foregroundColor(.white)
                   .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(5)
                    
                }
            }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
        .cornerRadius(15)
            .padding()
            .offset(y:-30)
            
            //main info
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
                }){Text("Call Now").foregroundColor(.red)}
                Text(place.phoneNumber != nil ? "\(place.phoneNumber!)" : "no phone number")
                Button(action: {
                    if let website = self.place.website {
                        UIApplication.shared.open(website)
                    }
                }){
                    Text("Open Website").foregroundColor(.red)
                }
            Text(isOpen)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: 300)

            //map
            VStack{
            ItemMapView(coordinate: place.coordinate)
                .edgesIgnoringSafeArea(.top)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: 300)

            }
            //end
                
                Spacer()
            }
        }
        .sheet(isPresented: $showSheet) {
            ItemAddSheet(place: self.place, placeImage: self.$image, showSheet: self.$showSheet)
        }
        .navigationBarTitle(Text(place.name != nil ? place.name! : ""), displayMode:.inline)
        .onAppear {
            self.photoGallery.getGallery(images: self.place.photos)
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


extension StringProtocol {
var firstUppercased: String {
    return prefix(1).uppercased() + dropFirst()
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

func parseType(types:[String])->String{
    let temp = types[0].replacingOccurrences(of: "_", with: " ")
    return temp.firstUppercased
    
}

