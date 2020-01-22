import Foundation
import GooglePlaces
import Combine

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var notifyExplore: Bool = false
    
    @Published var status: CLAuthorizationStatus? {
        willSet { objectWillChange.send() }
    }
    
    @Published var location: CLLocation? {
        willSet { objectWillChange.send() }
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        self.locationManager.pausesLocationUpdatesAutomatically = true
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            self.locationManager.startMonitoringSignificantLocationChanges()
        } else {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func beginNotifyingExplore() {
        self.notifyExplore = true
    }
    
    func stopNotifyingExplore() {
        self.notifyExplore = false
    }
    
    func stopUpdatingLocation() {
        print("stop updating location")
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            self.locationManager.stopMonitoringSignificantLocationChanges()
        } else {
            self.locationManager.stopUpdatingLocation()
        }
        self.notifyExplore = false
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        if (self.notifyExplore) {
            ExploreModel.shared.updateDistancesInPlacesAndSetCurrentTarget()
            ExploreModel.shared.loadPlaceImages()
        }
    }
}

