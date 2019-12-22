//
//  ItemContentView.swift
//  SpotUp
//
//  Created by Havy Ha on 02.12.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct ItemContentView: View {
    var place: Place
    
    var body: some View {
        
        VStack {
            ItemMapView(coordinate: place.placeCoordinate)
                .edgesIgnoringSafeArea(.top)
                .frame(height:400)
            
            HStack {
                ItemImageView(image: place.image)
                    .frame(width:200,height:200)
                    .offset(y:-90)
                    .padding(.bottom,-90)
                Button(action: {print ("Test")}) {
                    Text("Add to List")
                }
            }
            
            
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.title)
                HStack {
                    Text(place.park)
                        .font(.subheadline)
                    Spacer()
                    Text(place.state)
                        .font(.subheadline)
                }
            }
            .padding(.all)
            Spacer()
        }
        .navigationBarTitle(Text(place.name),displayMode:.inline)
    }
    
    func addToList(){
        
    }
}



struct ItemContentView_Previews: PreviewProvider {
    static var previews: some View {
        ItemContentView(place:placeData[0])
    }
}
