//
//  ItemImageView.swift
//  SpotUp
//
//  Created by Havy Ha on 05.12.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import GooglePlaces

struct ItemImageView: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
        .resizable()
        .clipShape(Rectangle())
        .scaledToFill()
//        .frame(minWidth:300, maxWidth: .infinity, minHeight: 300, maxHeight: 300)
           
    }
}



//struct SwipeGallery:View {
//    @State var images: [GMSPlacePhotoMetadata]
//    @State private var offset: CGFloat = 0
//    @State private var isDragging: Bool = false
//    @Binding var index: Int
//
//    let spacing: CGFloat = 10 //10
//    //geometry.size.width
//    let width: CGFloat = 200
//
//    var body: some View {
//        GeometryReader { geometry in
//            return ScrollView(.horizontal, showsIndicators: false) {
//                HStack(alignment: .top, spacing: self.spacing) {
//                    ForEach((self.images), id: \.self) { image in
//                        let a = getPlaceFoto(photoMetadata: image)
//                        return ItemImageView(image:a != nil ? a! : UIImage())
//                        }
//                    }
//                }
//            .content.offset(x: self.getOffset(geoWidth: geometry.size.width))
//            .animation(self.isDragging ? .none : .easeInOut(duration: 0.8))
//            .frame(width: geometry.size.width, alignment: .leading)
//            .gesture(
//                DragGesture()
//                    .onChanged({ value in
//                        self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
//                        self.isDragging = true
//                    })
//                    .onEnded({ value in
//                        if -value.predictedEndTranslation.width > geometry.size.width / 2, self.index < self.firestorePlaceList.places.count - 1 {
//                            self.index += 1
//                        }
//                        if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
//                            self.index -= 1
//                        }
//                        withAnimation { self.offset = -(geometry.size.width + self.spacing) * CGFloat(self.index) }
//                        self.isDragging = false
//                    })
//        )
//    }.frame(width: 260)
//    }
//func getOffset(geoWidth: CGFloat)-> CGFloat {
//    return self.isDragging ? self.offset : -(geoWidth + self.spacing) * CGFloat(self.index)
//}
//
//}



