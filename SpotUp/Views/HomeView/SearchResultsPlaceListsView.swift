import SwiftUI

struct SearchResultsPlaceListsView: View {
    @Binding var tabSelection: Int

    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        Group {
            if self.searchViewModel.searchTerm == "" {
                if (self.searchViewModel.recentSearchFirebaseLists.count > 0) {
                    List {
                        Section(header: Text("Recent")) {
                            ForEach(searchViewModel.recentSearchFirebaseLists) {
                                (placeList: PlaceList) in SingleRowPlaceList(placeList: placeList, tabSelection: self.$tabSelection, showRecent: true).environmentObject(self.searchViewModel)
                            }
                            Spacer()
                        }
                    }
                }
                else {
                    SearchResultsListsEmptyStateView()
                }
            } else {
                List { ForEach(searchViewModel.firestoreSearch.allPublicPlaceLists.filter{searchViewModel.searchTerm.isEmpty ? false : $0.name.localizedCaseInsensitiveContains(searchViewModel.searchTerm)}) { (placeList: PlaceList) in
                    SingleRowPlaceList(placeList: placeList, tabSelection: self.$tabSelection).environmentObject(self.searchViewModel)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct SingleRowPlaceList: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    var placeList: PlaceList
    
    @Binding var tabSelection: Int

    
    @State var showRecent: Bool = false
    @State var selection: Int? = nil
    @State var goToDestination: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {
                if(self.searchViewModel.recentSearchFirebaseLists.count == 0) {
                    self.searchViewModel.recentSearchFirebaseLists.append(self.placeList)
                } else if (!self.searchViewModel.recentSearchFirebaseLists.contains(self.placeList)) {
                    self.searchViewModel.recentSearchFirebaseLists.insert(self.placeList, at: 0)
                    if(self.searchViewModel.recentSearchFirebaseLists.count > 5) {
                        self.searchViewModel.recentSearchFirebaseLists = Array(self.searchViewModel.recentSearchFirebaseLists.prefix(5))
                    }
                    
                }
                self.goToDestination = true
                self.selection = 1
            }){
                HStack {
                    Text(placeList.name)
                    Spacer()
                }
            }.padding(.leading)
            Spacer()
            //            if showRecent == true {
            //                Group{
            //                    Button(action: {
            //                        print("delete invoked")
            //                        let indexOfToBeDeletedEntry = self.searchViewModel.recentSearchFirebaseLists.firstIndex(of: self.placeList)
            //                        if(indexOfToBeDeletedEntry != nil) {
            //                            self.searchViewModel.recentSearchFirebaseLists.remove(at: indexOfToBeDeletedEntry!)
            //                        }
            //                    }) { Image(systemName: "xmark")}
            //                }
            //                .padding(.trailing)
            //            }
            if (self.goToDestination != false) {
                NavigationLink(destination: PlaceListView(placeListId: placeList.id, tabSelection: $tabSelection), tag: 1, selection: $selection) {
                    EmptyView()
                    
                }
            }
        }
    }
}

//struct SearchResultsPlaceListsView: PreviewProvider {
//    static var previews: some View {
//        SearchResultsPlaceListsView()
//    }
//}

