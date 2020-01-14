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
    @Binding var index: Int
    
    var firestorePlaceList: FirestorePlaceList
    let spacing: CGFloat = 10
    //geometry.size.width
    let width: CGFloat = 200

    var body: some View {
        GeometryReader { geometry in
            return ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: self.spacing) {
                    ForEach((self.firestorePlaceList.places), id: \.self) { place in
                        //GeometryReader { geo in
                        CoverCard(place: place)
                            .frame(width: geometry.size.width)
//                            .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - geometry.size.width / 2.0) / 10.0), axis: (x: CGFloat(0), y: CGFloat(1), z: CGFloat(0)))
                        //}
                    }
                }
            }
            .content.offset(x: self.offset)
            //.frame(width: geometry.size.width, alignment: .leading)
            .frame(width: geometry.size.width, alignment: .leading) //alignment der einzelnen Item --> also von anfang/vorne
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
                    })
                    .onEnded({ value in
                        if -value.predictedEndTranslation.width > geometry.size.width / 2, self.index < self.firestorePlaceList.places.count - 1 {
                            self.index += 1
                        }
                        if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                            self.index -= 1
                        }
                        withAnimation { self.offset = -(geometry.size.width + self.spacing) * CGFloat(self.index) }
                    })
            )
        }
    }
}


struct CoverCard: View {
    let place: GMSPlace
    @State var image: UIImage?
    var body: some View {
        VStack{
            CardImage(image: (self.image != nil ? self.image! : UIImage()))
            Text(place.name != nil ? place.name! : "")
            }
        .frame(width: 240, height: 160)
        .border(Color.white)
        .background(Color.blue)
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

struct CardImage: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .clipShape(Rectangle())
            .frame(width: 100, height: 100)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 10)
    }
}
