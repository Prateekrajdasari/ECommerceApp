//
//  ChildCategories+CoreDataProperties.swift
//  ECommerceApp
//
//  Created by Prateek Raj on 28/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

import Foundation
import CoreData


extension ChildCategories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChildCategories> {
        return NSFetchRequest<ChildCategories>(entityName: "ChildCategories")
    }

    @NSManaged public var categoryId: Int32
    @NSManaged public var category: Categories?

}
