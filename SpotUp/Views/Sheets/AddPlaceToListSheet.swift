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
    var placeImage: UIImage?
    
    @State var placeLists: [PlaceList] = []
    
    @Binding var showSheet: Bool
    
    @ObservedObject var firebaseAuthentication = FirebaseAuthentication.shared
    
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 30, height: 3)
                .padding(10)
            List {
                Text("Add to collection").font(.system(size:18)).fontWeight(.bold)
                ForEach(self.placeLists.filter{ $0.owner.id == self.firebaseAuthentication.currentUser!.uid || $0.isCollaborative}){ placeList in
                    PlaceListRow(placeList: placeList)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            FirestoreConnection.shared.addPlaceToList(placeList: placeList, placeId: self.place.placeID!, placeImage: self.placeImage)
                            self.showSheet.toggle()
                    }
                }
            }
            .padding()
            Spacer()
        }
        .onAppear {
            self.placeLists = []
            let query = FirestoreConnection.shared.getPlaceListsRef().whereField("follower_ids", arrayContains: self.firebaseAuthentication.currentUser!.uid)
            query.getDocuments { querySnapshot, error in
                guard let querySnapshot = querySnapshot else {
                    print("Error retrieving Lists")
                    return
                }
                self.placeLists = querySnapshot.documents.map { (documentSnapshot) in
                    let data = documentSnapshot.data()
                    return dataToPlaceList(data: data)
                }
                for (i, placeList) in self.placeLists.enumerated() {
                    // Listener for owners of these lists (basically myself)
                    FirestoreConnection.shared.getUsersRef().document(placeList.owner.id).getDocument { documentSnapshot, error in
                        guard let documentSnapshot = documentSnapshot else {
                            print("Error retrieving user")
                            return
                        }
                        documentSnapshot.data().flatMap({ data in
                            let username = data["username"] as! String
                            if self.placeLists.count > i {
                                self.placeLists[i].owner.username = username
                            }
                        })
                    }
                }
            }
        }
    }
}
//
//struct AddPlaceToListSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPlaceToListSheet()
//    }
//}
