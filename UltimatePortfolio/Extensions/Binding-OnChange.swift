//
//  Binding-OnChange.swift
//  UltimatePortfolio
//
//  Created by Sergio Rodríguez Rama on 31/1/21.
//

import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
