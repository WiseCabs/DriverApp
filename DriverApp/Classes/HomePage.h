//
//  HomePage.h
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 15/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"MBProgressHUD.h"

@interface HomePage : UIViewController <UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate>  {
	NSString *scheduledJourneyCount;
	NSString *completedJourneyCount;
	NSInteger userID;
	UITableView *maintableView;
	NSTimer *updatetimer;
	BOOL flag;
    MBProgressHUD *HUD;
}
@property(nonatomic,retain)UITableView *maintableView;
@property(nonatomic, retain) NSString * scheduledJourneyCount;
@property(nonatomic, retain) NSString * completedJourneyCount;
@property(nonatomic, readwrite) NSInteger userID;
@property (nonatomic, retain) NSTimer *updatetimer;
@property (nonatomic, readwrite) BOOL flag;
-(void)showUpdate:(NSString*)lable detailtext:(NSString*)detailsText;
@end
