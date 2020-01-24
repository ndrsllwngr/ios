//
//  ProfileSheets.swift
//  SpotUp
//
//  Created by Timo Erdelt on 17.12.19.
//

import SwiftUI
import FirebaseFirestore

struct CreatePlacelistSheet: View {
    var user: User
    @Binding var showSheet: Bool
    
    @ObservedObject private var createPlacelistViewModel = CreatePlacelistViewModel()
    
//    @State private var placeListName: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Enter a name for your placelist")
            Spacer()
            TextField("Name", text: $createPlacelistViewModel.placelistName).autocapitalization(.none)
            Text(createPlacelistViewModel.placelistNameMessage).foregroundColor(.red)
            HStack {
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: {
                    let newPlaceList = PlaceList(name: self.createPlacelistViewModel.placelistName, owner: self.user.toListOwner(), followerIds: [self.user.id], createdAt:Timestamp())
                    FirestoreConnection.shared.createPlaceList(placeList: newPlaceList)
                    self.showSheet.toggle()
                }) {
                    Text("Create")
                }.disabled(!self.createPlacelistViewModel.isValidplacelist)
            }
            .frame(width: 300, height: 100)
            Spacer()
        }
        .padding()
    }
}
