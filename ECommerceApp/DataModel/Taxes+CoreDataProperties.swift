//
//  Taxes+CoreDataProperties.swift
//  ECommerceApp
//
//  Created by Prateek Raj on 28/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

import Foundation
import CoreData


extension Taxes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Taxes> {
        return NSFetchRequest<Taxes>(entityName: "Taxes")
    }

    @NSManaged public var name: String?
    @NSManaged public var value: Float
    @NSManaged public var products: Product?

}
