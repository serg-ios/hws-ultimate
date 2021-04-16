//
//  ItemRowViewModel.swift
//  UltimatePortfolio
//
//  Created by Sergio Rodríguez Rama on 16/4/21.
//

import Foundation

extension ItemRowView {
    class ViewModel: ObservableObject {
        let project: Project
        let item: Item

        var title: String { item.itemTitle }

        internal init(project: Project, item: Item) {
            self.project = project
            self.item = item
        }

        var label: String {
            if item.completed {
                return "\(item.itemTitle), completed."
            } else if item.priority == 3 {
                return "\(item.priority), high priority."
            } else {
                return item.itemTitle
            }
        }

        var icon: String {
            if item.priority == 3 {
                return "checkmark.circle"
            } else {
                return "exclamationmark.triangle"
            }
        }

        var color: String? {
            if item.completed || item.priority == 3 {
                return project.projectColor
            } else {
                return nil
            }
        }
    }
}
