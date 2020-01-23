import Foundation
import Combine
import GooglePlaces

class SearchViewModel: ObservableObject {
    static let shared = SearchViewModel()
    // input
    @Published var searchTerm: String = ""
    @Published var searchSpaceSelection: String = SearchSpace.googlePlaces.rawValue
    
    // output
    @Published var googlePlaces: [GMSAutocompletePrediction] = []
    //solution: https://stackoverflow.com/a/58440744
    @Published var firestoreSearch: FirestoreSearch = FirestoreSearch()
    @Published var recentSearchPlaces: [GMSAutocompletePrediction] = []
    @Published var recentSearchFirebaseAccounts: [User] = []
    @Published var recentSearchFirebaseLists: [PlaceList] = []
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    public enum SearchSpace: String {
        case googlePlaces = "places"
        case firebaseAccounts = "accounts"
        case firebaseLists = "lists"
    }
    
    var firestoreSearchCancellable: AnyCancellable? = nil

    // GOOGLE SEARCH
    private var isSearchSpaceGoogle: AnyPublisher<Bool, Never> {
        $searchSpaceSelection
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { searchSpace in
                return searchSpace == SearchSpace.googlePlaces.rawValue
        }
        .eraseToAnyPublisher()
    }
    
    private var isSearchTermEmptyPublisher: AnyPublisher<Bool, Never> {
        $searchTerm
            //            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { searchTerm in
                return searchTerm == ""
        }
        .eraseToAnyPublisher()
    }
    
    private var isGoogleSearchValidPublisher: AnyPublisher<[GMSAutocompletePrediction], Never> {
        Publishers.CombineLatest(isSearchSpaceGoogle, isSearchTermEmptyPublisher)
            .map { googleIsSelected, searchIsEmpty in
                if(googleIsSelected && !searchIsEmpty)
                {
                    self.runGMS(query: self.searchTerm) {
                        (results, error) in
                        if let error = error {
                            print("Autocomplete error: \(error)")
                            return
                        }
                        if let results = results {
                            self.googlePlaces = results
                            return
                        }
                    }
                }
                return []
        }
        .eraseToAnyPublisher()
    }
    
    private init() {
        firestoreSearchCancellable = Publishers.CombineLatest(firestoreSearch.$allPublicPlaceLists,firestoreSearch.$allUsers).sink(receiveValue: {_ in            self.objectWillChange.send()
        })
        
        isGoogleSearchValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.googlePlaces, on: self)
            .store(in: &cancellableSet)
    }
    
    //    init() {
    //        isGoogleSearchValidPublisher
    //            .receive(on: RunLoop.main)
    //            .map { valid in
    //                valid ? self.GSM(query: self.searchTerm) : []
    //        }
    //        .assign(to: \.googlePlaces, on: self)
    //        .store(in: &cancellableSet)
    //    }
    
    /**
     * Create a new session token. Be sure to use the same token for calling
     * findAutocompletePredictions, as well as the subsequent place details request.
     * This ensures that the user's query and selection are billed as a single session.
     */
    private let token = GMSAutocompleteSessionToken.init()
    // Create a type filter.
    private let filter = GMSAutocompleteFilter()
    
    func runGMS(query: String, callback: @escaping GMSAutocompletePredictionsCallback) {
        self.filter.type = .establishment
        print("run GSM with callback")
        placesClient.findAutocompletePredictions(fromQuery: query,
                                                 bounds: nil,
                                                 boundsMode: GMSAutocompleteBoundsMode.bias,
                                                 filter: self.filter,
                                                 sessionToken: self.token,
                                                 callback: callback
        )
    }
}
