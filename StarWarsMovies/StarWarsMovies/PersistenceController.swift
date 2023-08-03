//
//  PersistenceController.swift
//  StarWarsMovies
//
//  Created by Fernando Garay on 02/08/2023.
//

import CoreData

struct PersistenceController {
    //MARK: -1. PERSISTENT CONTROLLER
    static let shared = PersistenceController()

    //MARK: -1. PERSISTENT CONTAINER
    let container: NSPersistentContainer
    
    //MARK: -1. INITIALIZATION
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Pictures")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
