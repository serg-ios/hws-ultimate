//
//  HomeViewModel.swift
//  UltimatePortfolioTests
//
//  Created by Sergio Rodríguez Rama on 16/4/21.
//

import Foundation
import CoreData

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {

        @Published var projects = [Project]()
        @Published var items = [Item]()

        var upNext: ArraySlice<Item> {
            items.prefix(3)
        }

        var moreToExplore: ArraySlice<Item> {
            items.dropFirst(3)
        }

        private let projectsController: NSFetchedResultsController<Project>
        private let itemsController: NSFetchedResultsController<Item>

        private var dataController: DataController

        init(dataController: DataController) {
            self.dataController = dataController

            // Construct a fetch request to show all open projects
            let projectsRequest: NSFetchRequest<Project> = Project.fetchRequest()
            projectsRequest.predicate = NSPredicate(format: "closed = false")
            projectsRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]
            projectsController = NSFetchedResultsController(
                fetchRequest: projectsRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            // Construct a fetch request to show the 10 highest-priority, incomplete items from open projects
            let itemsRequest: NSFetchRequest<Item> = Item.fetchRequest()
            let completedPredicate = NSPredicate(format: "completed = false")
            let openPredicate = NSPredicate(format: "project.closed = false")
            let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
            itemsRequest.predicate = compoundPredicate
            itemsRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Item.priority, ascending: false)
            ]
            itemsRequest.fetchLimit = 10
            itemsController = NSFetchedResultsController(
                fetchRequest: itemsRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            super.init()
            projectsController.delegate = self
            itemsController.delegate = self

            do {
                try projectsController.performFetch()
                try itemsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
                items = itemsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch initial data.")
            }
        }

        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }

        // MARK: - NSFetchedResultsControllerDelegate methods

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newItems = controller.fetchedObjects as? [Item] {
                items = newItems
            } else if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
        }
    }
}
