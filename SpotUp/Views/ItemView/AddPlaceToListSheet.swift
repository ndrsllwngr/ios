//
//  AddPlaceToListSheet.swift
//  SpotUp
//
//  Created by Timo Erdelt on 07.01.20.
//

import SwiftUI
import FirebaseFirestore

struct AddPlaceToListSheet: View {
    var placeId: String
    @Binding var placeImage: UIImage?
    @Binding var showSheet: Bool

    
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject var profile = FirestoreProfile()



    
    var body: some View {
        VStack {
            ForEach(profile.placeLists.filter{ $0.owner.id == firebaseAuthentication.currentUser?.uid || $0.isCollaborative}){ placeList in
                Button(action: {
                    FirestoreConnection.shared.addPlaceToList(placeList: placeList, placeId: self.placeId, placeImage: self.placeImage)
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
