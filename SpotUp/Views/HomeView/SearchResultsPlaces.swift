import SwiftUI
import GooglePlaces

struct SearchResultsPlaces: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        VStack {
            List { ForEach(searchViewModel.googlePlaces, id: \.placeID) {
                result in HStack {
                    NavigationLink(destination: ItemView(placeID: result.placeID)) {
                        Text(result.attributedFullText.string)
                    }
                    Spacer()
                }
                }
                Spacer()
            }
        }
    }
}

//struct SearchResultsPlaces: PreviewProvider {
//    static var previews: some View {
////        SearchResultsPlaces()
//    }
//}
