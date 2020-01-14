//
//  AddPlaceToListSheet.swift
//  SpotUp
//
//  Created by Timo Erdelt on 07.01.20.
//

import SwiftUI
import FirebaseFirestore

struct AddPlaceToListSheet: View {
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject var profile = FirestoreProfile()
    @Binding var showSheet: Bool
    var placeID: String
    
    var body: some View {
        VStack {
            ForEach(profile.placeLists.filter{ $0.owner.id == firebaseAuthentication.currentUser?.uid || $0.isCollaborative}){ placeList in
                Button(action: {
                    FirestoreConnection.shared.addPlaceToList(placeIDtime: PlaceIDWithTimestamp(placeId: self.placeID, addedAt:Timestamp()), placeListId: placeList.id)
                    self.showSheet.toggle()
                }) {
                    PlacesListRow(placeList: placeList)
                }
            }

        }
        .onAppear {
            self.profile.addProfileListener(currentUserId: self.firebaseAuthentication.currentUser!.uid, isMyProfile: true)
        }
        .onDisappear {
            self.profile.removeProfileListener()
        }
    }
}
//
//struct AddPlaceToListSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPlaceToListSheet()
//    }
//}
