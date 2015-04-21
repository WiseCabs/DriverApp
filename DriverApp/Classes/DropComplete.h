//
//  DropComplete.h
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 23/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DropComplete : UIViewController {
	IBOutlet UITextField *totalFareCollected;
	IBOutlet UITextField *totalpassengers;

	NSInteger allocatedJourneyID;
	NSInteger userId;
	NSInteger supplierId; 
	NSString *totalPassenger;
	NSString *totalfare;
	
}
@property(nonatomic, retain) IBOutlet UITextField *totalFareCollected;
@property(nonatomic, retain) IBOutlet UITextField *totalpassengers;

@property(nonatomic, readwrite) NSInteger allocatedJourneyID;
@property(nonatomic, readwrite) NSInteger userId;
@property(nonatomic, readwrite)NSInteger supplierId;

@property(nonatomic, retain) NSString *totalPassenger;
@property(nonatomic, retain) NSString *totalfare;

-(IBAction) DropDone:(id)sender;

@end
