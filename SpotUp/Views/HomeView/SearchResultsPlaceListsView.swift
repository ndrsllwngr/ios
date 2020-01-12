import SwiftUI

struct SearchResultsPlaceListsView: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        Group {
            if self.searchViewModel.searchTerm == "" {
                if (self.searchViewModel.recentSearchFirebaseLists.count > 0) {
                    List { Section(header: Text("Recent")){
                        ForEach(searchViewModel.recentSearchFirebaseLists, id: \.self.id) {
                            (placeList: PlaceList) in SingleRowPlaceList(placeList: placeList).environmentObject(self.searchViewModel)
                        }.onDelete(perform: delete)
                        Spacer()
                        }
                    }
                    
                }
                else {
                    SearchResultsEmptyStateView()
                }
            } else {
                List { ForEach(searchViewModel.firestoreSearch.allPublicPlaceLists.filter{searchViewModel.searchTerm.isEmpty ? false : $0.name.localizedCaseInsensitiveContains(searchViewModel.searchTerm)}) {
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
    @State var presentMe: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {
                if(self.searchViewModel.recentSearchFirebaseLists.count == 0) {
                    self.searchViewModel.recentSearchFirebaseLists.append(self.placeList)
                } else if (!self.searchViewModel.recentSearchFirebaseLists.contains(self.placeList)) {
                    self.searchViewModel.recentSearchFirebaseLists.insert(self.placeList, at: 0)
                }
                self.presentMe = true
            }, label: {
                Text(placeList.name)
            })
            NavigationLink(destination: PlaceListView(placeListId: placeList.id), isActive: self.$presentMe){ EmptyView() }
        }
    }
}

//struct SearchResultsPlaceListsView: PreviewProvider {
//    static var previews: some View {
//        SearchResultsPlaceListsView()
//    }
//}

