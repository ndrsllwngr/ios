//
//  ItemImageView.swift
//  SpotUp
//
//  Created by Havy Ha on 05.12.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct ItemImageView: View {
    var body: some View {
        Image("turtlerock")
            .resizable()
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
        
        
    }
}

struct ItemImageView_Previews: PreviewProvider {
    static var previews: some View {
        ItemImageView()
    }
}
