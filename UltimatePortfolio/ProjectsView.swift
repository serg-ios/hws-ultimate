//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Sergio Rodríguez Rama on 25/1/21.
//

import SwiftUI

struct ProjectsView: View {

    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var showingSortOrder: Bool = false
    @State private var sortOrder = Item.SortOrder.optimize

    let showClosedProjects: Bool

    let projects: FetchRequest<Project>

    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }

    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.isEmpty {
                    Text("There's nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(projects.wrappedValue) { project in
                            Section(header: ProjectHeaderView(project: project)) {
                                ForEach(project.projectItems(using: sortOrder)) { item in
                                    ItemRowView(project: project, item: item)
                                }
                                .onDelete(perform: { offsets in
                                    let allItems = project.projectItems(using: sortOrder)
                                    for offset in offsets {
                                        let item = allItems[offset]
                                        dataController.delete(item)
                                    }
                                    dataController.save()
                                })
                                if !showClosedProjects {
                                    Button {
                                        withAnimation {
                                            let item = Item(context: managedObjectContext)
                                            item.project = project
                                            item.creationDate = Date()
                                            dataController.save()
                                        }
                                    } label: {
                                        Label("Add New Item", systemImage: "plus")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !showClosedProjects {
                        Button {
                            withAnimation {
                                let project = Project(context: managedObjectContext)
                                project.closed = false
                                project.creationDate = Date()
                                dataController.save()
                            }
                        } label: {
                            Label("Add project", systemImage: "plus")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSortOrder.toggle()
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
                    .default(Text("Optimized")) {
                        sortOrder = .optimize
                    },
                    .default(Text("Creation")) {
                        sortOrder = .creationDate
                    },
                    .default(Text("Title")) {
                        sortOrder = .title
                    }
                ])
            }
            SelectSomethingView()
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {

    static var dataController = DataController.preview

    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
