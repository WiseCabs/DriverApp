//
//  ScheduleJourneydetail.h
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 16/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CoreLocation.h"
#import "AllocatedJourney.h"

@interface ScheduleJourneydetail :UIViewController <UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate,CoreLocationDelegate, UIActionSheetDelegate,CLLocationManagerDelegate>  {

	IBOutlet UITableView *mainTableView;
	NSMutableArray *travelarray;
	BOOL cameFromLoginPage;
	IBOutlet UISegmentedControl *segmentControl;
	NSMutableArray *todayTravelDetails;
	NSMutableArray *tomorrowTravelDetails;
	NSMutableArray *newJourneysArray;
	BOOL isScheduled;
	//NSArray *allJourney;
	
	NSTimer *updatetimer;
	//NSTimer *driverTimer;
	
	NSString *tabName;
	BOOL flag;
	BOOL firstTime;
	
	BOOL isRefreshingScheduled;
	BOOL isRefreshingCompleted;
	
	BOOL isLoggedIn;
	
	
	 MBProgressHUD *HUD;
	NSMutableSet * processed;
	NSMutableArray * uniqueArray; 
	NSString *tomorrowDate;
	NSString *todayDate ;
	NSMutableDictionary *jnyDict;
	NSMutableArray *groupedArray;
	NSString *toAddress;
	CoreLocation *locationController;
	NSString *latitude ;
	NSString *longitude;
	UIButton *button ;
     NSString *nonProtected;
	AllocatedJourney *selectJourney;
	
	BOOL journeyAcknowledged;
	//BOOL isNetworkAlertShowing;
	BOOL reloadTableView;
	BOOL alertShown;
    BOOL internetAlertShown;
    BOOL docExpired;
	
	UIAlertView *networkAlert;
	UIAlertView *logoutAlert ;
	UIAlertView *newJnyAlert ;
	UIActionSheet *acknowledgeJourneyActionSheet ;
	UIAlertView *dropRejectedAlert;
    UIAlertView *expirationAlert;
     NSString *expiryMessage;
	
	NSInteger newJourneyNo;
}
@property(nonatomic, readwrite) NSInteger newJourneyNo;

 @property (nonatomic, assign) BOOL internetAlertShown;
@property (nonatomic, assign) BOOL alertShown;
@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, assign) BOOL isRefreshingScheduled;
@property (nonatomic, assign) BOOL isRefreshingCompleted;
@property (nonatomic, assign) BOOL reloadTableView;
@property (nonatomic, assign)BOOL docExpired;

@property(nonatomic, strong) UIAlertView *networkAlert;
@property (nonatomic, strong) UIAlertView *logoutAlert ;
@property (nonatomic, strong) UIAlertView *newJnyAlert ;
@property (nonatomic, strong) UIAlertView *expirationAlert;
@property (nonatomic, readwrite) BOOL journeyAcknowledged;
@property (nonatomic, readwrite) BOOL dateChanged;
 @property(nonatomic,retain) NSString *expiryMessage;

//@property (nonatomic, assign) BOOL isNetworkAlertShowing;
@property (nonatomic, strong) UIButton *button ;
@property (nonatomic, strong) NSString *latitude ;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *toAddress ;

@property (nonatomic, strong) NSMutableArray *groupedArray;
@property (nonatomic, strong) NSMutableDictionary *jnyDict;
@property (nonatomic, strong) NSString *tomorrowDate;
@property (nonatomic, strong) NSString *todayDate ;
@property (nonatomic, strong) NSMutableArray * uniqueArray;
@property (nonatomic, strong) NSMutableSet * processed;
@property (nonatomic, strong) NSMutableArray *newJourneysArray;

@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSString *tabName;
@property (nonatomic, strong) NSString *nonProtected;
@property (nonatomic, strong) NSArray *travelarray;
//@property (nonatomic, strong) NSArray *allJourney;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, strong) NSArray *todayTravelDetails;
@property (nonatomic, strong) NSArray *tomorrowTravelDetails;
@property (nonatomic, assign) BOOL isScheduled;
@property (nonatomic, assign) BOOL cameFromLoginPage;
@property (nonatomic, strong) AllocatedJourney *selectJourney;

@property (nonatomic, retain) NSTimer *updatetimer;
//@property (nonatomic, strong) NSTimer *driverTimer ;

@property (nonatomic, readwrite) BOOL flag;
@property(nonatomic, strong) UIActionSheet *acknowledgeJourneyActionSheet ;
@property(nonatomic, strong) UIAlertView *dropRejectedAlert;

-(void) updateStatus: (NSString *)actionType;
//- (void)locationUpdate:(CLLocation *)location;
-(void)showConnectionAlert;
-(void) checkifLocationServiceEnabled;
-(void) takeAction: (NSString *)actionType;
-(BOOL)getExpiryDetails;

@end
