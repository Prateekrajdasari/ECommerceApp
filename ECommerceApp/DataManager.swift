//
//  DataManager.swift
//  ECommerceApp
//
//  Created by Prateek Raj on 28/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

import UIKit
import CoreData

typealias DataRecord = [String: AnyObject]

class DataManager {
    
    public fileprivate(set) static var sharedInstance = DataManager()
    fileprivate let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func getArrayforEntity(_ entityString: String, filterwithPredicate predicate: String?, sortWithKey sortKey: String?, isAscending: Bool) -> [NSManagedObject] {
        guard let managedObjectContext = managedObjectContext else { return [] }
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityString)
        if let predicate = predicate {
            fetchRequest.predicate = NSPredicate(format: predicate, argumentArray: nil)
        }
        if let sortKey = sortKey {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: isAscending)]
        }
        var results = [AnyObject]()
        managedObjectContext.performAndWait {
            do {
                try results = managedObjectContext.fetch(fetchRequest)
            } catch {}
        }
        return results as? [NSManagedObject] ?? []
    }
    
    func checkIfDataAlreadyExists() -> Bool {
        let entities = ["Categories","ChildCategories","Product","Taxes","Variant"]
        
        for entity in entities {
            if getArrayforEntity(entity, filterwithPredicate: nil, sortWithKey: nil, isAscending: true).count == 0 {
                return false
            }
        }
        
        return true
    }
    
    func pushDataToCoreData(_ dataArray: DataRecord) {
        guard let managedObjectContext = managedObjectContext else { return }
        let categoriesArray: [DataRecord] = dataArray["categories"] as? [DataRecord] ?? []
        let rankingsArray: [DataRecord] = dataArray["rankings"] as? [DataRecord] ?? []
        var categories = [Categories]()
        for categoryData in categoriesArray {
            guard let category = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: managedObjectContext) as? Categories else { continue }
            category.categoryId = categoryData["id"] as? Int32 ?? 0
            category.name = categoryData["name"] as? String
            categories.append(category)
            
            if let productsData = categoryData["products"] as? [DataRecord], productsData.count > 0 {
                var products: Set<Product> = []
                for productData in productsData {
                    guard let product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: managedObjectContext) as? Product else { continue }
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    
                    product.productId = productData["id"] as? Int32 ?? 0
                    product.name = productData["name"] as? String
                    product.dateAdded = formatter.date(from: "date_added") as NSDate?
                    if let taxData = productData["tax"], let taxes = NSEntityDescription.insertNewObject(forEntityName: "Taxes", into: managedObjectContext) as? Taxes {
                        taxes.value = taxData["value"] as? Float ?? 0
                        taxes.name = taxData["name"] as? String
                        taxes.products = product
                        
                        var productVariantsSet: Set<Variant> = []
                        let productVariantsSetData: [DataRecord] = productData["variants"] as? [DataRecord] ?? []
                        
                        for variantData in productVariantsSetData {
                            guard let variant = NSEntityDescription.insertNewObject(forEntityName: "Variant", into: managedObjectContext) as? Variant else { continue }
                            variant.variantId = variantData["id"] as? Int32 ?? 0
                            let size = variantData["size"] as? Int32
                            variant.size = (size == nil) ? 0 : size!
                            variant.price = variantData["price"] as? Int32 ?? 0
                            variant.color = variantData["color"] as? String
                            variant.products = product
                            
                            productVariantsSet.insert(variant)
                        }
                        product.taxes = taxes
                        product.variants = productVariantsSet as NSSet
                    }
                    products.insert(product)
                }
                category.products = products as NSSet
                category.numberOfProducts = Int32(products.count)
            }
            
            if let childCategoriesData = categoryData["child_categories"] as? [Int], childCategoriesData.count > 0 {
                var childSet: Set<ChildCategories> = []
                for childCatData in childCategoriesData {
                    guard let childCategory = NSEntityDescription.insertNewObject(forEntityName: "ChildCategories", into: managedObjectContext) as? ChildCategories else { continue }
                    childCategory.categoryId = Int32(childCatData)
                    childCategory.category = category
                    childSet.insert(childCategory)
                    
                }
                category.childCategories = childSet as NSSet
                category.numberofChildCategories = Int32(childSet.count)
            }
        }
        
        for categoryData in categoriesArray {
            guard let catID = categoryData["id"] as? Int32, let category = categories.filter({ $0.categoryId == catID }).first else { continue }
            if let childCategoriesData = categoryData["child_categories"] as? [Int], childCategoriesData.count > 0 {
                var childrenSet = Set<Categories>()
                for childCatData in childCategoriesData {
                    
                    if let childCat = categories.filter ({ $0.categoryId == Int32(childCatData) }).first {
                        childCat.parentCategory = category
                        childrenSet.insert(childCat)
                    }
                }
                category.childrens = childrenSet as NSSet
            }
        }
        
        for rankData in rankingsArray {
            guard let products = rankData["products"] as? [DataRecord] else { continue }
            for productData in products {
                guard let productID = productData["id"] as? Int32 else { continue }
                
                let results = getArrayforEntity("Product", filterwithPredicate: "productId == \(productID)", sortWithKey: nil, isAscending: true)
                guard let product = results.first as? Product else { continue }
                if let viewCount = productData["view_count"] as? Int32 {
                    product.viewCount = viewCount
                } else if let orderCount = productData["order_count"] as? Int32 {
                    product.orderCount = orderCount
                } else if let shares = productData["shares"] as? Int32 {
                    product.shareCount = shares
                }
            }
        }
        
        AppDelegate.appDelegate.saveContext()
    }
    
    func removeAllExistingData() {
        
        let managedObjectContext = self.managedObjectContext
        let entities = ["Categories","ChildCategories","Product","Taxes","Variant"]
        for entity in entities {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            do {
                try AppDelegate.appDelegate.persistentContainer.persistentStoreCoordinator.execute(batchDeleteRequest, with: managedObjectContext!)
            } catch {
                print("Batch Deletion Failed for \(entity)")
            }
        }
    }
}
