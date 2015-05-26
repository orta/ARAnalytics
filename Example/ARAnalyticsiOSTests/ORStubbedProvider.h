//
//  ORStubbedProvider.h
//  ARAnalyticsTests
//
//  Created by Orta on 3/25/14.
//  Copyright (c) 2014 Orta Therox. All rights reserved.
//

#import "ARAnalyticalProvider.h"

@interface ORStubbedProvider : ARAnalyticalProvider

@property (readonly, nonatomic, copy) NSString *lastProviderIdentifier;

@property (readonly, nonatomic, copy) NSString *lastEventName;
@property (readonly, nonatomic, copy) NSDictionary *lastEventProperties;

@property (readonly, nonatomic, copy) NSString *lastUserPropertyValue;
@property (readonly, nonatomic, copy) NSString *lastUserPropertyKey;
@property (readonly, nonatomic, assign) NSInteger lastUserPropertyCount;

@property (readonly, nonatomic, copy) NSString *email;
@property (readonly, nonatomic, copy) NSString *identifier;

@property (readonly, nonatomic, strong) NSError *lastError;
@property (readonly, nonatomic, copy) NSString *lastErrorMessage;

@property (readonly, nonatomic, strong) UINavigationController *lastMonitoredNavigationController;

@property (readonly, nonatomic, copy) NSString *lastRemoteLog;

@end
