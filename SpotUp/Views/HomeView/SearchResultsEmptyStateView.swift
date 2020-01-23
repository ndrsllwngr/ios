import SwiftUI

struct SearchResultsProfilesEmptyStateView: View {
    var body: some View {
        VStack() {
            Spacer()
            Image(uiImage: UIImage(named: "placeholder-search-1")!)
            .renderingMode(.original)
            .resizable()
            Text("Empty state")
            Spacer()
        }
    }
}

struct SearchResultsProfilesEmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsProfilesEmptyStateView()
    }
}

struct SearchResultsListsEmptyStateView: View {
    var body: some View {
        VStack() {
            Spacer()
            Image(uiImage: UIImage(named: "placeholder-search-3")!)
            .renderingMode(.original)
            .resizable()
            Text("Empty state")
            Spacer()
        }
    }
}

struct SearchResultsListsEmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsListsEmptyStateView()
    }
}

struct SearchResultsPlacesEmptyStateView: View {
    var body: some View {
        VStack() {
            Spacer()
            Image(uiImage: UIImage(named: "placeholder-search-2")!)
            .renderingMode(.original)
            .resizable()
            Text("Empty state")
            Spacer()
        }
    }
}

struct SearchResultsPlacesEmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsPlacesEmptyStateView()
    }
}
