//
//  ChildCategories+CoreDataProperties.h
//  ECommerceApp
//
//  Created by Prateek Raj on 11/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

#import "ChildCategories+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChildCategories (CoreDataProperties)

+ (NSFetchRequest<ChildCategories *> *)fetchRequest;

@property (nullable, nonatomic, retain) Categories *category;

@end

NS_ASSUME_NONNULL_END
