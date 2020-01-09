import SwiftUI
import GooglePlaces

struct SearchResultsPlaces: View {
    @Binding var googlePlaces: [GMSAutocompletePrediction]
    var body: some View {
        List { ForEach(self.googlePlaces, id: \.placeID) {
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

//struct SearchResultsPlaces: PreviewProvider {
//    static var previews: some View {
////        SearchResultsPlaces()
//    }
//}
