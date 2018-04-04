//
//  CoreDataManager.swift
//  IndeemoTest
//
//  Created by Evghenii Todorov on 4/4/18.
//  Copyright © 2018 Todorov Evghenii. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    private override init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "IndeemoTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createFeedItemEntityFrom(dictionary: [String: Any]) -> FeedItem? {
        let context = self.persistentContainer.viewContext
        if let feedItemEntity = NSEntityDescription.insertNewObject(forEntityName: "FeedItem", into: context) as? FeedItem {
            guard
                let id = dictionary["id"] as? Int64,
                let userId = dictionary["userId"] as? Int64,
                let title = dictionary["title"] as? String,
                let body = dictionary["body"] as? String
                else { return nil }
            
            feedItemEntity.id = id
            feedItemEntity.userId = userId
            feedItemEntity.title = title
            feedItemEntity.body = body
            
            return feedItemEntity
        }
        return nil
    }
    
    func applicationDocumentsDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }

}
