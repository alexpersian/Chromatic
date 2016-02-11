//
//  SettingsViewController.swift
//  Chromatic
//
//  Created by Alex Persian on 9/6/15.
//  Copyright (c) 2015 alexpersian. All rights reserved.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController, UITextFieldDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver  {
    
    @IBOutlet weak var placesTextField: GooglePlacesField!
    @IBOutlet weak var citySuperView: UIView!
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var timeStyleSwitch: UISwitch!
    
    var cityArray = Array(CityList.cities.keys)
    var offsetArray = Array(CityList.cities.values)
    var newCity = ""
    var newOffset = 0
    
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
        // Dispose of any resources that can be recreated.
    }

// MARK: Custom functions
    
    func setup() {
        self.setNeedsStatusBarAppearanceUpdate()
        self.title = "Settings"
        self.placesTextField.delegate = self
        placesTextField.hidePredictionWhenResigningFirstResponder = true
        
        /* IAP setup */
        productIDs.insert("chromatic.developer_thank_you")
        productIDs.insert("chromatic.developer_beer")
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
        guard (placesTextField.selectedPlaceId != nil) else {
            showBasicAlert("Woops!", message: "You must select a city.")
            print("Error: city not selected")
            return
        }
        guard (placesTextField.text?.characters.count > 0) else {
            print("Error: text field is empty")
            return
        }
        guard let place = placesTextField.text?.componentsSeparatedByString(",") else {
                print("Error: unable to separate text")
                return
        }
        saveNewCity(place[0])
    }
    
    func showBasicAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in }
        
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showBasicAlertWithProduct(title: String, message: String, product: Int) {
        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.Default) { (action) -> Void in
            let payment = SKPayment(product: self.productsArray[product])
            SKPaymentQueue.defaultQueue().addPayment(payment)
            self.transactionInProgress = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        presentViewController(actionSheetController, animated: true, completion: nil)
    }

// MARK: In app purchases
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productRequest = SKProductsRequest(productIdentifiers: productIDs)
            productRequest.delegate = self
            productRequest.start()
        } else {
            print("Cannot perform In App Purchases")
        }
    }
    
    func showThankYouPurchaseAction() {
        if transactionInProgress {
            return
        }
        
        let actionSheetController = UIAlertController(title: "Chromatic", message: "Send a thank you to the developer? ($0.99)", preferredStyle: .Alert)
        
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.Default) { (action) -> Void in
            let payment = SKPayment(product: self.productsArray[1])
            SKPaymentQueue.defaultQueue().addPayment(payment)
            self.transactionInProgress = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            print("Cancel button pressed.")
        }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        presentViewController(actionSheetController, animated: true, completion: nil)
    }

    func showBeerPurchaseAction() {
        if transactionInProgress {
            return
        }
        
        let actionSheetController = UIAlertController(title: "Chromatic", message: "Buy the developer a coffee? ($2.99)", preferredStyle: .Alert)
        
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.Default) { (action) -> Void in
            let payment = SKPayment(product: self.productsArray[0])
            SKPaymentQueue.defaultQueue().addPayment(payment)
            self.transactionInProgress = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            print("Cancel button pressed.")
        }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func presentThankYouMessage() {
        if transactionInProgress {
            return
        }
        let alertController = UIAlertController(title: "Chromatic", message: "You rock! Thanks for the support. \u{1F44D}", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in
            print("Ok button pressed")
        }
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentFailedTransaction() {
        if transactionInProgress {
            return
        }
        let alertController = UIAlertController(title: "Chromatic", message: "Transaction has failed. \u{1F613}", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in
            print("Ok button pressed")
        }
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

// MARK: Delegate functions
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        if (response.products.count != 0) {
            for product in response.products {
                productsArray.append(product)
            }
        } else {
            print("There are no products")
        }
        
        /* Check for invalid product identifiers */
        if (response.invalidProductIdentifiers.count != 0) {
            print(response.invalidProductIdentifiers.description)
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
                presentThankYouMessage()
                
            case SKPaymentTransactionState.Failed:
                print("Transaction failed.")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
                presentFailedTransaction()
                
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.placesTextField) {
            textField.resignFirstResponder()
            self.findNewCity()
        }
        return true
    }
    
// MARK: IBActions

    @IBAction func pickCityButtonPressed(sender: UIButton) {
        
        //TODO: Remove this once dynamic time zones are working
        let actionSheetController = UIAlertController(title: "Sorry", message: "This will be back once I get dynamic time zones working.", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in }
        
        actionSheetController.addAction(okAction)
        presentViewController(actionSheetController, animated: true, completion: nil)
        
//        if (citySuperView.hidden) {
//            citySuperView.hidden = false
//        }
    }
    
    @IBAction func chooseButtonPressed(sender: UIBarButtonItem) {
        saveNewCity(newCity)
        saveNewOffset(newOffset)
        if (!citySuperView.hidden) {
            citySuperView.hidden = true
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        if (!citySuperView.hidden) {
            citySuperView.hidden = true
        }
    }
    
    @IBAction func supportThanksButtonPressed(sender: UIButton) {
        print("Thanks for the support!")
        showThankYouPurchaseAction()
    }
    
    @IBAction func supportBeerButtonPressed(sender: UIButton) {
        print("Thanks for the beer!")
        showBeerPurchaseAction()
    }
}
