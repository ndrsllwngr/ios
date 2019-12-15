//
//  ProfileView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

let lists: [LocationList] = [LocationList(id: "blub", name: "Paris best Spots", ownerId: "bla"), LocationList(id: "blub", name: "Munich Ramen", ownerId: "bla"), LocationList(id: "blub", name:"DummieList", ownerId: "bla")]

struct ProfileView: View {
    @EnvironmentObject var session: FirebaseSession
    @ObservedObject var locationListsForUser = FirestoreProfile()
    @State private var showingChildView = false
    @State private var showSheet = false
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Button(action: {
                        self.showSheet.toggle()
                        //createLocationList()
                    }) {
                        Text("Create new location list")
                    }
                }.popover(
                    isPresented: $showSheet,
                    arrowEdge: .bottom) {
                        ModalView(showSheet: self.$showSheet).environmentObject(self.session)
                }
                List {
                    ForEach(locationListsForUser.locationLists) { locationList in
                        NavigationLink(
                            destination: ListView(locationList: locationList)
                        ) {
                            ListRow(locationList: locationList)
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
                }.onAppear {
                    self.locationListsForUser.addProfileListener(currentUserId: self.session.currentUser!.uid)
                }.onDisappear {
                    self.locationListsForUser.removeProfileListener()
                }
            }
            
            
        }
    }
}


struct ModalView: View {
    @EnvironmentObject var session: FirebaseSession
    @Binding var showSheet: Bool
    
    @State private var text: String = ""
    var body: some View {
        VStack {
            Text("Enter name for new locationList")
            TextField("LocationList name", text: $text)
            HStack {
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    Text("Cancel")
                }
                Divider()
                Button(action: {
                    createLocationList(currentUserId: self.session.currentUser!.uid, listName: self.text)
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
