//
//  Variant+CoreDataProperties.m
//  ECommerceApp
//
//  Created by Prateek Raj on 11/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

#import "Variant+CoreDataProperties.h"

@implementation Variant (CoreDataProperties)

+ (NSFetchRequest<Variant *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Variant"];
}

@dynamic color;
@dynamic price;
@dynamic size;
@dynamic variantId;
@dynamic products;

@end
