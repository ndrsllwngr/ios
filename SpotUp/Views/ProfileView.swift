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
    @EnvironmentObject var session: FirebaseAuthentication
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
                        Text("Create new location list")
                    }
                }.popover(
                    isPresented: $showSheet,
                    arrowEdge: .bottom) {
                        ModalView(showSheet: self.$showSheet).environmentObject(self.session)
                }
                List {
                    ForEach(profile.locationLists) { locationList in
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
                    self.profile.addProfileListener(currentUserId: self.session.currentUser!.uid)
                }.onDisappear {
                    self.profile.removeProfileListener()
                }
            }
            
            
        }
    }
}


struct ModalView: View {
    @EnvironmentObject var session: FirebaseAuthentication
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
