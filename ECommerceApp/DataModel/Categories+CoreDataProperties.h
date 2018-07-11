//
//  Categories+CoreDataProperties.h
//  ECommerceApp
//
//  Created by Prateek Raj on 11/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

#import "Categories+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Categories (CoreDataProperties)

+ (NSFetchRequest<Categories *> *)fetchRequest;

@property (nonatomic) int16_t categoryId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<ChildCategories *> *childCategories;
@property (nullable, nonatomic, retain) NSSet<Product *> *products;

@end

@interface Categories (CoreDataGeneratedAccessors)

- (void)addChildCategoriesObject:(ChildCategories *)value;
- (void)removeChildCategoriesObject:(ChildCategories *)value;
- (void)addChildCategories:(NSSet<ChildCategories *> *)values;
- (void)removeChildCategories:(NSSet<ChildCategories *> *)values;

- (void)addProductsObject:(Product *)value;
- (void)removeProductsObject:(Product *)value;
- (void)addProducts:(NSSet<Product *> *)values;
- (void)removeProducts:(NSSet<Product *> *)values;

@end

NS_ASSUME_NONNULL_END
