//
//  PlaceList.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import Foundation

struct PlaceList: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var owner: ListOwner
    var followerIds: [String] // the owner is also always a follower
    var isPublic: Bool = true
    var placeIds: [String] = []
    var isCollaborative: Bool = false // only possible if private
    var modifiedAt: NSDate
    var createdAt: NSDate
    //var titleImage: String
    //var location: String
    //var tags: [UUID]
}
