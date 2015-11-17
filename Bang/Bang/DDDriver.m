//
//  DDDriver.m
//  TripDemo
//
//  Created by yi chen on 4/3/15.
//  Copyright (c) 2015 AutoNavi. All rights reserved.
//

#import "DDDriver.h"

@implementation DDDriver

+ (instancetype)driverWithID:(NSString *)idInfo coordinate:(CLLocationCoordinate2D)coordinate
{
    return [[self alloc] initWithID:idInfo coordinate:coordinate];
}

+ (instancetype)driverWithID:(NSString *)idInfo coordinate:(CLLocationCoordinate2D)coordinate tag:(id)tag
{
    return [[self alloc] initWithID:idInfo coordinate:coordinate tag:tag];
}


- (id)initWithID:(NSString *)idInfo coordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        self.idInfo = idInfo;
        self.coordinate = coordinate;
    }
    return self;
}

- (id)initWithID:(NSString *)idInfo coordinate:(CLLocationCoordinate2D)coordinate tag:(id)tag
{
    if (self = [super init])
    {
        self.idInfo = idInfo;
        self.coordinate = coordinate;
        self.tag = tag;
    }
    return self;
}

@end
