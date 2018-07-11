//
//  ServiceManager.m
//  ECommerceApp
//
//  Created by Prateek Raj on 10/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

#import "ServiceManager.h"

static ServiceManager *sharedInstance = nil;

@implementation ServiceManager

+ (ServiceManager *) sharedInstance {
    
    @synchronized([ServiceManager class]) {
        
        if (!sharedInstance) {
            
            sharedInstance = [[self alloc] init];
            
        }
        return sharedInstance;
    }
    return nil;
}

-(void)getDataFromServer {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://stark-spire-93433.herokuapp.com/json"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    
                                                    if (error) {
                                                        
                                                        NSLog(@"%@", error);
                                                    } else {
                                                       
                                                        NSJSONSerialization *responseJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                                        
                                                        NSLog(@"%@", responseJson);
                                                    }
                                                }];
    [dataTask resume];
}


- (void)pushDataToCoreData:(NSArray *) dataArray {
    
    NSArray *categoriesArray = dataArray[0];
    NSArray *rankingsArray = dataArray[1];
    
    for (NSDictionary *categoryDict in categoriesArray) {
        
        Categories *category = (Categories *)[[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Categories"
                                                                                                 inManagedObjectContext:APPDELEGATE.managedObjectContext]
                                        insertIntoManagedObjectContext:APPDELEGATE.managedObjectContext];
        
        category.categoryId = [categoryDict[@"id"] intValue];
        category.name = categoryDict[@"name"];
        
        for (NSDictionary *productDict in categoryDict[@"products"]) {
            
            Product *product = (Product *)[[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Product"
                                                                                              inManagedObjectContext:APPDELEGATE.managedObjectContext]
                                                          insertIntoManagedObjectContext:APPDELEGATE.managedObjectContext];
            
            product.productId = [productDict[@"id"] intValue];
            product.name = categoryDict[@"name"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
            
            product.dateAdded = [formatter dateFromString:productDict[@"date_added"]];
            
            
            
//            float taxPercent = [productDict[@"tax"][@"value"] floatValue];
//            NSString *taxName = productDict[@"tax"][@"name"];
            
            for (NSDictionary *variantDict in productDict[@"variants"]) {
                
                Variant *variant = (Variant *)[[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Variant"
                                                                                                  inManagedObjectContext:APPDELEGATE.managedObjectContext]
                                                       insertIntoManagedObjectContext:APPDELEGATE.managedObjectContext];
                variant.variantId = [variantDict[@"id"] intValue];
                variant.size= [variantDict[@"size"] intValue];
                variant.price = [variantDict[@"price"] intValue];
                variant.color = variantDict[@"color"];
            }
        }
    }
}

@end



























































