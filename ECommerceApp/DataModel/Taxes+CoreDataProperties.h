//
//  Taxes+CoreDataProperties.h
//  ECommerceApp
//
//  Created by Prateek Raj on 11/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//
//

#import "Taxes+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Taxes (CoreDataProperties)

+ (NSFetchRequest<Taxes *> *)fetchRequest;

@property (nonatomic) float value;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) Product *products;

@end

NS_ASSUME_NONNULL_END
