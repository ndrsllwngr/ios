import SwiftUI
import GooglePlaces

struct HomeView: View {
    @ObservedObject var searchViewModel = SearchViewModel()
    @State private var showCancelButton: Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
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
                                
                                TextField("Search", text: $searchViewModel.searchTerm, onEditingChanged: { isEditing in
                                    self.showCancelButton = true
                                }, onCommit: {
                                    print("onCommit")
                                }).foregroundColor(.primary)
                                
                                Button(action: {
                                    self.resetSearchTerm()
                                }) {
                                    Image(systemName: "xmark.circle.fill").opacity(searchViewModel.searchTerm == "" ? 0.0 : 1.0)
                                }
                            }
                            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                            .foregroundColor(.secondary)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10.0)
                            
                            if showCancelButton  {
                                Button("Cancel") {
                                    // this must be placed before the other commands here
                                    UIApplication.shared.endEditing(true)
                                    self.resetSearchTerm()
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
                    Picker(selection: $searchViewModel.searchSpaceSelection, label: Text("View")) {
                        Text("Places").tag("places")
                        Text("Lists").tag("lists")
                        Text("Accounts").tag("accounts")
                        
                    }
                    .padding()
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Spacer()
                    
                    // RESULTS
                    VStack {
                        if searchViewModel.searchSpaceSelection == SearchViewModel.SearchSpace.googlePlaces.rawValue {
                            SearchResultsGooglePlacesView()
                                .environmentObject(self.searchViewModel)
                                .resignKeyboardOnDragGesture()
                            Spacer()
                        }
                        else if searchViewModel.searchSpaceSelection == SearchViewModel.SearchSpace.firebaseLists.rawValue {
                            SearchResultsPlaceListsView()
                                .environmentObject(self.searchViewModel)
                                .resignKeyboardOnDragGesture()
                            Spacer()
                        }
                        else if searchViewModel.searchSpaceSelection == SearchViewModel.SearchSpace.firebaseAccounts.rawValue {
                            SearchResultsAccountsView()
                                .environmentObject(self.searchViewModel)
                                .resignKeyboardOnDragGesture()
                            Spacer()
                        }
                    } .navigationBarTitle(Text("Search"))
                }
                .onAppear {
                    print("HomeView ON APPEAR")
                    self.searchSpace.addAllPublicPlaceListsListener()
                    self.searchSpace.addAllUsersListener()
                }
                .onDisappear {
                    print("HomeView ON DISAPPEAR")
                    self.searchSpace.removeAllUsersListener()
                    self.searchSpace.removeAllPublicPlaceListsListener()
                }
            }
        }
    }
    
    func resetSearchTerm() {
        self.searchViewModel.searchTerm = ""
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

