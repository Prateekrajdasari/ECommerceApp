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

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

