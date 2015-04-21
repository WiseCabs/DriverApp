//
//  AllocatedJourney.h
//  driverApp
//
//  Created by Nagraj G on 23/11/11.
//  Copyright 2011 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllocatedJourney : NSObject {
	
	NSInteger AllocatedJourneyID;
	
	NSString *JourneyDate;
	NSDate *jnyDate;
    NSDate *jnyTime;
	NSInteger JourneyFare;
	NSString *JourneyTime; 

	NSString *FromAddress;
	NSString *ToAddress;
    NSString *baseName;
	
	NSInteger NumberOfUsers;
	NSInteger TotalNumberOfPassenger;
	NSString *AJ_Shared_Dedicated_Status;
	NSArray *SubJourney;
	NSString *JourneyType;
    NSString *Currency;
	NSString *JourneyStatus;
	NSInteger suppID;
	BOOL IsTelephonicJourney;
	
	NSString *availStatus;
	NSString *hiddenJny;
}
@property (nonatomic, retain) NSString *availStatus;
@property (nonatomic,retain) NSString *hiddenJny;
@property (nonatomic,retain) NSString *baseName;

@property (nonatomic, readwrite) BOOL IsTelephonicJourney;
@property (nonatomic, readwrite) NSInteger AllocatedJourneyID;
@property (nonatomic, retain) NSString *JourneyDate;
@property (nonatomic, retain) NSDate *jnyDate;
@property (nonatomic, retain) NSDate *jnyTime;
@property (nonatomic, retain) NSString *JourneyTime; 

@property (nonatomic, retain) NSString *FromAddress;
@property (nonatomic, retain) NSString *ToAddress;

@property (nonatomic, readwrite) NSInteger NumberOfUsers;
@property (nonatomic, readwrite)  NSInteger TotalNumberOfPassenger;
@property (nonatomic, readwrite) NSInteger JourneyFare;
@property (nonatomic, retain) NSArray *SubJourney;
@property (nonatomic, retain) NSString *JourneyType;
@property (nonatomic, retain) NSString *Currency;
@property (nonatomic, retain) NSString *JourneyStatus;
@property (nonatomic, readwrite) NSInteger suppID;
@end
