//
//  ItemImageView.swift
//  SpotUp
//
//  Created by Havy Ha on 05.12.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct ItemImageView: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .resizable()
        .clipShape(Rectangle())
    }
}

