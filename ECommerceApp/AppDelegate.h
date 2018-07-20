//
//  AppDelegate.h
//  ECommerceApp
//
//  Created by Prateek Raj on 09/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) UIStoryboard *storyBoard;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)saveContext;


@end

