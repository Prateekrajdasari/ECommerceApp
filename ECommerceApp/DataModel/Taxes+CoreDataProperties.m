//
//  Taxes+CoreDataProperties.m
//  ECommerceApp
//
//  Created by Prateek Raj on 11/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

#import "Taxes+CoreDataProperties.h"

@implementation Taxes (CoreDataProperties)

+ (NSFetchRequest<Taxes *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Taxes"];
}

@dynamic value;
@dynamic name;
@dynamic products;

@end
