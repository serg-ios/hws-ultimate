//
//  Project-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Sergio Rodríguez Rama on 26/1/21.
//

import Foundation

extension Project {
    var projectTitle: String {
        title ?? "New Project"
    }

    var projectDetail: String {
        detail ?? ""
    }

    var projectColor: String {
        color ?? "Light Blue"
    }

    var projectItems: [Item] {
        let itemsArray = items?.allObjects as? [Item] ?? []
        return itemsArray.sorted(by: {
            (!$0.completed && $1.completed) || ($0.priority > $1.priority) || ($0.itemCreationDate < $1.itemCreationDate)
        })
    }

    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard !originalItems.isEmpty else { return 0 }
        let completedItems = originalItems.filter(\.completed)
        return Double(completedItems.count) / Double(originalItems.count)
    }

    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        let project = Project(context: viewContext)
        project.title = "Example project"
        project.detail = "This is an example project"
        project.closed = true
        project.creationDate = Date()
        return project
    }
}
