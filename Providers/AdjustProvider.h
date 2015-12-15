//
//  AdjustProvider.h
//
//  Created by Engin Kurutepe on 10/11/2014.
//  Copyright (c) 2014 Engin Kurutepe. All rights reserved.
//

#import "ARAnalyticalProvider.h"

@protocol AdjustDelegate;

@interface AdjustProvider : ARAnalyticalProvider

-(instancetype)initWithIdentifier:(NSString *)identifier andConfigurationDelegate:(id<AdjustDelegate>)delegate;

@end
