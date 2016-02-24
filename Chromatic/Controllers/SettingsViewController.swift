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

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var placesTextField: GooglePlacesField!
    let googleAPIKey = "AIzaSyAsyfZGRe9ZscQPhUMXz0JQDiW2r9NGC1E"
    
    /* IAP stuff */
    var productIDs: Set<String> = []
    var productsArray: Array<SKProduct!> = []
    var transactionInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

// MARK: Custom functions
    
    func setup() {
        self.setNeedsStatusBarAppearanceUpdate()
        self.title = "Settings"
        self.placesTextField.delegate = self
        placesTextField.hidePredictionWhenResigningFirstResponder = true
        
        /* IAP setup */
        productIDs.insert("chromatic.developer_thank_you")
        productIDs.insert("chromatic.developer_coffee")
        requestProductInfo()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    func saveNewCity(city: String) {
        UserDefaultsManager.setCurrentCity(city)
    }
    
    func saveNewOffset(offset: Int) {
        UserDefaultsManager.setTimeOffset(offset)
    }
    
    func findNewCity() {
        if !activitySpinner.isAnimating() { activitySpinner.startAnimating() }
        
        guard (placesTextField.selectedPlaceId != nil) else {
            showBasicAlert("Woops!", message: "You must select a city.")
            print("Error: city not selected")
            return
        }
        guard (placesTextField.text?.characters.count > 0) else {
            print("Error: text field is empty")
            return
        }
        guard let address = placesTextField.text else {
            print("Error: text field conversion to string failed")
            return
        }
        
        requestGeocodingFromGoogle(address)
    }
    
    func updateLocationData(city: String, offset: Int) {
        self.saveNewCity(city)
        self.saveNewOffset(offset)
    }

// MARK: Alert view helpers

    func showBasicAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in }
        
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showBasicAlertWithProduct(title: String, message: String, product: SKProduct) {
        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.Default) { (action) -> Void in
            let payment = SKPayment(product: product)
            SKPaymentQueue.defaultQueue().addPayment(payment)
            self.transactionInProgress = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
// MARK: IBActions
    
    @IBAction func supportThanksButtonPressed(sender: UIButton) {
        print("Thanks for the support!")
        showThankYouPurchaseAction()
    }
    
    @IBAction func supportCoffeeButtonPressed(sender: UIButton) {
        print("Thanks for the coffee!")
        showCoffeePurchaseAction()
    }
    
    @IBAction func twitterButtonPressed(sender: UIButton) {
        guard let url = NSURL(string: "https://twitter.com/alex_persian") else { return }
        if #available(iOS 9.0, *) {
            let svc = SFSafariViewController(URL: url)
            self.presentViewController(svc, animated: true, completion: nil)
        } else {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func githubButtonPressed(sender: UIButton) {
        guard let url = NSURL(string: "https://github.com/alexpersian") else { return }
        if #available(iOS 9.0, *) {
            let svc = SFSafariViewController(URL: url)
            self.presentViewController(svc, animated: true, completion: nil)
        } else {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
