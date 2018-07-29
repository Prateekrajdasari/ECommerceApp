//
//  Categories+CoreDataProperties.swift
//  ECommerceApp
//
//  Created by Prateek Raj on 29/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var categoryId: Int32
    @NSManaged public var name: String?
    @NSManaged public var numberofChildCategories: Int32
    @NSManaged public var numberOfProducts: Int32
    @NSManaged public var childCategories: NSSet?
    @NSManaged public var products: NSSet?
    @NSManaged public var parentCategory: Categories?
    @NSManaged public var childrens: NSSet?

}

// MARK: Generated accessors for childCategories
extension Categories {

    @objc(addChildCategoriesObject:)
    @NSManaged public func addToChildCategories(_ value: ChildCategories)

    @objc(removeChildCategoriesObject:)
    @NSManaged public func removeFromChildCategories(_ value: ChildCategories)

    @objc(addChildCategories:)
    @NSManaged public func addToChildCategories(_ values: NSSet)

    @objc(removeChildCategories:)
    @NSManaged public func removeFromChildCategories(_ values: NSSet)

}

// MARK: Generated accessors for products
extension Categories {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}

// MARK: Generated accessors for childrens
extension Categories {

    @objc(addChildrensObject:)
    @NSManaged public func addToChildrens(_ value: Categories)

    @objc(removeChildrensObject:)
    @NSManaged public func removeFromChildrens(_ value: Categories)

    @objc(addChildrens:)
    @NSManaged public func addToChildrens(_ values: NSSet)

    @objc(removeChildrens:)
    @NSManaged public func removeFromChildrens(_ values: NSSet)

}
