//
//  GoogleProvider.h
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "ARAnalyticalProvider.h"

@interface GoogleAnalyticsProvider : ARAnalyticalProvider

/***
 * These dictionaries map custom names to GAI customDimensions and customMetrics
 * i.e. @{@"FooDimension":[GAIFields customDimensionForIndex:1], @"BarDimension":[GAIFields customDimensionForIndex:2]}
 */
@property (nonatomic, strong) NSDictionary *customDimensionMappings;
@property (nonatomic, strong) NSDictionary *customMetricMappings;


@end
