//
//  AddPlaceToListSheet.swift
//  SpotUp
//
//  Created by Timo Erdelt on 07.01.20.
//

import SwiftUI
import FirebaseFirestore
import GooglePlaces

struct AddPlaceToListSheet: View {
    
    var place: GMSPlace
    
    @Binding var placeImage: UIImage?
    @Binding var showSheet: Bool
    
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    @ObservedObject var profile: FirestoreProfile
    
    init(place: GMSPlace, placeImage: Binding<UIImage?>, showSheet: Binding<Bool>) {
        self.place = place
        self._placeImage = placeImage
        self._showSheet = showSheet
        self.profile = FirestoreProfile(profileUserId: FirebaseAuthentication.shared.currentUser!.uid)
    }
    
    var body: some View {
        VStack {
            Text("Welcher Liste möchstest du \(place.name!) hinzufügen?")
            List {
                ForEach(profile.placeLists.filter{ $0.owner.id == firebaseAuthentication.currentUser?.uid || $0.isCollaborative}){ placeList in
                    Button(action: {
                        FirestoreConnection.shared.addPlaceToList(placeList: placeList, placeId: self.place.placeID!, placeImage: self.placeImage)
                        self.showSheet.toggle()
                    }) {
                        PlacesListRow(placeList: placeList)
                    }
                }
            }
        }
        .onAppear {
            self.profile.addProfileListener(currentUserId: self.firebaseAuthentication.currentUser!.uid)
        }
        .onDisappear {
            self.profile.removeProfileListener()
        }
    .padding()
    }
}
//
//struct AddPlaceToListSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPlaceToListSheet()
//    }
//}
