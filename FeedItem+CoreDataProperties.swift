//
//  FeedItem+CoreDataProperties.swift
//  
//
//  Created by Evghenii Todorov on 4/4/18.
//
//

import Foundation
import CoreData


extension FeedItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedItem> {
        return NSFetchRequest<FeedItem>(entityName: "FeedItem")
    }

    @NSManaged public var id: Int64
    @NSManaged public var userId: Int64
    @NSManaged public var title: String?
    @NSManaged public var body: String?

}
