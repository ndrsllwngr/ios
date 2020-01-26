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
    @State var priceLevel: Int? = nil
    @State var type: String? = nil
    @State var openingHoursText: [String]? = []
    @State var photos: [GMSPlacePhotoMetadata]? = []
    @State var gallery: [UIImage] = [UIImage(named: "place_image_placeholder")!]
    @State var showSheet = false
    
    
    
    var body: some View {
        VStack(spacing: 0) {
            if (place == nil) {
                Text("")
            } else {
                // Avoids that scroll view scrolls under navbar
                Rectangle()
                    .frame(height: 1)
                .foregroundColor(Color("bg-primary"))
                ScrollView{
                    VStack(spacing: 0){
                        //                        ZStack{
                        VStack(spacing: 0){
                            GalleryView(gallery: self.$gallery)
                            Spacer()
                        }
                        InnerItemView(place: place!, priceLevel: priceLevel!, type: type!, openingHoursText: openingHoursText!, gallery: self.$gallery, showSheet:self.$showSheet)
                            //                                .background(Color("bg-primary"))
                            .offset(y: -25)
                        //                                .cornerRadius(15)
                        //                        .offset(y:-60)
                        //                                .padding(.top, 270)
                        //                                .zIndex(10)
                        //                        }
                    }
                    //                    ButtonOnTopView(showSheet:self.$showSheet)
                    //                    .offset(y:-930)
                    
                }}
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
                    self.priceLevel = getPlacePriceLevel(priceLevel: place.priceLevel)
                    if let types = place.types{
                        self.type = parseType(types:types)}
                    if let photos = place.photos{
                        var tmp:[UIImage] = []
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
                                    tmp.append(photo)
                                }
                                if tmp.isEmpty == false{
                                    self.gallery.removeAll()
                                    self.gallery = tmp}
                            }
                        }
                        
                    }
                    print("Gallery Size: \(String(describing: self.gallery.count))" )
                    print("The selected place is: \(String(describing: place.name))")
                }
            }
        }
    }
}

struct InnerItemView: View {
    var place: GMSPlace
    var priceLevel: Int
    var type: String
    var openingHoursText: [String]
    @Binding var gallery: [UIImage]
    @Binding var showSheet: Bool
    
    
    
    var body: some View {
        //        ScrollView(showsIndicators: false){
        VStack{
            HStack{
                Text(type)
                    .padding(.leading, 20)
                //distance
                //priceLevel
                Spacer()
                HStack{
                    ForEach (drawSigns(signs: getPlacePriceLevel(priceLevel: place.priceLevel), name: "eurosign.circle"), id: \.self) { sign in
                        Image(systemName:sign)}
                    
                }.padding(.trailing, 40)
            }
            .frame(width: UIScreen.main.bounds.width, height: 50)
            .background(Color.white)
            .cornerRadius(15)
            
            ButtonOnTopView(place: self.place, showSheet: self.$showSheet)
                .offset(y:-83.5)
                .padding(.bottom, -83.5)
            
            
            VStack(alignment:.leading, spacing:10){
                
                
                VStack{Text(place.name != nil ? place.name! : "")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                }
                .padding(.horizontal, 15)
                
                VStack{
                    Text(place.formattedAddress != nil ? "\(place.formattedAddress!)" : "")}
                    .padding(.horizontal, 15)
                
                Button(action:{
                    if let phoneNumber = self.place.phoneNumber{
                        let prefix = "tel://"
                        let trimmed = phoneNumber.replacingOccurrences(of: " ", with: "")
                        let tel = URL(string:(prefix + trimmed))
                        UIApplication.shared.open(tel!)
                    }
                }){HStack(spacing:20){
                    Image(systemName: "phone")
                        .foregroundColor(Color("brand-color-primary"))
                    Text(place.phoneNumber != nil ? "\(place.phoneNumber!)" : "No phone number could be found.")
                        .foregroundColor(Color("text-primary"))
                    
                }.padding(.horizontal,15)
                    
                }
                
                Button(action: {
                    if let website = self.place.website {
                        UIApplication.shared.open(website)
                    }
                }){
                    HStack(spacing:20){
                        Image(systemName: "desktopcomputer").foregroundColor(Color("brand-color-primary"))
                        Text("Open Website").foregroundColor(Color("text-primary"))
                        
                    }.padding(.horizontal, 15)
                }
            }
            .frame(width:UIScreen.main.bounds.width, height:250)
            
            VStack{
                ItemMapView(coordinate: place.coordinate)
                    .frame(width:UIScreen.main.bounds.width-30, height:200)
                    .cornerRadius(15)
                    .padding(20)
            }
            .frame(width:UIScreen.main.bounds.width-30, height:250)
            
            //end
            //---------------------------------------------
            
            VStack(spacing:10){
                if openingHoursText.count == 0 {
                    Image("placeholder-openingHours")
                        .resizable()
                        .scaledToFit()
                    Text("No opening hours could be find at this time.")
                }
                else{
                    ScrollWeekView(data: createDateCardData(openingHoursText: openingHoursText))
                }
            }.frame(width:UIScreen.main.bounds.width-10, height:200)
                .padding()
            
            
        }
            // end Vstack
            //        }// end ScrollView
            .sheet(isPresented: $showSheet) {
                AddPlaceToListSheet(place: self.place,
                                    placeImage: self.gallery.indices.contains(0) ? self.gallery[0] : nil,
                                    showSheet: self.$showSheet)
                
        }
        .navigationBarTitle(Text(place.name != nil ? place.name! : ""), displayMode:.inline)
        
        //        }
    }//end body
}//end wholew View
struct ButtonOnTopView: View{
    var place: GMSPlace
    @Binding var showSheet:Bool
    
