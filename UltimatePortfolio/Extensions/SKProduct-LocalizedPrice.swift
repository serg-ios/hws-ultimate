//
//  SKProduct-LocalizedPrice.swift
//  UltimatePortfolio
//
//  Created by Sergio Rodríguez Rama on 17/4/21.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
