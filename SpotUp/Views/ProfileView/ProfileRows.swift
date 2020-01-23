//
//  ProfileRows.swift
//  SpotUp
//
//  Created by Timo Erdelt on 21.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct CreateNewPlaceListRow: View {
    @Binding var showSheet: Bool
    @Binding var sheetSelection: String
    
    var body: some View {
        Button(action: {
            print("buttonPressed")
            self.sheetSelection = "create_placelist"
            self.showSheet.toggle()
        }) {
            GeometryReader { geo in
                HStack {
                    HStack {
                        Image(systemName: "plus.rectangle.on.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 32)
                    }
                    .frame(width: 120, height: 100)
                    Text("Create new place list")
                }
                .frame(width: geo.size.width, alignment: .leading)
                .background(Color("elevation-1"))
                .mask(Rectangle().cornerRadius(15))
            }.frame(height: 120)
            
        }
    }
}

struct PlacesListRow: View {
    var placeList: PlaceList
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                
                FirebasePlaceListRowImage(imageUrl: self.placeList.imageUrl)
                    .scaledToFill()
                    .frame(width: 120, height: 100)
                
                VStack(alignment: .leading) {
                    Text(self.placeList.name)
                        .bold()
                    
                    HStack {
                        Text("by \(self.placeList.owner.username)")
                        Spacer()
                        if (!self.placeList.isPublic) {
                            HStack {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 12)
                            }
                            .frame(width: 20, height: 20)
                            .background(Color("bg-placeholder"))
                            .mask(Rectangle().cornerRadius(100))
                        }
                        if (self.placeList.isCollaborative) {
                            HStack {
                                Image(systemName: "person.2.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12)
                            }
                            .frame(width: 20, height: 20)
                            .background(Color("bg-placeholder"))
                            .mask(Rectangle().cornerRadius(100))
                        }
                    }
                }.padding(.trailing)
            }
            .frame(width: geo.size.width, alignment: .leading)
            .background(Color("elevation-1"))
            .mask(Rectangle().cornerRadius(15))
        }.frame(height: 120)
    }
    
}
