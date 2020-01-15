//
//  SwipeView.swift
//  SpotUp
//
//  Created by Fangli Lu on 14.01.20.
//

import Foundation
import SwiftUI
import GooglePlaces

struct SwipeView: View {
    @State private var offset: CGFloat = 0
    @State private var isDragging: Bool = false
    @Binding var index: Int
    
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    let spacing: CGFloat = 10 //10
    //geometry.size.width
    let width: CGFloat = 200
    
    var body: some View {
        GeometryReader { geometry in
            return ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .top, spacing: self.spacing) {
                    ForEach((self.firestorePlaceList.places), id: \.self) { place in
//                        GeometryReader { geo in
                            PlaceCard(place: place.gmsPlace)
                                .frame(width: geometry.size.width)
//                                .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - geometry.size.width / 2.0) / 10.0), axis: (x: CGFloat(0), y: CGFloat(1), z: CGFloat(0)))
//                        }
                    }
                }
            }
            .content.offset(x: self.isDragging ? self.offset : -(geometry.size.width + self.spacing) * CGFloat(self.index))
                //.frame(width: geometry.size.width, alignment: .leading)
                .frame(width: geometry.size.width, alignment: .leading) //alignment der einzelnen Item --> also von anfang/vorne
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
                            self.isDragging = true
                        })
                        .onEnded({ value in
                            if -value.predictedEndTranslation.width > geometry.size.width / 2, self.index < self.firestorePlaceList.places.count - 1 {
                                self.index += 1
                            }
                            if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                                self.index -= 1
                            }
                            withAnimation { self.offset = -(geometry.size.width + self.spacing) * CGFloat(self.index) }
                            self.isDragging = false
                        })
            )
        }.frame(width: 260)
    }
}


struct PlaceCard: View {
    let place: GMSPlace
    @State var image: UIImage?
    var body: some View {
        VStack(alignment: .leading){
            CardImage(image: self.image != nil ? self.image! : UIImage())
            Text(place.name != nil ? place.name! : "")
            .padding()
        }
        .frame(width: 240) //height: 160
        .background(Color.white)
        .cornerRadius(15)
        .onAppear {
            if let photos = self.place.photos {
                getPlaceFoto(photoMetadata: photos[0]) { (photo: UIImage?, error: Error?) in
                    if let error = error {
                        print("Error loading photo metadata: \(error.localizedDescription)")
                        return
                    }
                    if let photo = photo {
                        self.image = photo;
                        print(self.image != nil ? self.image! : "Kein Bild")
                    }
                }
            }
        }
    }
}

struct CardImage: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .renderingMode(.original)
            .resizable()
            .clipShape(Rectangle())
            .scaledToFill()
            .frame(width: 240, height: 100)
            .cornerRadius(15)
            .shadow(radius: 10)
    }
}
