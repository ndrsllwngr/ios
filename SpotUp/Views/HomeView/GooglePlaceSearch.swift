import UIKit
import GooglePlaces

class GPViewController: UIViewController {

  override func viewDidLoad() {
    makeButton()
  }

  // Present the Autocomplete view controller when the button is pressed.
  @objc func autocompleteClicked(_ sender: UIButton) {
    let autocompleteController = GMSAutocompleteViewController()
    autocompleteController.delegate = self

    // Specify the place data types to return.
    let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
      UInt(GMSPlaceField.placeID.rawValue))!
    autocompleteController.placeFields = fields

    // Specify a filter.
    let filter = GMSAutocompleteFilter()
    filter.type = .establishment
    autocompleteController.autocompleteFilter = filter

    // Display the autocomplete view controller.
    present(autocompleteController, animated: true, completion: nil)
  }

  // Add a button to the view.
  func makeButton() {
    let btnLaunchAc = UIButton(frame: CGRect(x: 5, y: 150, width: 300, height: 35))
    btnLaunchAc.backgroundColor = .blue
    btnLaunchAc.setTitle("Launch autocomplete", for: .normal)
    btnLaunchAc.addTarget(self, action: #selector(autocompleteClicked), for: .touchUpInside)
    self.view.addSubview(btnLaunchAc)
  }

}

extension GPViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place ID: \(place.placeID)")
    print("Place attributions: \(place.attributions)")
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}
