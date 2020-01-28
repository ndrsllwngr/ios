import SwiftUI

struct SearchResultsEmptyStateView: View {
    // PROPS
    var imageString: String;
    var titleString: String;
    var bodyString: String;
    
    var body: some View {
        VStack() {
            Spacer()
            VStack() {
                SearchPlaceholderIllustration(imageString: imageString)
                Text(titleString)
                    .font(.title)
                    .multilineTextAlignment(.center)
                Text(bodyString)
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

struct SearchResultsEmptyStateView_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchResultsEmptyStateView(imageString: "placeholder-search-places-200", titleString: "Find places", bodyString: "Look up places to get more\n information and options to save it\n in a collection.")
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
