//
//  Variant+CoreDataProperties.swift
//  ECommerceApp
//
//  Created by Prateek Raj on 28/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

import Foundation
import CoreData


extension Variant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Variant> {
        return NSFetchRequest<Variant>(entityName: "Variant")
    }

    @NSManaged public var color: String?
    @NSManaged public var price: Int32
    @NSManaged public var size: Int32
    @NSManaged public var variantId: Int32
    @NSManaged public var products: Product?

}
