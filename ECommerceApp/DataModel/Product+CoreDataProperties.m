//
//  Product+CoreDataProperties.m
//  ECommerceApp
//
//  Created by Prateek Raj on 20/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

#import "Product+CoreDataProperties.h"

@implementation Product (CoreDataProperties)

+ (NSFetchRequest<Product *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Product"];
}

@dynamic dateAdded;
@dynamic name;
@dynamic orderCount;
@dynamic productId;
@dynamic shareCount;
@dynamic viewCount;
@dynamic category;
@dynamic taxes;
@dynamic variants;

@end
