//
//  Product+CoreDataClass.h
//  ECommerceApp
//
//  Created by Prateek Raj on 20/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Categories, Taxes, Variant;

NS_ASSUME_NONNULL_BEGIN

@interface Product : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Product+CoreDataProperties.h"
