//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by Sergio Rodríguez Rama on 25/1/21.
//

import SwiftUI

@main
struct UltimatePortfolioApp: App {

    @StateObject var dataController: DataController

    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
