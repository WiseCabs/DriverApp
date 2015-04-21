//
//  Journey.m
//  driverApp
//
//  Created by Nagraj G on 23/11/11.
//  Copyright 2011 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import "Journey.h"


@implementation Journey
@synthesize JourneyID,NumberOfPassenger,JourneyFare,NumberOfBags,JourneyTime;
@synthesize Currency,customerName,customerMobile,customerInfo,hiddenJny,baseName,toHotSpot,fromHotSpot,multiDestAddresses,isMultiDestination;

@synthesize FromAddress,ToAddress;

- (void)dealloc {
    [multiDestAddresses release];
    [toHotSpot release];
    [fromHotSpot release];
    [baseName release];
	[FromAddress release];
	[ToAddress release];
	[JourneyFare release];
	[JourneyTime release];
	[Currency release];
	[customerInfo release];
	[customerName release];
	[customerMobile release];
	[hiddenJny release];
	[super dealloc];
}

@end
