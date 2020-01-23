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
    @State var openingHoursText: [String]? = []
    @State var photos: [GMSPlacePhotoMetadata]? = []
    @State var gallery: [UIImage] = []
    
    
    
    var body: some View {
        VStack {
            if (place == nil) {
                Text("")
            } else {
                ScrollView{
                    VStack{
                    VStack{
                        GalleryView(gallery: self.$gallery)
                            }
                        InnerItemView(place: place!, isOpen: isOpen!, priceLevel: priceLevel!, type: type!, openingHoursText: openingHoursText!, gallery: self.$gallery)
                            .offset(y:-30)
                    }}}
        }.onAppear {
            getPlace(placeID: self.placeId) { (place: GMSPlace?, error: Error?) in
                if let error = error {
                    print("An error occurred: \(error.localizedDescription)")
                    return
                }
                if let place = place {
                    self.place = place
                    if let openingHours = place.openingHours{
                        if let openingHoursTexts = openingHours.weekdayText{
                            self.openingHoursText = openingHoursTexts
                        }}
                    self.isOpen = getPlaceIsOpenNow(isOpen: place.isOpen(at:NSDate.now))
                    self.priceLevel = getPlacePriceLevel(priceLevel: place.priceLevel)
                    if let types = place.types{
                        self.type = parseType(types:types)}
                    if let photos = place.photos{
                        print("photos l.54")
                        for (index, image) in photos.enumerated(){
                        guard index <= 5 else {
                            print("break")
                            break}
                        getPlaceFoto(photoMetadata: image){ (photo: UIImage?, error: Error?) in
                            if let error = error {
                                print("Error loading photo metadata: \(error.localizedDescription)")
                                return
                            }
                            if let photo = photo {
                                self.gallery.append(photo)
                            }
                        }
                        }
                        
                    }
                    
                    print("The selected place is: \(String(describing: place.name))")
                }
            }
        }
    }
}

struct InnerItemView: View {
    var place: GMSPlace
    var isOpen: String
    var priceLevel: Int
    var type: String
    var openingHoursText: [String]
    @Binding var gallery: [UIImage]
    @State var showSheet = false

    
    
    var body: some View {
//        ScrollView(showsIndicators: false){
            VStack{
                    //---------------------------------------------
//                    GalleryView(photos: place.photos, gallery: self.$gallery)
//                        .frame(width:UIScreen.main.bounds.width, height:300)
                    //---------------------------------------------
                    //topbar info
                    HStack(){
                        //type
                        Text(type)
                        //distance
                        //priceLevel
                        Spacer()
                        HStack{
                            ForEach (drawSigns(signs: getPlacePriceLevel(priceLevel: place.priceLevel), name: "eurosign.circle"), id: \.self) { sign in
                                Image(systemName:sign)}
                            
                        }
                        Spacer()
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
                        
                    } // end stack top bar
                        .padding(.horizontal,5)
                        .frame(width:UIScreen.main.bounds.width, height:50)
                        .background(Color.white)
                        .cornerRadius(15)
                    
                    
                //end Zstack
                
                //---------------------------------------------
                //main info
                VStack(alignment:.leading, spacing: 10){
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
                    Text(isOpen)}
                    .frame(width:UIScreen.main.bounds.width-10, height:300)
                //---------------------------------------------
                //map
                VStack(alignment: .center){
                    ItemMapView(coordinate: place.coordinate)}.cornerRadius(15)
                    .frame(width:UIScreen.main.bounds.width-10, height:220)
                //end
                //---------------------------------------------
                VStack{
                    ScrollWeekView(data: createDateCardData(openingHoursText: openingHoursText))
                }.frame(width:UIScreen.main.bounds.width-10, height:250)
                
                
            }// end Vstack
//        }// end ScrollView
            .sheet(isPresented: $showSheet) {
                ItemAddSheet(place: self.place, placeImage: self.gallery.indices.contains(0) ? self.gallery[0] : nil, showSheet: self.$showSheet)
                
        }
        .navigationBarTitle(Text(place.name != nil ? place.name! : ""), displayMode:.inline)
//        .onAppear {
//            self.photoGallery.getGallery(images: self.place.photos)
//        }
    }//end body
}//end wholew View


struct GalleryView:View{
//    var photos: [GMSPlacePhotoMetadata]?
    @Binding var gallery: [UIImage]
//    @ObservedObject var photoGallery : Gallery = Gallery()
    
    var body : some View {
            ScrollView(.horizontal,showsIndicators: false){
                HStack (spacing:5) {
                    ForEach(self.gallery, id:\.self){
                        photo in
                        return HStack{ ItemImageView(image:photo)} .frame(width:UIScreen.main.bounds.width, height:300)
                    }
                }
            }
//        .onAppear {
//            if let photos = self.photos {
//                    for (index, image) in photos.enumerated(){
//                        guard index <= 5 else {
//                            break}
//                        getPlaceFoto(photoMetadata: image){ (photo: UIImage?, error: Error?) in
//                            if let error = error {
//                                print("Error loading photo metadata: \(error.localizedDescription)")
//                                return
//                            }
//                            if let photo = photo {
//                                self.gallery.append(photo)
//                            }
//                        }
//                        //            else {
//                        //                return
//                        //            }
//                    }
//                self.photoGallery.getGallery(images: photos)} else {
//                self.gallery.append(UIImage(named: "place_image_placeholder")!)
//            }
//        }
    }
}

// weekdays
struct DateCardView: View {
    var day: String
    var hours: String
    
    var body: some View {
        VStack {
            HStack {
                Text(self.day)
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
            }.padding(5)
                .frame(width:160, height:30)
                .background(Color.red)
            Spacer()
            
            HStack() {
                Text(self.hours)
                    .font(.system(size:12))
                
                //                    .frame(width:210, alignment:.leading)
                
            }.padding(.horizontal, 5)
            Spacer()
        }
        .frame(width:160, height:120)
        .background(Color.gray)
        .cornerRadius(20)
        
        
    }
}
struct ScrollWeekView:View{
    var data : [DateCard]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack (spacing:10){
                ForEach(data, id:\.self) {
                    item in
                    GeometryReader { geometry in
                        DateCardView(day:item.day, hours:item.hours)
                            .rotation3DEffect(Angle(degrees:
                                Double(geometry.frame(in:.global).minX - 30) / -30), axis:(x:0, y:10, z:0))
                        
                    }.frame(width:160, height:120)
                }
            }.padding(30)
        }
    }
}

struct DateCard:Identifiable, Hashable{
    var id = UUID()
    var day:String
    var hours:String
}

func parseOpeningHour(openingHour:String)->[String]{
    let endOfWeekday = openingHour.firstIndex(of: ":")!
    let weekday = openingHour[...endOfWeekday].replacingOccurrences(of: ":", with: "")
    let timeWhole = openingHour[endOfWeekday...]
    let time = timeWhole.replacingCharacters(in: ...timeWhole.startIndex, with: "").replacingOccurrences(of: ",", with: "\n")
    return [String(weekday), time]
    
}

func createDateCardData(openingHoursText:[String])->[DateCard]{
    var temp:[DateCard] = []
    for day in openingHoursText{
        temp.append(DateCard(day:parseOpeningHour(openingHour:day)[0], hours:parseOpeningHour(openingHour:day)[1]))}
    return temp
    
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

