import SwiftUI

struct SearchResultsPlaceListView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    // PROPS
    @Binding var tabSelection: Int
    // LOCAL
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
                                                   tabSelection: self.$tabSelection,
                                                   placeListIdToNavigateTo: self.$placeListIdToNavigateTo,
                                                   goToPlaceList: self.$goToPlaceList,
                                                   showRecent: true
                                )
                                    .environmentObject(self.searchViewModel)
                            }
                            Spacer()
                        }
                    } else {
                        SearchResultsEmptyStateView(imageString: "placeholder-search-collections-200", titleString: "Discover new spots", bodyString: "Search collection lists of places to\n explore recommended spots\n by other users.")
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
    // PROPS
    var placeList: PlaceList
    @Binding var tabSelection: Int
    @Binding var placeListIdToNavigateTo: String?
    @Binding var goToPlaceList: Int?
    @State var showRecent: Bool = false
    
    var body: some View {
        HStack {
            HStack(alignment: .center) {
                HStack {
                    Image(systemName: "rectangle.on.rectangle")
                        .foregroundColor(Color(.gray))
                }
                .frame(width: 40, height: 40)
                .overlay(Circle()
                .stroke(Color(.lightGray)
                .opacity(0.5), lineWidth: 1))
                .padding(.trailing, 5)
                VStack(alignment: .leading){
                    Text(placeList.name)
                        .font(.system(size:18))
                        .fontWeight(.semibold).lineLimit(1)
                    Text("by \(placeList.owner.username)")
                        .font(.system(size:12)).lineLimit(1)
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

