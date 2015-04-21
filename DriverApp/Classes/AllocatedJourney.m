//
//  AllocatedJourney.m
//  driverApp
//
//  Created by Nagraj G on 23/11/11.
//  Copyright 2011 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import "AllocatedJourney.h"


@implementation AllocatedJourney
@synthesize  AllocatedJourneyID,JourneyDate,JourneyTime, NumberOfUsers,TotalNumberOfPassenger,JourneyFare,SubJourney,JourneyType;
@synthesize  Currency,IsTelephonicJourney,JourneyStatus,suppID,jnyDate,availStatus;

@synthesize ToAddress,FromAddress,hiddenJny,baseName,jnyTime;


- (void)dealloc {
    [baseName release];
	[hiddenJny release];
	[FromAddress release];
	[ToAddress release];
	[JourneyDate release];
	[JourneyTime release];
	[SubJourney release];
	[JourneyType release];
	[Currency release];
	[JourneyStatus release];
	[jnyDate release];
    [jnyTime release];
	[availStatus release];
	[super dealloc];
}

@end
