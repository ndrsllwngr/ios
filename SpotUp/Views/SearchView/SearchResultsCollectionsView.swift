import SwiftUI

struct SearchResultsCollectionsView: View {
    @Binding var tabSelection: Int
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    @State var placeListIdToNavigateTo: String? = nil
    @State var goToPlaceList: Int? = nil
    
    var body: some View {
        VStack {
            if (self.placeListIdToNavigateTo != nil) {
                NavigationLink(destination: PlaceListView(placeListId: self.placeListIdToNavigateTo!, tabSelection: $tabSelection), tag: 1, selection: self.$goToPlaceList) {
                    EmptyView()
                }
            }
            Group {
                if self.searchViewModel.searchTerm == "" {
                    if (self.searchViewModel.recentSearchFirebaseLists.count > 0) {
                        List {
                            Text("Recent")
                                .font(.system(size:18))
                                .fontWeight(.bold)
                            ForEach(searchViewModel.recentSearchFirebaseLists) { (placeList: PlaceList) in
                                SingleRowPlaceList(placeList: placeList,
                                                   showRecent: true,
                                                   tabSelection: self.$tabSelection,
                                                   placeListIdToNavigateTo: self.$placeListIdToNavigateTo,
                                                   goToPlaceList: self.$goToPlaceList).environmentObject(self.searchViewModel)
                            }
                            Spacer()
                        }
                    } else {
                        SearchResultsListsEmptyStateView()
                    }
                } else {
                    List {
                        ForEach(searchViewModel.firestoreSearch.allPublicPlaceLists.filter{searchViewModel.searchTerm.isEmpty ? false : $0.name.localizedCaseInsensitiveContains(searchViewModel.searchTerm)}) { (placeList: PlaceList) in
                            SingleRowPlaceList(placeList: placeList,
                                               tabSelection: self.$tabSelection,
                                               placeListIdToNavigateTo: self.$placeListIdToNavigateTo,
                                               goToPlaceList: self.$goToPlaceList).environmentObject(self.searchViewModel)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct SingleRowPlaceList: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    var placeList: PlaceList
    
    @State var showRecent: Bool = false
    
    @Binding var tabSelection: Int
    @Binding var placeListIdToNavigateTo: String?
    @Binding var goToPlaceList: Int?
    
    var body: some View {
        HStack {
            HStack(alignment: .center) {
                Image(uiImage: UIImage(named: "placeholder-row-collection")!)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42.0, height: 42.0, alignment: .center)
                    .padding(.trailing, 5)
                VStack(alignment: .leading){
                    Text(placeList.name).font(.system(size:18)).fontWeight(.semibold).lineLimit(1)
                    Text("by \(placeList.owner.username)").font(.system(size:12)).lineLimit(1)
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if(self.searchViewModel.recentSearchFirebaseLists.count == 0) {
                    self.searchViewModel.recentSearchFirebaseLists.append(self.placeList)
                } else if (!self.searchViewModel.recentSearchFirebaseLists.contains(self.placeList)) {
                    self.searchViewModel.recentSearchFirebaseLists.insert(self.placeList, at: 0)
                    if(self.searchViewModel.recentSearchFirebaseLists.count > 5) {
                        self.searchViewModel.recentSearchFirebaseLists = Array(self.searchViewModel.recentSearchFirebaseLists.prefix(5))
                    }
                    
                }
                self.placeListIdToNavigateTo = self.placeList.id
                self.goToPlaceList = 1
            }
            if showRecent == true {
                Image(systemName: "xmark")
                    .padding(.trailing)
                    .frame(width: 40)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let indexOfToBeDeletedEntry = self.searchViewModel.recentSearchFirebaseLists.firstIndex(of: self.placeList)
                        if(indexOfToBeDeletedEntry != nil) {
                            self.searchViewModel.recentSearchFirebaseLists.remove(at: indexOfToBeDeletedEntry!)
                        }
                }
            }
        }
    }
}

