import SwiftUI

struct SearchResultsPlaceLists: View {
    
    @EnvironmentObject var searchSpace: FirestoreSearch
    @ObservedObject var firestorePlaceList = FirestorePlaceList()
    @State var searchTerm: String
    
    var body: some View {
        List { ForEach(searchSpace.allPublicPlaceLists.filter{self.searchTerm.isEmpty ? false : $0.name.localizedCaseInsensitiveContains(self.searchTerm)}) {
            (placeList: PlaceList) in NavigationLink(destination: PlaceListView(placeListId: placeList.id, placeListName: placeList.name, isOwnedPlacelist: false).environmentObject(self.firestorePlaceList)){Text(placeList.name)}
            }
            Spacer()
        }
    }
}

//struct SearchResultsPlaceLists_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultsPlaceLists()
//    }
//}
