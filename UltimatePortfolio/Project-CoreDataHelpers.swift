//
//  Project-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Sergio Rodríguez Rama on 26/1/21.
//

import Foundation
import SwiftUI

extension Project {

    static let colors = [
        "Pink",
        "Purple",
        "Red",
        "Orange",
        "Gold",
        "Green",
        "Teal",
        "Light Blue",
        "Dark Blue",
        "Midnight",
        "Dark Gray",
        "Gray"
    ]

    var projectTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create a new project.")
    }

    var projectDetail: String {
        detail ?? ""
    }

    var projectColor: String {
        color ?? "Light Blue"
    }

    var projectItems: [Item] {
        items?.allObjects as? [Item] ?? []
    }

    var projectItemsDefaultSorted: [Item] {
        projectItems.sorted(by: {
            (!$0.completed && $1.completed)
                || ($0.priority > $1.priority)
                || ($0.itemCreationDate < $1.itemCreationDate)
        })
    }

    var label: LocalizedStringKey {
        LocalizedStringKey(
            "\(projectTitle), \(projectItems.count) items, \(completionAmount * 100, specifier: "%g")% complete."
        )
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

    func projectItems(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .optimize:
            return projectItemsDefaultSorted
        case .creationDate:
            return projectItems.sorted(by: \Item.itemCreationDate)
        case .title:
            return projectItems.sorted(by: \Item.itemTitle)
        }
    }
}
