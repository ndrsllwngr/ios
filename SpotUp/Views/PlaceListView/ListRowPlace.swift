//
//  ListComponent.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct ListRowPlace: View {
    var place: Place
    
    var body: some View{
        HStack {
            place.image
                .resizable()
                .frame(width:50, height:50)
            Text(place.name)
        }
    }
}

struct ListComponent_Previews: PreviewProvider {
    static var previews:some View{
        Group {
            ListRowPlace(place: placeData[0])
            ListRowPlace(place: placeData[1])
                
        }
          .previewLayout(.fixed(width: 300, height: 70))
    }
}
