//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Ismail Hossain on 2017-07-29.
//  Copyright © 2017 Ismail Hossain. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
