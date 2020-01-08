//
//  PlaceListSettings.swift
//  SpotUp
//
//  Created by Fangli Lu on 20.12.19.
//

import SwiftUI

struct PlaceListSettings: View {
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    @Binding var showSheet: Bool
    @State private var newListName: String = ""
    
    var body: some View {
        VStack {
            Text("Edit List")
            Spacer()
            if self.firestorePlaceList.placeList == nil {
                Text("Loading")
            } else {
                TextField(self.firestorePlaceList.placeList!.name, text: $newListName)
                HStack {
                    Button(action: {
                        self.showSheet.toggle()
                    }) {
                        Text("cancel")
                    }
                    Spacer()
                    Button(action: {
                        updatePlaceList(placeListId: self.firestorePlaceList.placeList!.id, newName: self.newListName)
                        self.showSheet.toggle()
                    }) {
                        Text("save")
                    }
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
