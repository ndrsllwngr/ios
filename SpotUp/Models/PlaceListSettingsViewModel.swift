import Foundation
import Combine

class PlaceListSettingsViewModel: ObservableObject {
    // INPUT
    @Published var placelistName: String = ""
    
    // OUTPUT
    @Published var placelistNameMessage = ""
    @Published var isValidplacelist = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var isPlacelistNameEmptyPublisher: AnyPublisher<Bool, Never> {
        $placelistName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { name in
                return name == ""
        }
        .eraseToAnyPublisher()
    }
    
    private var isPlacelistNameMinLengthPublisher: AnyPublisher<Bool, Never> {
        $placelistName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { name in
                return name.count >= 3
        }
        .eraseToAnyPublisher()
    }
    
    enum PlacelistNameCheck {
        case valid
        case notLongEnough
        case empty
    }
    
    private var isPlacelistNameValidPublisher: AnyPublisher<PlacelistNameCheck, Never> {
        Publishers.CombineLatest(isPlacelistNameEmptyPublisher, isPlacelistNameMinLengthPublisher)
            .map { nameIsEmpty, nameIsMinLength in
                if (nameIsEmpty) {
                    return .empty
                }
                else if (!nameIsMinLength) {
                    return .notLongEnough
                }
                else {
                    return .valid
                }
        }
        .eraseToAnyPublisher()
    }
    
    init() {
        
        isPlacelistNameValidPublisher
            .receive(on: RunLoop.main)
            .map { nameCheck in
                switch nameCheck {
                case .empty:
                    return ""
                case .notLongEnough:
                    return "Collection name must at least have 3 characters"
                default:
                    return ""
                }
        }
        .assign(to: \.placelistNameMessage, on: self)
        .store(in: &cancellableSet)
        
        isPlacelistNameValidPublisher
            .receive(on: RunLoop.main)
            .map { nameCheck in
                switch nameCheck {
                case .valid:
                    return true
                default:
                    return false
                }
        }
        .assign(to: \.isValidplacelist, on: self)
        .store(in: &cancellableSet)
    }
}
