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
                    .frame(width: 100, height: 60)
                    Text("Create new place list")
                }
                .frame(width: geo.size.width, alignment: .leading)
                .background(Color("elevation-1"))
                .mask(Rectangle().cornerRadius(15))
                .shadow(radius: 5, y: 4)
                .padding(.vertical)
            }.frame(height: 60)
            
        }
    }
}

struct PlacesListRow: View {
    var placeList: PlaceList
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack {
                    
                    FirebasePlaceListRowImage(imageUrl: self.placeList.imageUrl)
                        .scaledToFill()
                        .frame(width: 100, height: 60)
                    
                    VStack(alignment: .leading) {
                        Text(self.placeList.name)
                            .font(.system(size: 18))
                            .bold()
                        Text("by \(self.placeList.owner.username)")
                            .font(.system(size: 12))
                        
                    }
                    .padding(.trailing)
                }
                .frame(width: geo.size.width, height: 60, alignment: .leading)
                .background(Color("elevation-1"))
                .mask(Rectangle().cornerRadius(15))
                .shadow(radius: 5, y: 4)
                
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        if (!self.placeList.isPublic) {
                            HStack {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 10)
                            }
                            .frame(width: 18, height: 18)
                            .background(Color("bg-placeholder"))
                            .mask(Circle())
                        }
                        
                        if (self.placeList.isCollaborative) {
                            HStack {
                                Image(systemName: "person.2.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10)
                            }
                            .frame(width: 18, height: 18)
                            .background(Color("bg-placeholder"))
                            .mask(Circle())
                        }
                    }.padding(.trailing)
                    .padding(.bottom, 10)
                    
                }.frame(width: geo.size.width, height: 60, alignment: .trailing)
            }
            
        }.frame(height: 60)
    }
    
}
