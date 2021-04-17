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
    @StateObject var unlockManager: UnlockManager

    init() {
        let dataController = DataController()
        let unlockManager = UnlockManager(dataController: dataController)
        _dataController = StateObject(wrappedValue: dataController)
        _unlockManager = StateObject(wrappedValue: unlockManager)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(unlockManager)
                .onReceive(
                    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save
                )
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
