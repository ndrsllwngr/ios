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
    var gmsPlaceWithTimestamp: GMSPlaceWithTimestamp
    @Binding var image: UIImage?
    
    @Binding var showSheet: Bool
    
    @State var showAddPlaceToListSheet: Bool = false
    
    var body: some View {
        VStack {
            Text("Place Menu")
            Button(action: {
                self.showSheet.toggle()
                FirestoreConnection.shared.deletePlaceFromList(placeListId: self.placeListId, place: self.gmsPlaceWithTimestamp)
            }) {
                Text("Delete Place from List")
            }.padding()
            Button(action: {
                self.showAddPlaceToListSheet.toggle()
            }) {
                Text("Add to Placelist")
            }.padding()
            Button(action: {
                ExploreModel.shared.addPlaceToExplore(self.gmsPlaceWithTimestamp.gmsPlace)
                self.showSheet.toggle()
                
            }) {
                Text("Add to Explore")
            }.padding()
        }
        .sheet(isPresented: $showAddPlaceToListSheet) {
            AddPlaceToListSheet(place: self.gmsPlaceWithTimestamp.gmsPlace, placeImage: self.$image, showSheet: self.$showAddPlaceToListSheet)
        }
        .padding()
    }
}
//struct ListSettings_Previews: PreviewProvider {
//    static var previews: some View {
//        ListSettings(placeList: placeList)
//    }
//}
