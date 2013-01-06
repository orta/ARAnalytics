//
//  FlurryProvider.m
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "FlurryProvider.h"

@implementation FlurryProvider
#ifdef AR_FLURRY_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([Flurry class], @"Flurry is not included");
    [Flurry startSession:identifier];

    self = [super init];
    return self;
}

- (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email {
    if (email) {
        [Flurry setUserID:email];
    }
    [Flurry setUserID:id];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [Flurry logEvent:event withParameters:properties];
}

- (void)didShowNewViewController:(UIViewController *)controller {
    [self event:@"Screen view" withProperties:@{ @"screen": controller.title }];
    [Flurry logPageView];
}


#endif
@end
