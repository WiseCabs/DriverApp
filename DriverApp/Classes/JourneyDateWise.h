//
//  JourneyDateWise.h
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 27/07/12.
//  Copyright 2012 Apppli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllocatedJourney.h"

@interface JourneyDateWise : NSObject {
	AllocatedJourney *allocatedJny;
	NSString *date;
	
}
@property (nonatomic, retain) AllocatedJourney *allocatedJny;
@property (nonatomic, retain) NSString *date;
@end
