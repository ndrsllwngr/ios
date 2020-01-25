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
    @ObservedObject private var placeListSettingsViewModel = PlaceListSettingsViewModel()
    
    var buttonColor: Color {
        return self.placeListSettingsViewModel.isValidplacelist ? Color("brand-color-primary") : Color(.lightGray)
    }
    var body: some View {
        VStack () {
            Capsule()
            .fill(Color.secondary)
            .frame(width: 30, height: 3)
            .padding(10)
            
            Spacer()
            Text(self.firestorePlaceList.placeList.name)
                .fontWeight(.semibold)
                .font(.title)
            
            Spacer()
            
            VStack (alignment: .leading){
                VStack (alignment: .leading){
                    TextField("New Collection Name", text: $placeListSettingsViewModel.placelistName)
                        .autocapitalization(.none)
                        .textFieldStyle(PlainTextFieldStyle())
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(.lightGray))
                        .opacity(0.8)
                    Text(placeListSettingsViewModel.placelistNameMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                    Spacer()
                }.frame(height: 60)
                
                Button(action: {
                    FirestoreConnection.shared.updatePlaceList(placeListId: self.firestorePlaceList.placeList.id, newName: self.placeListSettingsViewModel.placelistName)
                    // ToDo also close on background tap
                    UIApplication.shared.endEditing(true)
                }) {
                    GeometryReader { geo in
                        Text("Change Name")
                            .foregroundColor(self.buttonColor)
                            .frame(width: geo.size.width, height: 40)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(self.buttonColor, lineWidth: 1))
                            .padding(.top, 20)
                    }.frame(height: 40)
                    
                }.disabled(!self.placeListSettingsViewModel.isValidplacelist)
            }.padding(.horizontal)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.lightGray))
                .opacity(0.3)
                .padding(.top, 60)
                .padding(.bottom)
            
            VStack (alignment: .leading){
                if (self.firestorePlaceList.placeList.isPublic) {
                    Button(action: {
                        FirestoreConnection.shared.updatePlaceList(placeListId: self.firestorePlaceList.placeList.id, isPublic: false)
                    }) {
                        SettingsButton(iconName: "lock", description: "Make private")
                    }
                } else if (!self.firestorePlaceList.placeList.isPublic) {
                    Button(action: {
                        FirestoreConnection.shared.updatePlaceList(placeListId: self.firestorePlaceList.placeList.id, isPublic: true)
                    }) {
                        SettingsButton(iconName: "globe", description: "Make public")
                    }
                }
                if (!self.firestorePlaceList.placeList.isCollaborative) {
                    Button(action: {
                        FirestoreConnection.shared.updatePlaceList(placeListId: self.firestorePlaceList.placeList.id, isCollaborative: true)
                    }) {
                        SettingsButton(iconName: "person.2", description: "Make collaborative")
                    }
                } else if (self.firestorePlaceList.placeList.isCollaborative) {
                    Button(action: {
                        FirestoreConnection.shared.updatePlaceList(placeListId: self.firestorePlaceList.placeList.id, isCollaborative: false)
                    }) {
                        SettingsButton(iconName: "person", description: "Make non-collaborative")
                    }
                }
                Button(action: {
                    self.showSheet.toggle()
                    self.$presentationMode.wrappedValue.dismiss()
                    FirestoreConnection.shared.deletePlaceList(placeListToDelete: self.firestorePlaceList.placeList)
                }) {
                    SettingsButton(iconName: "minus.circle", description: "Delete collection")
                        .padding(.bottom, 50)
                }
            }
            
        }.onAppear {
            self.placeListSettingsViewModel.placelistName = self.firestorePlaceList.placeList.name
        }
        .padding(.horizontal)
    }
}

struct SettingsButton: View {
    var iconName: String
    var description: String
    var body: some View {
        HStack {
            VStack {
                Image(systemName: iconName)
                    .foregroundColor(Color("text-primary"))
            }
            .frame(width: 20)
            .padding(.trailing)
            
            Text(description).foregroundColor(Color("text-primary"))
            Spacer()
        }
        .frame(height: 50)
        .padding(.horizontal)
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
                if let image = self.image {
                    FirebaseStorage.shared.uploadImageToStorage(id: self.placeListId, imageType: .PLACELIST_IMAGE, uiImage: image)
                } else {
                    print("Place has no image")
                }
            }) {
                Text("Make photo of place to current place list image")
            }.padding()
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
            AddPlaceToListSheet(place: self.gmsPlaceWithTimestamp.gmsPlace, placeImage: self.image, showSheet: self.$showAddPlaceToListSheet)
        }
        .padding()
    }
}
//struct ListSettings_Previews: PreviewProvider {
//    static var previews: some View {
//        ListSettings(placeList: placeList)
//    }
//}
