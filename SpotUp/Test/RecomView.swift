//
//  RecomView.swift
//  SpotUp
//
//  Created by Havy Ha on 20.01.20.
//

import SwiftUI

struct RecomView: View {

    var body: some View {
    
        VStack {
            ScrollCardsView()}
    }
}

struct RecomView_Previews: PreviewProvider {
    static var previews: some View {
        RecomView()
    }
}


struct RecomCard: View {
    
    var body: some View {
        VStack {
            VStack {
                Image("twinlake")
                    .resizable()
                    .aspectRatio(contentMode:.fill)
                    .scaledToFill()
                    .frame(width:210, height:230)
            }.cornerRadius(20)
            HStack() {
                Text("Spot Name")
                    .font(.system(size:24, weight:.bold))
//                    .frame(width:210, alignment:.leading)
                Spacer()
            }.padding(.horizontal, 5)

        }.padding(.bottom, 10)
            .frame(width:210, height:280)
        
    }
}

struct DateCardView2: View {
    var body: some View {
        VStack {
            HStack {
                Text("Monday")
                 .foregroundColor(Color.white)
                    .fontWeight(.bold)
            }.padding(5)
                .frame(width:160, height:30)
                .background(Color.red)
            Spacer()
            
            HStack() {
                Text("10:00-12:00 \n15:00-18:00")
                    .font(.system(size:20))
                   
                //                    .frame(width:210, alignment:.leading)
                
            }.padding(.horizontal, 5)
            Spacer()
        }
        .frame(width:160, height:120)
        .background(Color.gray)
        .cornerRadius(20)
        
        
    }
}

struct DateCard2:Identifiable{
    var id = UUID()
    var day:String
    var hours:String
}

struct Recommendation:Identifiable{
    var id = UUID()
    var image = UIImage()
    var name : String
}

//struct Section: Identifiable{
//    var id = UUID()
//    var name:String
//    var image: UIImage
//}
struct ScrollWeekView2:View{
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack (spacing:10){
                ForEach(0..<7) { item in
                    GeometryReader { geometry in
                        DateCardView2()
                            .rotation3DEffect(Angle(degrees:
                                Double(geometry.frame(in:.global).minX - 30) / -30), axis:(x:0, y:10, z:0))
                        
                    }.frame(width:160, height:120)
                }
            }.padding(30)
        }
    }
}
struct ScrollCardsView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack (spacing:30){
                ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                    GeometryReader { geometry in
                        RecomCard()
                            .rotation3DEffect(Angle(degrees:
                                Double(geometry.frame(in:.global).minX - 30) / -20), axis:(x:0, y:10, z:0))
                        
                    }.frame(width:210, height:260)
                }
            }.padding(30)
        }
    }
}

func positionDay (day:Int)->CGFloat{
    var position:CGFloat
    if (day == 1){
        position = 0
    }
    
    if (day == 2){
        position = 120
    }
    
    if (day == 5){
        position = 500}
    else{
        return 10}
    
    return position

}

