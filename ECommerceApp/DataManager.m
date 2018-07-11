//
//  DataManager.m
//  ECommerceApp
//
//  Created by Prateek Raj on 10/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

#import "DataManager.h"

static DataManager *sharedInstance = nil;

@implementation DataManager

+ (DataManager *) sharedInstance {
    
    @synchronized([DataManager class]) {
        
        if (!sharedInstance) {
            
            sharedInstance = [[self alloc] init];
            
        }
        return sharedInstance;
    }
    return nil;
}

-(NSArray *)getArrayforEntity:(NSString *)entityString filterwithPredicate:(NSString *)predicate sortWithKey:(NSString *)sortKey isAscending:(BOOL)isAscending {
    
    NSError *error;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityString];
    
    fetchRequest.predicate = predicate ? [NSPredicate predicateWithFormat:predicate] : nil;
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:isAscending]];
    
    return [APPDELEGATE.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

@end
