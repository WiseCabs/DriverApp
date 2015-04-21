//
//  NextPickUpDetails.h
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 02/08/12.
//  Copyright 2012 Apppli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllocatedJourney.h"

@interface NextPickUpDetails : UIViewController {

	AllocatedJourney *selectedJourney;
	IBOutlet UIImageView *tableBackgroudImage;
	IBOutlet UITableView *pickUpTableView;
	NSMutableArray *pickUpsArray;
	NSInteger pickUpButtonNo;
	NSInteger dropOffButtonNo;
	NSInteger selectedRow;
	NSString *journeyType;
	NSInteger secondMobileNo;
	NSInteger thirdMobileNo;
}
@property (nonatomic, retain) AllocatedJourney *selectedJourney;
@property (nonatomic, retain) IBOutlet UIImageView *tableBackgroudImage;
@property (nonatomic, retain) IBOutlet UITableView *pickUpTableView;
@property (nonatomic, retain) NSMutableArray *pickUpsArray;
@property (nonatomic, retain) NSString *journeyType;

@end
