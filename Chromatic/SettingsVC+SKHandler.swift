//
//  SettingsVC+SKProductsRequestDelegate.swift
//  Chromatic
//
//  Created by Alex Persian on 2/13/16.
//  Copyright © 2016 alexpersian. All rights reserved.
//

import Foundation
import StoreKit

extension SettingsViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
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
        
        showBasicAlertWithProduct("Chromatic", message: "Send a thank you to the developer? ($0.99)", product: self.productsArray[1])
    }
    
    func showCoffeePurchaseAction() {
        if transactionInProgress {
            return
        }
        
        showBasicAlertWithProduct("Chromatic", message: "Buy the developer a coffee? ($2.99)", product: self.productsArray[0])
    }
    
    func presentThankYouMessage() {
        if transactionInProgress {
            return
        }
        
        showBasicAlert("Chromatic", message: "You rock! Thanks for the support. \u{1F44D}")
    }
    
    func presentFailedTransaction() {
        if transactionInProgress {
            return
        }
        
        showBasicAlert("Chromatic", message: "Transaction has failed. \u{1F613}")
    }
}
