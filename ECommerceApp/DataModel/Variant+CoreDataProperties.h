//
//  Variant+CoreDataProperties.h
//  ECommerceApp
//
//  Created by Prateek Raj on 11/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

#import "Variant+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Variant (CoreDataProperties)

+ (NSFetchRequest<Variant *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *color;
@property (nonatomic) int16_t price;
@property (nonatomic) int16_t size;
@property (nonatomic) int16_t variantId;
@property (nullable, nonatomic, retain) Product *products;

@end

NS_ASSUME_NONNULL_END
