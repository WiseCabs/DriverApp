//
//  JourneyDateWise.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 27/07/12.
//  Copyright 2012 Apppli. All rights reserved.
//

#import "JourneyDateWise.h"


@implementation JourneyDateWise
@synthesize allocatedJny,date;


- (void)dealloc {
	[allocatedJny release];
	[date release];
	[super dealloc];
}
@end
