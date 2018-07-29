//
//  Product+CoreDataProperties.swift
//  ECommerceApp
//
//  Created by Prateek Raj on 28/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var dateAdded: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var orderCount: Int32
    @NSManaged public var productId: Int32
    @NSManaged public var shareCount: Int32
    @NSManaged public var viewCount: Int32
    @NSManaged public var category: Categories?
    @NSManaged public var taxes: Taxes?
    @NSManaged public var variants: NSSet?

}

// MARK: Generated accessors for variants
extension Product {

    @objc(addVariantsObject:)
    @NSManaged public func addToVariants(_ value: Variant)

    @objc(removeVariantsObject:)
    @NSManaged public func removeFromVariants(_ value: Variant)

    @objc(addVariants:)
    @NSManaged public func addToVariants(_ values: NSSet)

    @objc(removeVariants:)
    @NSManaged public func removeFromVariants(_ values: NSSet)

}
