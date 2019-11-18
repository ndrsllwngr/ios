//
//  Location.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import Foundation

struct Location: Identifiable {
    var id = UUID()
    var appleMapsId: String
    var name: String
}