    @State var showActionSheet: Bool = false
    
    var body: some View{
        VStack{
            HStack{
                Spacer()
                ZStack {
                    Circle().fill(Color("brand-color-primary"))
                    Image(systemName: "plus")
                        .font(.title).foregroundColor(Color.white)
                }
                .frame(width: 47, height:47)
                .onTapGesture {
                    self.showActionSheet.toggle()
                }
                .actionSheet(isPresented: self.$showActionSheet) {
                    ActionSheet(title: Text("\(self.place.name!)"), buttons: [
                        .default(Text("Add to explore")) {
                            ExploreModel.shared.addPlaceToExplore(self.place)
                        },
                        .default(Text("Add to collection")) {
                            self.showSheet.toggle()
                        },
                        .cancel()
                    ])
                }
            }.padding(.trailing)
        }
    }
}

struct GalleryView:View{
    @Binding var gallery: [UIImage]
    var body : some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack (spacing:5) {
                ForEach(self.gallery, id:\.self){
                    photo in
                    return HStack{ ItemImageView(image:photo)} .frame(width:UIScreen.main.bounds.width, height:300)
                }
            }
        }
    }
}

// weekdays
struct DateCardView: View {
    var day: String
    var hours: String
    @State var color = ""
    
    
    var body: some View {
        VStack{
            VStack {
                HStack {
                    Text(self.day)
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                }.padding(5)
                    .frame(width:160, height:30)
                    .background(Color(self.color))
                Spacer()
                
                HStack() {
                    Text(self.hours)
                        .font(.system(size:12))
                    
                }.padding(.horizontal, 5)
                Spacer()
            }
            .frame(width:160, height:120)
            .cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(self.color), lineWidth: 1))
            
        }.onAppear{
            self.color = setDateCardColor(today: Date().dayofTheWeek, day:self.day)
        }
        
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

extension Date {
    
    var dayofTheWeek: String {
        let dayNumber = Calendar.current.component(.weekday, from: self)
        // day number starts from 1 but array count from 0
        return daysOfTheWeek[dayNumber - 1]
    }
    
    private var daysOfTheWeek: [String] {
        return  ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
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

func setDateCardColor(today:String, day: String)->String {
    var color: String
    if (day.contains(today)){
        color = "brand-color-primary"
    }
    else{color = "text-secondary"}
    return color
}

