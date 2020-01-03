//
//  SettingsViewController.swift
//  Chromatic
//
//  Created by Alex Persian on 9/6/15.
//  Copyright (c) 2015 alexpersian. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices
import GooglePlaces

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
private func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

final class SettingsViewController: UIViewController {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var buttons: [UIButton]!

    let data = Dictionary<String, String>.fromPlist("Data")

    // IAP stuff
    var productIDs: Set<String> = []
    var productsArray: Array<SKProduct?> = []
    var transactionInProgress = false

    override func viewWillAppear(_ animated: Bool) {
        self.setup()
        self.navigationController?.isNavigationBarHidden = false
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }

    // MARK: Custom functions

    private func setup() {
        self.setNeedsStatusBarAppearanceUpdate()
        self.searchButton.setTitle("  \(UserDefaultsManager.getCurrentCity())", for: .normal)
        buttons.forEach {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8.0
        }

        // IAP setup
        guard let iap1 = data["IAP 1"], let iap2 = data["IAP 2"] else {
            print("Error retrieving IAP from plist")
            return
        }
        productIDs.insert(iap1)
        productIDs.insert(iap2)
        requestProductInfo()
        SKPaymentQueue.default().add(self)
    }

    private func saveNewCity(_ city: String) {
        UserDefaultsManager.setCurrentCity(city)
    }

    private func saveNewOffset(_ offset: Int) {
        UserDefaultsManager.setTimeOffset(offset)
    }

    func updateLocationData(_ city: String, offset: Int) {
        saveNewCity(city)
        saveNewOffset(offset)
        self.searchButton.setTitle("  \(UserDefaultsManager.getCurrentCity())", for: .normal)
    }

    // MARK: Alert view helpers

    func showBasicAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in }

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func showBasicAlertWithProduct(_ title: String, message: String, product: SKProduct) {
        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let buyAction = UIAlertAction(title: "Buy", style: UIAlertAction.Style.default) { (action) -> Void in
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            self.transactionInProgress = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) -> Void in }

        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
    }

    // MARK: IBActions

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        // TODO: Refactor this section to be self-contained
        print("Searching...")
        let placesSearchController = GMSAutocompleteViewController()
        placesSearchController.delegate = self

        // Specify that we want names and PlaceID's returned from autocomplete
        guard let fields = GMSPlaceField(rawValue:
            UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) |
            UInt(GMSPlaceField.formattedAddress.rawValue) |
            UInt(GMSPlaceField.addressComponents.rawValue))
        else { return }
        placesSearchController.placeFields = fields

        // Restrict results to cities only
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        placesSearchController.autocompleteFilter = filter

        present(placesSearchController, animated: true, completion: nil)
    }

    @IBAction func supportThanksButtonPressed(_ sender: UIButton) {
        showThankYouPurchaseAction()
    }

    @IBAction func supportCoffeeButtonPressed(_ sender: UIButton) {
        showCoffeePurchaseAction()
    }

    @IBAction func twitterButtonPressed(_ sender: UIButton) {
        guard
            let path = data["Twitter"],
            let url = URL(string: path) else {
                print("Error: Twitter URL unavailable within data plist file.")
                return
        }
        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
    }

    @IBAction func githubButtonPressed(_ sender: UIButton) {
        guard
            let path = data["GitHub"],
            let url = URL(string: path) else {
                print("Error: GitHub URL unavailable within data plist file.")
                return
        }
        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
    }
}

extension SettingsViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Selected place:", place)
        requestGeocodingFromGoogle(place.formattedAddress ?? "")
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Encounterd error:", error)
        activityIndicator.stopAnimating()
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Cancelled...")
        dismiss(animated: true, completion: nil)
    }

    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        activityIndicator.startAnimating()
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        activityIndicator.stopAnimating()
    }
}
