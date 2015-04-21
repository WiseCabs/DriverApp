//
//  ScheduleTravelDetails.h
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 17/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllocatedJourney.h"

@interface ScheduleTravelDetails : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIAlertViewDelegate>  {
	
    IBOutlet UITableView *mainTableView;
	IBOutlet UITableView *otherPickUpsTableView;
	IBOutlet UILabel *date;
	IBOutlet UILabel *time;
    IBOutlet UILabel *jnyStatusLbl;
    IBOutlet UIImageView *tableBackgroudImage;
    IBOutlet UIImageView *journeyImage;
	IBOutlet UIScrollView *scrollView;
    
	NSString *Totalfare;
	NSString *toAddress;
	NSString *fromAddress;
	NSString *journeyType;
	NSString *destination;
	NSString *originAddress;
	NSString *phoneNo;
    NSString *totalFare;
	NSString *totalPassenger;
    NSString *mapButton;
    
	AllocatedJourney *selectedJourney;
	BOOL journeyAcknowledged;
	BOOL isScheduled;
	BOOL onRoute;
	BOOL onBoard;
    
    
    
    
    IBOutlet UIButton *pickUpButton;
    IBOutlet UILabel *lblAddress;
    IBOutlet UILabel *fare;
    IBOutlet UILabel *customerName;
    IBOutlet UIButton *customerMobile;
    IBOutlet UILabel *additionalInfo;
    IBOutlet UILabel *lblDropOffNos;
}

@property(nonatomic, retain) NSString *mapButton;
@property(nonatomic, retain) NSString *phoneNo;
@property(nonatomic, retain) NSString *originAddress;
@property(nonatomic, retain) NSString *destination;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) UIAlertView *dropCancelledAlert;
@property(nonatomic, retain) UIAlertView *dropRejectedAlert;
@property (nonatomic, retain) NSString *Totalfare;
@property (nonatomic, retain) NSString *toAddress;
@property (nonatomic, retain) NSString *journeyType;
@property (nonatomic, retain) NSString *fromAddress;
@property (nonatomic, retain) IBOutlet UIImageView *tableBackgroudImage;

@property(nonatomic, retain) IBOutlet UILabel *jnyStatusLbl;
@property(nonatomic, retain) IBOutlet UILabel *date;
@property(nonatomic, retain) IBOutlet UILabel *time;
@property (nonatomic, retain) AllocatedJourney *selectedJourney;
@property(nonatomic, retain) IBOutlet UITableView *mainTableView;
@property(nonatomic, retain) IBOutlet UITableView *otherPickUpsTableView;
@property(nonatomic, retain) IBOutlet UIImageView *journeyImage;


@property(nonatomic,retain) IBOutlet UIButton *pickUpButton;
@property(nonatomic,retain) IBOutlet UILabel *lblAddress;
@property(nonatomic,retain) IBOutlet UILabel *fare;
@property(nonatomic,retain) IBOutlet UILabel *customerName;
@property(nonatomic,retain) IBOutlet UIButton *customerMobile;
@property(nonatomic,retain) IBOutlet UILabel *additionalInfo;
@property(nonatomic,retain) IBOutlet UILabel *lblDropOffNos;





















@property (nonatomic, readwrite) BOOL isScheduled;
@property (nonatomic, readwrite) BOOL journeyAcknowledged;
@property (nonatomic, readwrite) BOOL onRoute;
@property (nonatomic, readwrite) BOOL onBoard;

@property(nonatomic, retain) NSString *totalPassenger;
@property(nonatomic, retain) NSString *totalFare;

@property(nonatomic, retain) UIActionSheet *journeyAcknowledgedActionSheet ;
@property(nonatomic, retain) UIActionSheet *alreadyOnRouteActionSheet ;
@property(nonatomic, retain) UIActionSheet *alreadyOnBoardActionSheet ;

-(void)showMapAlert;
@end
