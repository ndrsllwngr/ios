//
//  PlaceListSettings.swift
//  SpotUp
//
//  Created by Fangli Lu on 20.12.19.
//

import SwiftUI

struct PlaceListSettingsSheet: View {
    @EnvironmentObject var firestorePlaceList: FirestorePlaceList
    
    @Binding var presentationMode: PresentationMode

    @Binding var showSheet: Bool
    @State private var newListName: String = ""
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(self.firestorePlaceList.placeList.name)
            Spacer()
            HStack {
                TextField(self.firestorePlaceList.placeList.name, text: $newListName)
                Spacer()
                Button(action: {
                    FirestoreConnection.shared.updatePlaceList(placeListId: self.firestorePlaceList.placeList.id, newName: self.newListName)
                    // ToDo also close on background tap
                    UIApplication.shared.endEditing(true)
                }) {
                    Text("Change Name")
                }
            }
            if (self.firestorePlaceList.placeList.isPublic) {
                Button(action: {
                    FirestoreConnection.shared.updatePlaceList(placeListId: self.firestorePlaceList.placeList.id, isPublic: false)
                }) {
                    HStack {
                        Image(systemName: "lock.circle.fill")
                        Text("Make private PlaceList")
                    }
                }
            } else if (!self.firestorePlaceList.placeList.isPublic) {
                Button(action: {
                    FirestoreConnection.shared.updatePlaceList(placeListId: self.firestorePlaceList.placeList.id, isPublic: true)
                }) {
                    HStack {
                        Image(systemName: "globe")
                        Text("Make public PlaceList")
                    }
                }
            }
            if (!self.firestorePlaceList.placeList.isCollaborative) {
                Button(action: {
                    FirestoreConnection.shared.updatePlaceList(placeListId: self.firestorePlaceList.placeList.id, isCollaborative: true)
                }) {
                    HStack {
                        Image(systemName: "person.3.fill")
                        Text("Make collaborative PlaceList")
                    }
                }
            } else if (self.firestorePlaceList.placeList.isCollaborative) {
                Button(action: {
                    FirestoreConnection.shared.updatePlaceList(placeListId: self.firestorePlaceList.placeList.id, isCollaborative: false)
                }) {
                    HStack {
                        Image(systemName: "person.fill")
                        Text("Make non collaborative PlaceList")
                    }
                }
            }
            Button(action: {
                self.showSheet.toggle()
                self.$presentationMode.wrappedValue.dismiss()
                FirestoreConnection.shared.deletePlaceList(placeListToDelete: self.firestorePlaceList.placeList)
            }) {
                Text("Delete PlaceList")
            }
            Spacer()
            Button(action: {
                self.showSheet.toggle()
            }) {
                Text("Close Sheet")
            }
        }.onAppear {
            self.newListName = self.firestorePlaceList.placeList.name
        }
        .padding()
    }
}

struct PlaceMenuSheet: View {
    var placeListId: String
    var gmsPlaceWithTimeStamp: GMSPlaceWithTimestamp
    
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack {
            Text("Place Menu")
            Button(action: {
                self.showSheet.toggle()
                FirestoreConnection.shared.deletePlaceFromList(placeListId: self.placeListId, place: self.gmsPlaceWithTimeStamp)
            }) {
                Text("Delete Place")
            }
            Button(action: {
                print("ToDo Add Place to PlaceList")
            }) {
                Text("Add to Placelist")
            }
        }
    .padding()
    }
}
//struct ListSettings_Previews: PreviewProvider {
//    static var previews: some View {
//        ListSettings(placeList: placeList)
//    }
//}
