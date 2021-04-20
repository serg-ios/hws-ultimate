//
//  PurchaseButton.swift
//  UltimatePortfolio
//
//  Created by Sergio Rodríguez Rama on 19/4/21.
//

import SwiftUI

struct PurchaseButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 200, minHeight: 44)
            .background(Color("Light Blue"))
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
