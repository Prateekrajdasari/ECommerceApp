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
        
        if (!sharedInstance)            
            sharedInstance = [[self alloc] init];

        return sharedInstance;
    }
    return nil;
}

- (void)getDataFromServer {
    
    if (![DATAMANAGER checkIfDataAlreadyExists]) {
        
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
                                                            
                                                            [DATAMANAGER removeAllExistingData];
                                                            
                                                            [DATAMANAGER pushDataToCoreData:(NSDictionary *)responseJson];
                                                        }
                                                    }];
        [dataTask resume];
    }
}







@end



























































