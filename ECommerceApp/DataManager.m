//
//  DataManager.m
//  ECommerceApp
//
//  Created by Prateek Raj on 10/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

#import "DataManager.h"

static DataManager *sharedInstance = nil;

@implementation DataManager

+ (DataManager *) sharedInstance {
    
    @synchronized([DataManager class]) {
        
        if (!sharedInstance)
            sharedInstance = [[self alloc] init];
            
        return sharedInstance;
    }
    return nil;
}

- (NSArray *)getArrayforEntity:(NSString *)entityString filterwithPredicate:(NSString *)predicate sortWithKey:(NSString *)sortKey isAscending:(BOOL)isAscending {
    
    NSError *error;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityString];
    
    fetchRequest.predicate = predicate ? [NSPredicate predicateWithFormat:predicate] : nil;
    fetchRequest.sortDescriptors = sortKey ? [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:isAscending]] : nil;
    
    return [APPDELEGATE.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (void)pushDataToCoreData:(NSDictionary *) dataArray {
        
    NSArray *categoriesArray = dataArray[@"categories"];
    NSArray *rankingsArray = dataArray[@"rankings"];
    
    for (NSDictionary *categoryDict in categoriesArray) {
        
        Categories *category = (Categories *) [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Categories"
                                                                                                  inManagedObjectContext:APPDELEGATE.managedObjectContext]
                                                       insertIntoManagedObjectContext:APPDELEGATE.managedObjectContext];
        
        category.categoryId = [categoryDict[@"id"] intValue];
        category.name = categoryDict[@"name"];
        
        if ([(NSArray *)categoryDict[@"products"] count]) {
            
            NSMutableSet *productsSet = [NSMutableSet set];
            
            for (NSDictionary *productDict in categoryDict[@"products"]) {
                
                Product *product = (Product *)[[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Product"
                                                                                                  inManagedObjectContext:APPDELEGATE.managedObjectContext]
                                                       insertIntoManagedObjectContext:APPDELEGATE.managedObjectContext];
                
                product.productId = [productDict[@"id"] intValue];
                product.name = productDict[@"name"];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                formatter.dateFormat = @"yyyy-MM-dd";
                
                product.dateAdded = [formatter dateFromString:[productDict[@"date_added"] componentsSeparatedByString:@"T"][0]];
                
                Taxes *taxes = (Taxes *)[[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Taxes"
                                                                                            inManagedObjectContext:APPDELEGATE.managedObjectContext]
                                                 insertIntoManagedObjectContext:APPDELEGATE.managedObjectContext];
                
                taxes.value = [productDict[@"tax"][@"value"] floatValue];
                taxes.name = productDict[@"tax"][@"name"];
                
                taxes.products = product;
                
                NSMutableSet *productVariantsSet = [NSMutableSet set];
                
                for (NSDictionary *variantDict in productDict[@"variants"]) {
                    
                    Variant *variant = (Variant *)[[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Variant"
                                                                                                      inManagedObjectContext:APPDELEGATE.managedObjectContext]
                                                           insertIntoManagedObjectContext:APPDELEGATE.managedObjectContext];
                    variant.variantId = [variantDict[@"id"] intValue];
                    variant.size= variantDict[@"size"] == nil || variantDict[@"size"] == [NSNull null] ? 0 : [variantDict[@"size"] intValue];
                    variant.price = [variantDict[@"price"] intValue];
                    variant.color = variantDict[@"color"];
                    
                    variant.products = product;
                    
                    [productVariantsSet addObject:variant];
                }
                
                product.taxes = taxes;
                product.variants = productVariantsSet;
                
                [productsSet addObject:product];
            }
            
            category.products = productsSet;
            category.numberOfProducts = (int)productsSet.count;
        }
        
        if ([(NSArray *)categoryDict[@"child_categories"] count]) {
            
            NSMutableSet *childSet = [NSMutableSet set];
            
            for (int i=0; i<[(NSArray *)categoryDict[@"child_categories"] count]; i++) {
                
                ChildCategories *childCategory = (ChildCategories *)[[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"ChildCategories"
                                                                                                                        inManagedObjectContext:APPDELEGATE.managedObjectContext]
                                                                             insertIntoManagedObjectContext:APPDELEGATE.managedObjectContext];
                
                childCategory.categoryId = [categoryDict[@"child_categories"][i] intValue];
                childCategory.category = category;
                
                [childSet addObject:childCategory];
            }
            category.childCategories = childSet;
            category.numberofChildCategories = (int)childSet.count;
        }
    }
    
    for (NSDictionary *rankDict in rankingsArray) {
        
        for (NSDictionary *productsDict in rankDict[@"products"]) {
            
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
            
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"productId == %d",[productsDict[@"id"] intValue]];
            
            Product *product = [APPDELEGATE.managedObjectContext executeFetchRequest:fetchRequest error:nil][0];
            
            if (productsDict[@"view_count"]) {
                
                product.viewCount = [productsDict[@"view_count"] intValue];
            } else if (productsDict[@"order_count"]) {
                
                product.orderCount = [productsDict[@"order_count"] intValue];
            } else {
                
                product.shareCount = [productsDict[@"shares"] intValue];
            }
        }
    }
    
    [APPDELEGATE saveContext];
    
    [self printSavedData];
}


/*!
 * @discussion Check if all the entities are filled with appropriate values
 * @return Return Yes if all the entities of the database are filled with data or No if the entities in database are empty or only few entities are filled.
 */
- (BOOL)checkIfDataAlreadyExists {
    
    BOOL allDataExists = YES;
    
    NSError *error;
    
    NSArray *entities = @[@"Categories",@"ChildCategories",@"Product",@"Taxes",@"Variant"];
    
    for (NSString *entityName in entities) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
        
        NSArray *records = [APPDELEGATE.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if (records.count == 0) {
            
            allDataExists = NO;
            break;
        }
    }
    return allDataExists;
}

- (void)printSavedData{
    
    NSError *error;
    
    NSArray *entities = @[@"Categories",@"ChildCategories",@"Product",@"Taxes",@"Variant"];
    
    for (NSString *entityName in entities) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
        
        NSArray *records = [APPDELEGATE.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        for (id record in records) {
            
            NSLog(@"%@",record);
        }
    }
}


- (void)removeAllExistingData {
    
    NSArray *entities = @[@"Categories",@"ChildCategories",@"Product",@"Taxes",@"Variant"];
    
    for (NSString *entityName in entities) {
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
        NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
        
        NSError *error = nil;
        
        [APPDELEGATE.persistentContainer.persistentStoreCoordinator executeRequest:delete withContext:APPDELEGATE.managedObjectContext error:&error];
    }
}

@end
