import SwiftUI

struct SearchResultsProfilesEmptyStateView: View {
    var body: some View {
        VStack() {
            Spacer()
            VStack() {
                Spacer()
            Image(uiImage: UIImage(named: "placeholder-search-1")!)
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
                .frame(width: 250.0, height: 250.0, alignment: .center)
                Text("Add friends").font(.title).multilineTextAlignment(.center)
                Text("Find your friends or locals to see their\n hot spots collections and\n recommendations.").multilineTextAlignment(.center).padding(.horizontal)
                
            Spacer()
            }.padding(.horizontal)
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
            VStack() {
                Spacer()
            Image(uiImage: UIImage(named: "placeholder-search-3")!)
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
                .frame(width: 250.0, height: 250.0, alignment: .center)
                Text("Discover new spots").font(.title).multilineTextAlignment(.center)
                Text("Search collection lists of places to\n explore recommended spots\n by other users.").font(.body).multilineTextAlignment(.center).padding(.horizontal)
                
            Spacer()
            }.padding(.horizontal)
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
            VStack() {
                Spacer()
            Image(uiImage: UIImage(named: "placeholder-search-2")!)
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
                .frame(width: 250.0, height: 250.0, alignment: .center)
                Text("Find places").font(.title).multilineTextAlignment(.center)
                Text("Look up places to get more\n information and options to save it\n in a collection.").multilineTextAlignment(.center).padding(.horizontal)
                
            Spacer()
            }
            Spacer()
        }
    }
}

struct SearchResultsPlacesEmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsPlacesEmptyStateView()
    }
}
