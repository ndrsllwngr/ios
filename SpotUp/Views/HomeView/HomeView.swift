//
//  HomeView.swift
//  SpotUp
//
//  Created by Timo Erdelt on 18.11.19.
//  Copyright © 2019 iOS WiSe 19/20 Gruppe 7. All rights reserved.
//

import SwiftUI
import GooglePlaces

struct HomeView: View {
    @State private var selection = "places"
    @State private var searchTerm: String = ""
    @State private var showCancelButton: Bool = false
    @ObservedObject var searchSpace = FirestoreSearch()
    @ObservedObject var firestorePlaceList = FirestorePlaceList()
    let searchController = UISearchController(searchResultsController: nil)
    @State private var googlePlaces: [GMSAutocompletePrediction] = []
    
    
    /**
     * Create a new session token. Be sure to use the same token for calling
     * findAutocompletePredictions, as well as the subsequent place details request.
     * This ensures that the user's query and selection are billed as a single session.
     */
    let token = GMSAutocompleteSessionToken.init()
    // Create a type filter.
    let filter = GMSAutocompleteFilter()
    
    var body: some View {
        
        VStack {
            NavigationView {
                VStack {
                    // SEARCHBAR
                    HStack {
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .padding(.leading, 5.0)
                                
                                TextField("Search", text: $searchTerm, onEditingChanged: { isEditing in
                                    self.showCancelButton = true
                                }, onCommit: {
                                    print("onCommit")
                                }).foregroundColor(.primary)
                                
                                Button(action: {
                                    self.searchTerm = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill").opacity(searchTerm == "" ? 0 : 1)
                                }
                            }
                            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                            .foregroundColor(.secondary)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10.0)
                            
                            if showCancelButton  {
                                Button("Cancel") {
                                    UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                                    self.searchTerm = ""
                                    self.showCancelButton = false
                                }
                                .foregroundColor(Color(.systemBlue))
                            }
                        }
                        .padding(.horizontal)
                            .navigationBarHidden(showCancelButton) // .animation(.default)
                        // animation does not work properly
                        
                    }
                    // PICKER
                    Picker(selection: $selection, label: Text("View")) {
                        Text("Places").tag("places")
                        Text("Lists").tag("lists")
                        Text("Accounts").tag("accounts")
                        
                    }
                    .padding()
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Spacer()
                    
                    // RESULTS
                    VStack {
                        if selection == "places" {
//                            Button(action: {self.GSM()}){Text("Search Google Places")}
                            //                            GPViewControllerWrapper()
//                            List { ForEach(self.googlePlaces, id: \.placeID) {
//                                result in HStack {
//                                    Text(result.placeID)
//                                    Text(result.attributedFullText.string)
//                                    Spacer()
//                                    }
//                                }
//                                Spacer()
//                            }
                            // WARN! GSM modifies states during render
                            GSM(query: self.searchTerm)
                            ListsResults(googlePlaces: $googlePlaces)
                            .resignKeyboardOnDragGesture()
                            Spacer()
                        };
                        if selection == "lists" {
                            List { ForEach(self.searchSpace.allPublicPlaceLists.filter{self.searchTerm.isEmpty ? false : $0.name.localizedCaseInsensitiveContains(self.searchTerm)}) {
                                (placeList: PlaceList) in NavigationLink(destination: PlaceListView(placeListId: placeList.id, placeListName: placeList.name, isOwnedPlacelist: false).environmentObject(self.firestorePlaceList)){Text(placeList.name)}
                                }
                                Spacer()
                            }.resignKeyboardOnDragGesture()
                            Spacer()
                        };
                        if selection == "accounts" {
                            List { ForEach(self.searchSpace.allUsers.filter{self.searchTerm.isEmpty ? false : $0.username.localizedCaseInsensitiveContains(self.searchTerm)}) {
                                (user: User) in NavigationLink(destination: ProfileView(profileUserId: user.id)){Text(user.username)}
                                }
                                Spacer()
                            }.resignKeyboardOnDragGesture()
                            Spacer()
                        };
                    } .navigationBarTitle(Text("Search"))
                }
            }
        }.onAppear {
            self.searchSpace.getAllPublicPlaceLists()
            self.searchSpace.getAllUsers()
        }
        .onDisappear {
            self.searchSpace.cleanAllPublicPlaceLists()
            self.searchSpace.cleanAllUsers()
        }
    }
    
    func GSM(query: String) -> Text {
        self.filter.type = .establishment
        
        placesClient.findAutocompletePredictions(fromQuery: query,
                                                 bounds: nil,
                                                 boundsMode: GMSAutocompleteBoundsMode.bias,
                                                 filter: self.filter,
                                                 sessionToken: self.token,
                                                 callback: { (results, error) in
                                                    if let error = error {
                                                        print("Autocomplete error: \(error)")
                                                        return
                                                    }
                                                    if let results = results {
                                                        for result in results {
                                                            print("Result \(result.attributedFullText) with placeID \(result.placeID)")
                                                            //dump(result)
                                                        }
                                                        self.googlePlaces = results
                                                    }
        })
        return Text("")
    }
}



//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

