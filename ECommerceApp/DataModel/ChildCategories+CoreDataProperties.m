//
//  ChildCategories+CoreDataProperties.m
//  ECommerceApp
//
//  Created by Prateek Raj on 20/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

#import "ChildCategories+CoreDataProperties.h"

@implementation ChildCategories (CoreDataProperties)

+ (NSFetchRequest<ChildCategories *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ChildCategories"];
}

@dynamic categoryId;
@dynamic category;

@end
