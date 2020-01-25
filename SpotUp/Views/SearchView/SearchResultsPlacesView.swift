import SwiftUI
import GooglePlaces

struct SearchResultsPlacesView: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    @State var placeIdToNavigateTo: String? = nil
    @State var goToPlace: Int? = nil
    
    var body: some View {
        VStack {
            if (self.placeIdToNavigateTo != nil) {
                NavigationLink(destination:ItemView(placeId: self.placeIdToNavigateTo!), tag: 1, selection: self.$goToPlace) { EmptyView()
                }
            }
            Group {
                if self.searchViewModel.searchTerm == "" {
                    if (self.searchViewModel.recentSearchPlaces.count > 0) {
                        List {
                            Text("Recent")
                                .font(.system(size:18))
                                .fontWeight(.bold)
                            ForEach(searchViewModel.recentSearchPlaces, id: \.placeID) { (result: GMSAutocompletePrediction) in
                                SingleRowPlace(result: result,
                                               showRecent: true,
                                               placeIdToNavigateTo: self.$placeIdToNavigateTo,
                                               goToPlace: self.$goToPlace).environmentObject(self.searchViewModel)
                            }
                            Spacer()
                        }
                    } else {
                        SearchResultsPlacesEmptyStateView()
                    }
                } else {
                    List {
                        ForEach(searchViewModel.googlePlaces, id: \.placeID) { result in
                            SingleRowPlace(result: result,
                                           placeIdToNavigateTo: self.$placeIdToNavigateTo,
                                           goToPlace: self.$goToPlace).environmentObject(self.searchViewModel)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct SingleRowPlace: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    @State var result: GMSAutocompletePrediction
    @State var showRecent: Bool = false
    
    @Binding var placeIdToNavigateTo: String?
    @Binding var goToPlace: Int?
    
    var body: some View {
        HStack {
            HStack(alignment: .center) {
                HStack {
                    Image(systemName: "mappin")
                        .foregroundColor(Color(.gray)) //"text-secondary"
                }.frame(width: 40, height: 40)
                .overlay(Circle().stroke(Color(.lightGray).opacity(0.5), lineWidth: 1))
                .padding(.trailing, 5)
                    
                VStack(alignment: .leading){
                    Text(result.attributedPrimaryText.string).font(.system(size:18)).fontWeight(.semibold).lineLimit(1)
                    if result.attributedSecondaryText != nil {
                        Text(result.attributedSecondaryText!.string).font(.system(size:12)).lineLimit(1)
                    }
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if(self.searchViewModel.recentSearchPlaces.count == 0) {
                    self.searchViewModel.recentSearchPlaces.append(self.result)
                } else if (!self.searchViewModel.recentSearchPlaces.contains(self.result)) {
                    self.searchViewModel.recentSearchPlaces.insert(self.result, at: 0)
                    if(self.searchViewModel.recentSearchPlaces.count > 5) {
                        self.searchViewModel.recentSearchPlaces = Array(self.searchViewModel.recentSearchPlaces.prefix(5))
                    }
                }
                self.placeIdToNavigateTo = self.result.placeID
                self.goToPlace = 1
            }
            Spacer()
            if showRecent == true {
                Image(systemName: "xmark")
                    .padding(.trailing)
                    .frame(width: 40)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let indexOfToBeDeletedEntry = self.searchViewModel.recentSearchPlaces.firstIndex(of: self.result)
                        if(indexOfToBeDeletedEntry != nil) {
                            self.searchViewModel.recentSearchPlaces.remove(at: indexOfToBeDeletedEntry!)
                        }
                }
            }
        }
    }
}
