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
    @ObservedObject var searchSpace = FirestoreSearch()
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
                    
                    TextField("Search \(selection)", text: $searchTerm)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Picker(selection: $selection, label: Text("View")) {
                        Text("Places").tag("places")
                        Text("Lists").tag("lists")
                        Text("Accounts").tag("accounts")
                        
                    }
                    .padding()
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Spacer()
                    
                    if selection == "places" {
                        VStack{
                            Button(action: {self.GSM()}){Text("PUSH")}
                            List{
                                ForEach(self.googlePlaces, id: \.placeID) {
                                    place in Text("\(place.placeID)")
                                }
                            }
                            Spacer()
                        }
                        
                    } else if selection == "lists" {
                        VStack{
                            List{
                                ForEach(self.searchSpace.allPublicPlaceLists.filter{self.searchTerm.isEmpty ? false : $0.name.localizedCaseInsensitiveContains(self.searchTerm)}) {
                                    (placeList: PlaceList) in NavigationLink(destination: PlaceListView(placeList: placeList, isOwnedPlacelist: false)){Text(placeList.name)}
                                }
                            }
                            
                            Spacer()
                        }
                    } else {
                        VStack{
                            List{
                                ForEach(self.searchSpace.allUsers.filter{self.searchTerm.isEmpty ? false : $0.username.localizedCaseInsensitiveContains(self.searchTerm)}) {
                                    (user: User) in NavigationLink(destination: ProfileView(isMyProfile: false, profileUserId: user.id)){Text(user.username)}
                                }
                            }
                            
                            Spacer()
                        }
                    }
                }
                .navigationBarTitle(Text("Search"))
                
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
    
    func GSM() {
        self.filter.type = .establishment
        
        placesClient.findAutocompletePredictions(fromQuery: self.searchTerm,
                                                 bounds: nil,
                                                 boundsMode: GMSAutocompleteBoundsMode.bias,
                                                 filter: filter,
                                                 sessionToken: token,
                                                 callback: { (results, error) in
                                                    if let error = error {
                                                        print("Autocomplete error: \(error)")
                                                        return
                                                    }
                                                    if let results = results {
                                                        for result in results {
                                                            print("Result \(result.attributedFullText) with placeID \(result.placeID) and distance \(result.distanceMeters)")
                                                        }
                                                        self.googlePlaces = results
                                                    }
        })
        
        //        let regularFont = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        //        let boldFont = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        
        //        let bolded = prediction.attributedFullText.mutableCopy() as! NSMutableAttributedString
        //        bolded.enumerateAttribute(kGMSAutocompleteMatchAttribute, in: NSMakeRange(0, bolded.length), options: []) {
        //          (value, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
        //            let font = (value == nil) ? regularFont : boldFont
        //            bolded.addAttribute(NSFontAttributeName, value: font, range: range)
        //        }
        //
        //        label.attributedText = bolded
    }
    
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


