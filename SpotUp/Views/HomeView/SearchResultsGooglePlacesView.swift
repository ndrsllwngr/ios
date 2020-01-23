import SwiftUI
import GooglePlaces

// TODO https://forums.raywenderlich.com/t/swiftui-dont-update-scrollview-content-via-api/88875
//            if self.searchViewModel.searchTerm == "" {
//                if (self.searchViewModel.recentSearchPlaces.count > 0) {
//                    ScrollView(.vertical, showsIndicators: true) { Text("Recent").padding(.leading)
//                        ForEach(searchViewModel.recentSearchPlaces, id: \.placeID) {
//                            (result: GMSAutocompletePrediction) in SingleRowPlace(result: result, showRecent: true).environmentObject(self.searchViewModel)
//                        }
//                        Spacer()
//                    }
//                }
//                else {
//                    SearchResultsEmptyStateView()
//                }
//            } else {
//                ScrollView(.vertical, showsIndicators: true) { ForEach(searchViewModel.googlePlaces, id: \.self.placeID) {
//                    result in SingleRowPlace(result: result).environmentObject(self.searchViewModel)
//                    }
//                    Spacer()
//                }
//            }

struct SearchResultsGooglePlacesView: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        Group {
            if self.searchViewModel.searchTerm == "" {
                if (self.searchViewModel.recentSearchPlaces.count > 0) {
                    List { Section(){
                        Text("Recent").font(.subheadline).fontWeight(.semibold)
                        ForEach(searchViewModel.recentSearchPlaces, id: \.placeID) {
                            (result: GMSAutocompletePrediction) in SingleRowPlace(result: result, showRecent: true).environmentObject(self.searchViewModel)
                        }
                        Spacer()
                        }
                    }
                }
                else {
                    SearchResultsPlacesEmptyStateView()
                }
            } else {
                List { ForEach(searchViewModel.googlePlaces, id: \.placeID) {
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
                    if(self.searchViewModel.recentSearchPlaces.count > 5) {
                        self.searchViewModel.recentSearchPlaces = Array(self.searchViewModel.recentSearchPlaces.prefix(5))
                    }
                }
                self.goToDestination = true
                self.selection = 1
            }){
                HStack {
                    VStack(alignment: .leading) {
                        Text(result.attributedPrimaryText.string).font(.headline)
                        if result.attributedSecondaryText != nil {
                            Text(result.attributedSecondaryText!.string).font(.body)
                        }
                    }
                    Spacer()
                }
            }.padding(.leading)
            Spacer()
            // TODO not possible to add delete action, due to NavigationLink bug
            //            if showRecent == true {
            //                Group{
            //                    Button(action: {
            //                        print("delete invoked")
            //                        let indexOfToBeDeletedEntry = self.searchViewModel.recentSearchPlaces.firstIndex(of: self.result)
            //                        if(indexOfToBeDeletedEntry != nil) {
            //                            self.searchViewModel.recentSearchPlaces.remove(at: indexOfToBeDeletedEntry!)
            //                        }
            //                    }) { Image(systemName: "xmark")}
            //                }
            //                .padding(.trailing)
            //            }
            if (self.goToDestination != false) {
                NavigationLink(destination:ItemView(placeId: result.placeID), tag: 1, selection: $selection) { EmptyView() }
            }
        }
    }
}

//struct SearchResultsGooglePlacesView: PreviewProvider {
//    static var previews: some View {
//        SearchResultsGooglePlacesView()
//    }
//}
