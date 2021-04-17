//
//  UnlockManager.swift
//  UltimatePortfolio
//
//  Created by Sergio Rodríguez Rama on 17/4/21.
//

import Foundation
import Combine
import StoreKit

class UnlockManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    enum RequestState {
        case loading
        case loaded(SKProduct)
        case failed(Error?)
        case purchased
        case deferred
    }

    private enum StoreError: Error {
        case invalidIdentifiers, missingProducts
    }

    @Published var requestState = RequestState.loading

    private let dataController: DataController
    private let request: SKProductsRequest
    private var loadedProducts = [SKProduct]()

    var canMakePayments: Bool {
        SKPaymentQueue.canMakePayments()
    }

    init(dataController: DataController) {
        self.dataController = dataController
        let productIds = Set(["com.serg-ios.UltimatePortfolio.unlock"])
        request = SKProductsRequest(productIdentifiers: productIds)
        super.init()
        SKPaymentQueue.default().add(self)
        if !dataController.fullVersionUnlocked {
            request.delegate = self
            request.start()
        }
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        DispatchQueue.main.async { [self] in
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased, .restored:
                    self.dataController.fullVersionUnlocked = true
                    self.requestState = .purchased
                    queue.finishTransaction(transaction)
                case .failed:
                    if let product = loadedProducts.first {
                        self.requestState = .loaded(product)
                    } else {
                        self.requestState = .failed(transaction.error)
                    }
                    queue.finishTransaction(transaction)
                case .deferred:
                    self.requestState = .deferred
                default:
                    break
                }
            }
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async { [weak self] in
            self?.loadedProducts = response.products
            guard let unlock = self?.loadedProducts.first else {
                self?.requestState = .failed(StoreError.missingProducts)
                return
            }
            guard response.invalidProductIdentifiers.isEmpty else {
                print("PRINT: Received invalid product identifiers: \(response.invalidProductIdentifiers)")
                self?.requestState = .failed(StoreError.invalidIdentifiers)
                return
            }
            self?.requestState = .loaded(unlock)
        }
    }

    func buy(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
