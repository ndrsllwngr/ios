import SwiftUI

struct SearchResultsPlaceListsView: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        Group {
            if self.searchViewModel.searchTerm == "" {
                if (self.searchViewModel.recentSearchFirebaseLists.count > 0) {
                    ScrollView(.vertical, showsIndicators: true) { Text("Recent").padding(.leading)
                        ForEach(searchViewModel.recentSearchFirebaseLists, id: \.self.id) {
                            (placeList: PlaceList) in SingleRowPlaceList(placeList: placeList, showRecent: true).environmentObject(self.searchViewModel)
                        }
                        Spacer()
                        }
                    
                }
                else {
                    SearchResultsEmptyStateView()
                }
            } else {
                ScrollView(.vertical, showsIndicators: true) { ForEach(searchViewModel.firestoreSearch.allPublicPlaceLists.filter{searchViewModel.searchTerm.isEmpty ? false : $0.name.localizedCaseInsensitiveContains(searchViewModel.searchTerm)}) {
                    (placeList: PlaceList) in SingleRowPlaceList(placeList: placeList).environmentObject(self.searchViewModel)
                    }
                    Spacer()
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        self.searchViewModel.recentSearchFirebaseLists.remove(atOffsets: offsets)
    }
}

struct SingleRowPlaceList: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    @ObservedObject var firestorePlaceList = FirestorePlaceList()
    @State var placeList: PlaceList
    
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
            if showRecent == true {
                Group{
                    Button(action: {
                        print("delete invoked")
                        let indexOfToBeDeletedEntry = self.searchViewModel.recentSearchFirebaseLists.firstIndex(of: self.placeList)
                        if(indexOfToBeDeletedEntry != nil) {
                            self.searchViewModel.recentSearchFirebaseLists.remove(at: indexOfToBeDeletedEntry!)
                        }
                    }) { Image(systemName: "xmark")}
                }
                    .padding(.trailing)
            }
            if (self.goToDestination != false) {
                NavigationLink(destination: PlaceListView(placeListId: placeList.id, placeListName: placeList.name, isOwnedPlacelist: false).environmentObject(self.firestorePlaceList), tag: 1, selection: $selection) { EmptyView() }
            }
        }
    }
}

//struct SearchResultsPlaceListsView: PreviewProvider {
//    static var previews: some View {
//        SearchResultsPlaceListsView()
//    }
//}

