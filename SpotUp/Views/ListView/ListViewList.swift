//
//  ListViewList.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI

struct ListViewList: View {
        var body: some View {
                NavigationView {
                    List(locationData) { location in
                        ListComponent(location : location)
                    }
                    .navigationBarTitle(Text("Spots"))
                }
            }
        }


struct ListViewList_Previews: PreviewProvider {
    static var previews: some View {
        ListViewList()
    }
}