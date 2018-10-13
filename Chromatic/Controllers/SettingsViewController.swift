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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class SettingsViewController: UIViewController {
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var placesTextField: GooglePlacesField!
    
    let data = Dictionary<String, String>.fromPlist("Data")
    
    // IAP stuff
    var productIDs: Set<String> = []
    var productsArray: Array<SKProduct?> = []
    var transactionInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setup()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

// MARK: Custom functions
    
    func setup() {
        self.setNeedsStatusBarAppearanceUpdate()
        self.title = "Settings"
        self.placesTextField.delegate = self
        placesTextField.hidePredictionWhenResigningFirstResponder = true
        
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
    
    func saveNewCity(_ city: String) {
        UserDefaultsManager.setCurrentCity(city)
    }
    
    func saveNewOffset(_ offset: Int) {
        UserDefaultsManager.setTimeOffset(offset)
    }
    
    func findNewCity() {
        if !activitySpinner.isAnimating { activitySpinner.startAnimating() }
        
        guard (placesTextField.selectedPlaceId != nil) && (placesTextField.text?.characters.count > 0) else {
            showBasicAlert("Woops!", message: "You must select a city.")
            return
        }
        guard let address = placesTextField.text else {
            print("Error: text field conversion to string failed")
            return
        }
        
        requestGeocodingFromGoogle(address)
    }
    
    func updateLocationData(_ city: String, offset: Int) {
        self.saveNewCity(city)
        self.saveNewOffset(offset)
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
        
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.default) { (action) -> Void in
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            self.transactionInProgress = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
    }
    
// MARK: IBActions
    
    @IBAction func supportThanksButtonPressed(_ sender: UIButton) {
        print("Thanks for the support!")
        showThankYouPurchaseAction()
    }
    
    @IBAction func supportCoffeeButtonPressed(_ sender: UIButton) {
        print("Thanks for the coffee!")
        showCoffeePurchaseAction()
    }
    
    @IBAction func twitterButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: data["Twitter"]!) else { return }
        if #available(iOS 9.0, *) {
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func githubButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: data["GitHub"]!) else { return }
        if #available(iOS 9.0, *) {
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
