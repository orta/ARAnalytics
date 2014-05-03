//
//  ARAnalyticsDSLTests.m
//  ARAnalyticsTests
//
//  Created by Ash Furrow on 2014-05-02.
//  Copyright (c) 2014 Orta Therox. All rights reserved.
//

#import <ARAnalytics/ARAnalytics.h>
#import <ARAnalytics/ARDSL.h>

SpecBegin(ARAnalyticsDSLTests)

pending(@"calls super");

describe(@"tracked screens", ^{
    pending(@"throws on invalid selector");
    pending(@"throws on unknown class not specifying a selector");
    pending(@"effects a tracking page view");
});

describe(@"tracked events", ^{
    pending(@"throws on unspecified selector");
    pending(@"effects a tracking page view");
});

SpecEnd