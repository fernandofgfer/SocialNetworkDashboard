//
//  CoreDataManager.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 26/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//
import CoreData
import Foundation

class CoreDataManager {
    
    private let containerName: String
    init(containerName: String) {
        self.containerName = containerName
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        // In case we need to use viewContext updated
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
}

// MARK: - CoreDataManagerProtocol implementation
extension CoreDataManager: CoreDataManagerProtocol {
    func saveAsync(_ changes: @escaping ChangesBlock, completion: @escaping (Bool) -> Void){
        persistentContainer.performBackgroundTask { context in
            changes(context)
            context.saveContext(completion: completion)
        }
    }
    
    func fetchAsync(fetchRequest: NSFetchRequest<NSFetchRequestResult>, completion: @escaping(CoreDataResult) -> Void) {
        persistentContainer.performBackgroundTask { context in
            do {
                let fetchData = try context.fetch(fetchRequest) as? [NSManagedObject]
                completion(.success(fetchData))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
}

// MARK: - NSManagedObjectContext extension to save context with closure
extension NSManagedObjectContext {
    func saveContext(completion: @escaping (Bool) -> Void) {
        if hasChanges {
            do {
                try save()
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
            DispatchQueue.main.async {
                completion(true)
            }
        } else {
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
}
