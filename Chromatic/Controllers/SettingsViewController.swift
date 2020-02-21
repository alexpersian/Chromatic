//
//  SettingsViewController.swift
//  Chromatic
//
//  Created by Alex Persian on 9/6/15.
//  Copyright (c) 2015 alexpersian. All rights reserved.
//

import UIKit
import SafariServices
import GooglePlaces

enum ProductType {
    case thankYou
    case coffee
}

final class SettingsViewController: UIViewController, SettingsViewDelegate {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var buttons: [UIButton]!

    private let viewModel = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }

    // MARK: Setup

    private func setup() {
        navigationController?.isNavigationBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
        setupButtons()
        viewModel.delegate = self
        viewModel.setupStoreKitProducts()
    }

    private func setupButtons() {
        searchButton.setTitle("  \(UserDefaultsManager.getCurrentCity())", for: .normal)
        buttons.forEach {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8.0
        }
    }

    // MARK: Alert view helpers

    func showBasicAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in }

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func showBasicAlertWithProduct(_ title: String, message: String, product: ProductType) {
        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let buyAction = UIAlertAction(title: "Buy", style: .default) { [weak self] action in
            self?.viewModel.initiatePurchase(for: product)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
    }

    // MARK: SettingsViewDelegate

    func updateSearchButtonTitle() {
        searchButton.setTitle("  \(UserDefaultsManager.getCurrentCity())", for: .normal)
    }

    func transactionComplete(success: Bool) {
        if success {
            showBasicAlert("Chromatic", message: "You rock! Thanks for the support. \u{1F44D}")
        } else {
            showBasicAlert("Chromatic", message: "Transaction has failed. \u{1F613}")
        }
    }

    // MARK: IBActions

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let placesSearchController = GMSAutocompleteViewController()
        placesSearchController.delegate = self

        // Specify that we want names and PlaceID's returned from autocomplete
        guard let fields = GMSPlaceField(rawValue:
            UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) |
            UInt(GMSPlaceField.formattedAddress.rawValue) |
            UInt(GMSPlaceField.addressComponents.rawValue))
        else { return }

        // Restrict results to cities only
        let filter = GMSAutocompleteFilter()
        filter.type = .city

        placesSearchController.placeFields = fields
        placesSearchController.autocompleteFilter = filter

        styleAutocompleteViewController(placesSearchController)

        present(placesSearchController, animated: true, completion: nil)
    }

    @IBAction func supportThanksButtonPressed(_ sender: UIButton) {
        guard !viewModel.transactionInProgress else { return }
        showBasicAlertWithProduct("Chromatic", message: "Send a thank you to the developer? ($0.99)", product: .thankYou)
    }

    @IBAction func supportCoffeeButtonPressed(_ sender: UIButton) {
        guard !viewModel.transactionInProgress else { return }
        showBasicAlertWithProduct("Chromatic", message: "Buy the developer a coffee? ($2.99)", product: .coffee)
    }

    @IBAction func twitterButtonPressed(_ sender: UIButton) {
        guard let url = viewModel.twitterURL else {
            print("Error: Twitter URL unavailable within data plist file.")
            return
        }
        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
    }

    @IBAction func githubButtonPressed(_ sender: UIButton) {
        guard let url = viewModel.githubURL else {
            print("Error: GitHub URL unavailable within data plist file.")
            return
        }
        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
    }
}

extension SettingsViewController: GMSAutocompleteViewControllerDelegate {
    private func styleAutocompleteViewController(_ viewController: GMSAutocompleteViewController) {
        // Configure the autocomplete modal colors based on user interface
        // style to handle dark mode support.

        if self.traitCollection.userInterfaceStyle == .dark {
            viewController.tableCellBackgroundColor = .systemGroupedBackground
            viewController.tableCellSeparatorColor = .secondarySystemGroupedBackground
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        viewModel.requestGeocodingFromGoogle(place.formattedAddress ?? "")
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        activityIndicator.stopAnimating()
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        activityIndicator.startAnimating()
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        activityIndicator.stopAnimating()
    }
}
