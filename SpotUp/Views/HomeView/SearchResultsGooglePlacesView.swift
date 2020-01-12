import SwiftUI
import GooglePlaces

struct SearchResultsGooglePlacesView: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        Group {
            if self.searchViewModel.searchTerm == "" {
                if (self.searchViewModel.recentSearchPlaces.count > 0) {
                    ScrollView(.vertical, showsIndicators: true) { Text("Recent").padding(.leading)
                        ForEach(searchViewModel.recentSearchPlaces, id: \.self) {
                            (result: GMSAutocompletePrediction) in SingleRowPlace(result: result, showRecent: true).environmentObject(self.searchViewModel)
                        }
                        Spacer()
                    }
                }
                else {
                    SearchResultsEmptyStateView()
                }
            } else {
                ScrollView(.vertical, showsIndicators: true) { ForEach(searchViewModel.googlePlaces, id: \.self) {
                    result in SingleRowPlace(result: result).environmentObject(self.searchViewModel)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct SingleRowPlace: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    @State var result: GMSAutocompletePrediction
    @State var showRecent: Bool = false
    @State var selection: Int? = nil
    @State var goToDestination: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {
               if(self.searchViewModel.recentSearchPlaces.count == 0) {
                    self.searchViewModel.recentSearchPlaces.append(self.result)
                } else if (!self.searchViewModel.recentSearchPlaces.contains(self.result)) {
                    self.searchViewModel.recentSearchPlaces.insert(self.result, at: 0)
                }
                self.goToDestination = true
                self.selection = 1
            }){
                HStack {
                    Text(result.attributedFullText.string)
                    Spacer()
                }
            }.padding(.leading)
            Spacer()
            if showRecent == true {
                Group{
                    Button(action: {
                        print("delete invoked")
                        let indexOfToBeDeletedEntry = self.searchViewModel.recentSearchPlaces.firstIndex(of: self.result)
                        if(indexOfToBeDeletedEntry != nil) {
                            self.searchViewModel.recentSearchPlaces.remove(at: indexOfToBeDeletedEntry!)
                        }
                    }) { Image(systemName: "xmark")}
                }
                    .padding(.trailing)
            }
            if (self.goToDestination != false) {
                NavigationLink(destination:ItemView(placeID: result.placeID), tag: 1, selection: $selection) { EmptyView() }
            }
        }
    }
}

//struct SearchResultsGooglePlacesView: PreviewProvider {
//    static var previews: some View {
//        SearchResultsGooglePlacesView()
//    }
//}
