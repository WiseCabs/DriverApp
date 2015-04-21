//
//  Journey.h
//  driverApp
//
//  Created by Nagraj G on 23/11/11.
//  Copyright 2011 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Journey : NSObject {
	NSInteger JourneyID;
	
	NSString *FromAddress;
	NSString *ToAddress;
	
	NSString *Currency;
	NSInteger NumberOfPassenger;
	NSString *JourneyFare;
	NSInteger NumberOfBags;
	NSString *JourneyTime;
	NSString *customerName;
	NSString *customerMobile;
	NSString *customerInfo;
	NSString *hiddenJny;
    NSString *baseName;
    
    NSString *toHotSpot;
    NSString *fromHotSpot;
    
    BOOL isMultiDestination;
    NSMutableArray *multiDestAddresses;
}
@property (nonatomic,readwrite) BOOL isMultiDestination;
@property (nonatomic,retain)NSMutableArray *multiDestAddresses;

@property (nonatomic,retain)NSString *toHotSpot;
@property (nonatomic,retain)NSString *fromHotSpot;

@property (nonatomic,retain) NSString *baseName;
@property (nonatomic,retain) NSString *hiddenJny;

@property (nonatomic, retain) NSString *FromAddress;
@property (nonatomic, retain) NSString *ToAddress;

@property (nonatomic, retain) NSString *customerName;
@property (nonatomic, retain) NSString *customerMobile;
@property (nonatomic, retain) NSString *customerInfo;

@property (nonatomic, readwrite)  NSInteger JourneyID;
@property (nonatomic, retain) NSString *Currency;
@property (nonatomic, readwrite)  NSInteger NumberOfPassenger;
@property (nonatomic, readwrite)  NSInteger NumberOfBags;
@property (nonatomic, retain) NSString *JourneyFare;
@property (nonatomic, retain) NSString *JourneyTime;
@end
