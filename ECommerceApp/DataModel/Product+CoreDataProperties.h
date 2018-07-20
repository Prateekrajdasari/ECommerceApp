//
//  Product+CoreDataProperties.h
//  ECommerceApp
//
//  Created by Prateek Raj on 20/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

#import "Product+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Product (CoreDataProperties)

+ (NSFetchRequest<Product *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *dateAdded;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int32_t orderCount;
@property (nonatomic) int32_t productId;
@property (nonatomic) int32_t shareCount;
@property (nonatomic) int32_t viewCount;
@property (nullable, nonatomic, retain) Categories *category;
@property (nullable, nonatomic, retain) Taxes *taxes;
@property (nullable, nonatomic, retain) NSSet<Variant *> *variants;

@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addVariantsObject:(Variant *)value;
- (void)removeVariantsObject:(Variant *)value;
- (void)addVariants:(NSSet<Variant *> *)values;
- (void)removeVariants:(NSSet<Variant *> *)values;

@end

NS_ASSUME_NONNULL_END
