//
//  ListRow.swift
//  SpotUp
//
//  Created by Timo Erdelt on 21.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct ListRow: View {
    var placeList: PlaceList
    
    var body: some View {
        HStack {
            Image("chincoteague")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(placeList.name)
                    .bold()
                Text("von \(placeList.owner.username)")
            }
        }
    }
}

