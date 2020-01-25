import SwiftUI
import GooglePlaces

struct SearchResultsPlacesView: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        Group {
            if self.searchViewModel.searchTerm == "" {
                if (self.searchViewModel.recentSearchPlaces.count > 0) {
                    List { Section(){
                        Text("Recent").font(.system(size:18)).fontWeight(.bold)
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
            
            HStack(alignment: .center) {
                Image(uiImage: UIImage(named: "placeholder-row-place")!)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42.0, height: 42.0, alignment: .center)
                    .padding(.trailing, 5)
                VStack(alignment: .leading){
                    Text(result.attributedPrimaryText.string).font(.system(size:18)).fontWeight(.semibold).lineLimit(1)
                    if result.attributedSecondaryText != nil {
                        Text(result.attributedSecondaryText!.string).font(.system(size:12)).lineLimit(1)
                    }
                }
                Spacer()
            }.onTapGesture {
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
            }
            Spacer()
            Text("")
            if showRecent == true {
                Image(systemName: "xmark")
                    .padding(.trailing)
                    .onTapGesture {
                        let indexOfToBeDeletedEntry = self.searchViewModel.recentSearchPlaces.firstIndex(of: self.result)
                        if(indexOfToBeDeletedEntry != nil) {
                            self.searchViewModel.recentSearchPlaces.remove(at: indexOfToBeDeletedEntry!)
                        }
                }
                
            }
            if (self.goToDestination != false) {
                NavigationLink(destination:ItemView(placeId: result.placeID), tag: 1, selection: $selection) { EmptyView() }
            }
        }
    }
}
