import SwiftUI
import GooglePlaces

struct SearchResultsGooglePlacesView: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        Group {
            if self.searchViewModel.searchTerm == "" {
                if (self.searchViewModel.recentSearchPlaces.count > 0) {
                    List { Section(header: Text("Recent")){
                        ForEach(searchViewModel.recentSearchPlaces, id: \.placeID) {
                            (result: GMSAutocompletePrediction) in SingleRowPlace(result: result).environmentObject(self.searchViewModel)
                        }.onDelete(perform: delete)
                        Spacer()
                        }
                    }
                    
                }
                else {
                    SearchResultsEmptyStateView()
                }
            } else {
                List { ForEach(searchViewModel.googlePlaces, id: \.self.placeID) {
                    result in SingleRowPlace(result: result).environmentObject(self.searchViewModel)
                }
                Spacer()
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        self.searchViewModel.recentSearchPlaces.remove(atOffsets: offsets)
    }
}

struct SingleRowPlace: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    @State var result: GMSAutocompletePrediction
    @State var presentMe: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {
                if(self.searchViewModel.recentSearchPlaces.count == 0) {
                    self.searchViewModel.recentSearchPlaces.append(self.result)
                } else if (!self.searchViewModel.recentSearchPlaces.contains(self.result)) {
                    self.searchViewModel.recentSearchPlaces.insert(self.result, at: 0)
                }
                self.presentMe = true
            }, label: {
               Text(result.attributedFullText.string)
            })
            NavigationLink(destination: ItemView(placeID: result.placeID), isActive: self.$presentMe) {
                EmptyView()
            }
        }
    }
}

//struct SearchResultsGooglePlacesView: PreviewProvider {
//    static var previews: some View {
//        SearchResultsGooglePlacesView()
//    }
//}
