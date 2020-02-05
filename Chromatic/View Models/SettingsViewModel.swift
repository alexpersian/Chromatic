//
//  SettingsViewModel.swift
//  Chromatic
//
//  Created by Alex Persian on 1/18/20.
//  Copyright © 2020 alexpersian. All rights reserved.
//

import Alamofire
import StoreKit

protocol SettingsViewDelegate: AnyObject {
    func updateSearchButtonTitle()
    func transactionComplete(success: Bool)
}

final class SettingsViewModel: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    weak var delegate: SettingsViewDelegate?
    private let data = Dictionary<String, String>.fromPlist("Data")

    // IAP containers and tracker
    private var productIDs: Set<String> = []
    private var productsArray: Array<SKProduct> = []
    private(set) var transactionInProgress = false

    // MARK: URL Accessors

    var twitterURL: URL? {
        guard
            let path = data["Twitter"],
            let url = URL(string: path) else { return nil }
        return url
    }

    var githubURL: URL? {
        guard
            let path = data["GitHub"],
            let url = URL(string: path) else { return nil }
        return url
    }

    // MARK: City Management

    func updateLocationData(_ city: String, offset: Int) {
        saveNewCity(city)
        saveNewOffset(offset)
        delegate?.updateSearchButtonTitle()
    }

    private func saveNewCity(_ city: String) {
        UserDefaultsManager.setCurrentCity(city)
    }

    private func saveNewOffset(_ offset: Int) {
        UserDefaultsManager.setTimeOffset(offset)
    }

    // MARK: Google Requests

    func requestGeocodingFromGoogle(_ address: String) {
        guard
            let googleAPIKey = data["Google API Key"],
            let requestURL = URL(string: "https://maps.googleapis.com/maps/api/geocode/json")
            else { return }

        let params = [
            "address": address,
            "key": googleAPIKey
        ]

        Alamofire.request(requestURL, method: .get, parameters: params)
            .responseData { response in
                let result: Result<GMPlaceResult> = JSONDecoder().decodeResponse(from: response)
                switch result {
                case .success(let results):
                    print(results)
                    if let place = results.places.first {
                        let coordinates = place.geometry.location
                        self.requestTimeZoneFromGoogle("\(coordinates.lat), \(coordinates.lon)", address: address)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }

    private func requestTimeZoneFromGoogle(_ location: String, address: String) {
        guard
            let googleAPIKey = data["Google API Key"],
            let requestURL = URL(string: "https://maps.googleapis.com/maps/api/timezone/json")
            else { return }

        let params = [
            "location": location,
            "timestamp": "\(Date().timeIntervalSince1970)",
            "key": googleAPIKey
        ]

        Alamofire.request(requestURL, method: .get, parameters: params)
            .responseData { response in
                let result: Result<GMTimeZone> = JSONDecoder().decodeResponse(from: response)
                switch result {
                case .success(let timeZone):
                    let city = address.components(separatedBy: ",")[0]
                    let totalOffset = timeZone.rawOffset + timeZone.dstOffset
                    self.updateLocationData(city, offset: totalOffset)
                case .failure(let error):
                    print(error)
                }
        }
    }

    // MARK: StoreKit IAP Management

    func initiatePurchase(for product: ProductType) {
        var iap: SKProduct

        switch product {
        case .thankYou:
            guard let p = productsArray[safeIndex: 1] else {
                delegate?.transactionComplete(success: false)
                return
            }
            iap = p
        case .coffee:
            guard let p = productsArray[safeIndex: 0] else {
                delegate?.transactionComplete(success: false)
                return
            }
            iap = p
        }

        let payment = SKPayment(product: iap)
        SKPaymentQueue.default().add(payment)
        transactionInProgress = true
    }

    func setupStoreKitProducts() {
        // IAP setup
        guard
            let iap1 = data["IAP 1"],
            let iap2 = data["IAP 2"]
        else {
            print("Error retrieving IAP from plist")
            return
        }
        productIDs.insert(iap1)
        productIDs.insert(iap2)
        requestProductInfo()
        SKPaymentQueue.default().add(self)
    }

    private func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productRequest = SKProductsRequest(productIdentifiers: productIDs)
            productRequest.delegate = self
            productRequest.start()
        } else {
            print("Cannot perform In App Purchases")
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (response.products.count != 0) {
            for product in response.products {
                productsArray.append(product)
            }
        } else {
            print("There are no products")
        }

        /* Check for invalid product identifiers */
        if (response.invalidProductIdentifiers.count != 0) {
            print("Invalid products: \(response.invalidProductIdentifiers.description)")
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                delegate?.transactionComplete(success: true)

            case SKPaymentTransactionState.failed:
                print("Transaction failed: \(String(describing: transaction.error?.localizedDescription))")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                delegate?.transactionComplete(success: false)

            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
}
