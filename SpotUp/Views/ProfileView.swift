//
//  ProfileView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    @EnvironmentObject var firebaseAuthentication: FirebaseAuthentication
    @ObservedObject var profile = FirestoreProfile()
    @State private var showingChildView = false
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text(self.profile.user != nil ? "\(self.profile.user!.username)" : "")
                VStack {
                    Button(action: {
                        self.showSheet.toggle()
                    }) {
                        Text("Create new place list")
                    }
                }.popover(
                    isPresented: $showSheet,
                    arrowEdge: .bottom) {
                        ModalView(showSheet: self.$showSheet).environmentObject(self.firebaseAuthentication)
                }
                List {
                    ForEach(profile.placeLists) { placeList in
                        VStack {
                            NavigationLink(
                                destination: ListView(placeList: placeList)
                            ) {
                                ListRow(placeList: placeList)
                            }
                        }
                    }
                    NavigationLink(destination: SettingsView(),
                                   isActive: self.$showingChildView)
                    { EmptyView() }
                        .frame(width: 0, height: 0)
                        .disabled(true)
                        .navigationBarTitle(Text("ProfileView"))
                        .navigationBarItems(
                            trailing: Button(action:{ self.showingChildView = true }) { Image(systemName: "gear") }
                    )
                }
            }
        }.onAppear {
            self.profile.addProfileListener(currentUserId: self.firebaseAuthentication.currentUser!.uid)
        }.onDisappear {
            self.profile.removeProfileListener()
        }
    }
}


struct ModalView: View {
    @EnvironmentObject var firebaseAuthentication: FirebaseAuthentication
    @Binding var showSheet: Bool
    
    @State private var text: String = ""
    var body: some View {
        VStack {
            Text("Enter name for new placeList")
            TextField("PlaceList name", text: $text)
            HStack {
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    Text("Cancel")
                }
                Divider()
                Button(action: {
                    createPlaceList(currentUserId: self.firebaseAuthentication.currentUser!.uid, listName: self.text)
                    self.showSheet.toggle()
                }) {
                    Text("Create")
                }
            }
            
        }
    }
}
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
