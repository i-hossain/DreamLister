//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Ismail Hossain on 2017-07-29.
//  Copyright © 2017 Ismail Hossain. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }

}
