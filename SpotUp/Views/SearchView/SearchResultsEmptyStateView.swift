import SwiftUI

struct SearchResultsProfilesEmptyStateView: View {
    
    var body: some View {
        VStack() {
            Spacer()
            VStack() {
                SearchPlaceholderIllustration(imageString: "placeholder-search-accounts-200")
                Text("Add friends")
                    .font(.title)
                    .multilineTextAlignment(.center)
                Text("Find your friends or locals to see their\n hot spots collections and\n recommendations.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
            }
            .padding(.horizontal)
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
                SearchPlaceholderIllustration(imageString: "placeholder-search-collections-200")
                Text("Discover new spots")
                    .font(.title)
                    .multilineTextAlignment(.center)
                Text("Search collection lists of places to\n explore recommended spots\n by other users.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
            }
            .padding(.horizontal)
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
                SearchPlaceholderIllustration(imageString: "placeholder-search-places-200")
                Text("Find places")
                    .font(.title)
                    .multilineTextAlignment(.center)
                Text("Look up places to get more\n information and options to save it\n in a collection.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

struct SearchResultsPlacesEmptyStateView_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchResultsPlacesEmptyStateView()
    }
}

struct SearchPlaceholderIllustration: View {
    // PROPS
    var imageString: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            Spacer()
            Image(uiImage: UIImage(named: imageString)!)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(height: 200, alignment: .bottom)
        }
        .frame(width: 250, height: 250, alignment: .center)
    }
}
