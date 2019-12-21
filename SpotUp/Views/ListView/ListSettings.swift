//
//  ListSettings.swift
//  SpotUp
//
//  Created by Fangli Lu on 20.12.19.
//

import SwiftUI

struct ListSettings: View {
    var placeList: PlaceList
    @Binding var showSheet: Bool
    @State private var newListName: String = ""
    
    var body: some View {
        VStack {
            Text("Edit List")
            Spacer()
            TextField(self.placeList.name, text: $newListName)
            HStack {
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    Text("cancel")
                }
                Spacer()
                Button(action: {
                    updatePlaceList(placeListId: self.placeList.id, newName: self.newListName)
                    self.showSheet.toggle()
                }) {
                    Text("save")
                }
            }
            Spacer()
        }
    }
}

//struct ListSettings_Previews: PreviewProvider {
//    static var previews: some View {
//        ListSettings(placeList: placeList)
//    }
//}
