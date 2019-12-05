//
//  ListComponent.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct ListComponent: View {
    var location: Location
    
    var body: some View{
        HStack {
            location.image
                .resizable()
                .frame(width:50, height:50)
            Text(location.name)
        }
        
    }
}

struct ListComponent_Previews: PreviewProvider {
    static var previews:some View{
    Group {
        ListComponent(location: locationData[0])
        ListComponent(location: locationData[1])
            
    }
          .previewLayout(.fixed(width: 300, height: 70))
}
}
