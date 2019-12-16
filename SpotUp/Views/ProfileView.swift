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
    @State var showSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    GeometryReader {geometry in
                        ProfileInfoView(showSheet: self.$showSheet).environmentObject(self.profile)
                            .offset(y: geometry.frame(in: .global).minY > 0 ? -geometry.frame(in: .global).minY : 0)
                    }
                    .frame(height: 300)
                    VStack(spacing: 5) {
                        ForEach(profile.placeLists) { placeList in
                                NavigationLink(
                                    destination: ListView(placeList: placeList)
                                ) {
                                    ListRow(placeList: placeList)
                                }
                        }.onDelete(perform: delete)
                    }
                    Spacer()
                }
            }
            .popover(
                isPresented: $showSheet,
                arrowEdge: .bottom) {
                    ModalView(showSheet: self.$showSheet).environmentObject(self.firebaseAuthentication)
            }
            .navigationBarTitle(Text(self.profile.user != nil ? "\(self.profile.user!.username)" : ""), displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: SettingsView()){
                Image(systemName: "gear")
            })
        }
        .onAppear {
            self.profile.addProfileListener(currentUserId: self.firebaseAuthentication.currentUser!.uid)
        }
        .onDisappear {
            self.profile.removeProfileListener()
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach {index in
            let placeListToDelete = profile.placeLists[index]
            deletePlaceList(currentUserId: firebaseAuthentication.currentUser!.uid, placeListId: placeListToDelete.id)
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

struct ProfileInfoView: View {
    @EnvironmentObject var profile: FirestoreProfile
    @Binding var showSheet: Bool

    var body: some View {
        VStack {
            Spacer()
            Image("profile")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            HStack {
                VStack{
                    Text("\(self.profile.placeLists.count)")
                    Text("Placelists")
                }
                Spacer()
                VStack{
                    Text("1")
                    Text("Follower")
                }
                Spacer()
                VStack{
                    Text("1000")
                    Text("Following")
                }
            }
            .padding(.horizontal)
            Divider()
            Button(action: {
                self.showSheet.toggle()
            }) {
                Text("Create new place list")
            }
        }
    }
}
