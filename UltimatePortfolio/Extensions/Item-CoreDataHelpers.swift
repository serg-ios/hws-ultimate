//
//  Item-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Sergio Rodríguez Rama on 26/1/21.
//

import Foundation

extension Item {

    enum SortOrder {
        case optimize, title, creationDate
    }

    var itemTitle: String {
        title ?? NSLocalizedString("New Item", comment: "Create a new item.")
    }

    var itemDetail: String {
        detail ?? ""
    }

    var itemCreationDate: Date {
        creationDate ?? Date()
    }

    static var example: Item {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext
        let item = Item(context: viewContext)
        item.title = "Example item"
        item.detail = "This is an example item"
        item.priority = 3
        item.creationDate = Date()
        return item
    }
}
