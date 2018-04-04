//
//  FeedTableViewController.swift
//  IndeemoTest
//
//  Created by Evghenii Todorov on 4/3/18.
//  Copyright © 2018 Todorov Evghenii. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class FeedTableViewController: UITableViewController {
    
    lazy var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: FeedItem.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Feed", value: "Feed", comment: "")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FeedItemCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
        update()
    }
    
    // MAKR: - Network
    
    func clearData() {
        do {
            let context = CoreDataManager.shared.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FeedItem")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map { $0.map { context.delete($0) } }
                CoreDataManager.shared.saveContext()
            } catch let error {
                print("error : \(error)")
            }
        }
    }
    
    func loadFeed() {
        API().fetchFeed(success: { [weak self] json in
            self?.clearData()
            
            var feed: [FeedItem] = []
            if let json = json {
                for jsonObject in json {
                    if let feedItem = CoreDataManager.shared.createFeedItemEntityFrom(dictionary: jsonObject) {
                        feed.append(feedItem)
                    }
                }
            }
            
            print("feed = \(feed.debugDescription)")

            do {
                try CoreDataManager.shared.persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        }) { error in
            print("error = \(error.localizedDescription)")
        }        
    }
    
    func update() {
        do {
            try self.fetchedResultController.performFetch()
        } catch let error  {
            print("error: \(error)")
        }
        
        loadFeed()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?.first?.numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItemCell", for: indexPath)
        
        if let item = fetchedResultController.object(at: indexPath) as? FeedItem {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = item.title
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = fetchedResultController.object(at: indexPath) as? FeedItem {
            performSegue(withIdentifier: "ListToDetails", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? FeedDetailsTableViewController, let item = sender as? FeedItem {
            controller.feedItem = item
        }
    }
}

extension FeedTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
}
